//
//  ScriptController.m
//  iTunesCheck
//
//  Created by StormSilver on 9/1/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//

#import "ScriptController.h"


@implementation ScriptController

+ (id) sharedController
{
    static id sharedController;
    
    if (!sharedController)
    {
        sharedController = [[self alloc] init];
    }
    
    return sharedController;
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        ps = [[NSAppleScript alloc] initWithSource:@"do shell script \"ps -x -o state,command -ww\""];
        [ps compileAndReturnError:nil];
        
        playing = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:
            [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Scripts/iTunesPlaying.scpt"]] error:nil];
    }
    
    return self;
}

- (void) dealloc
{
    [ps release];
    [playing release];
    
    [super dealloc];
}

- (BOOL) iTunesRunning
{
    BOOL rval = NO;

	NSDictionary *errorDict = [[NSDictionary alloc] init];    
    NSString *rps = [[ps executeAndReturnError:&errorDict] stringValue];
	[errorDict release];
	
    NSArray *processes = [rps componentsSeparatedByString:@"\n"];
    
    for (int i = 0; i < [processes count]; ++i)
    {
        NSString *currProc = [processes objectAtIndex:i];
        
        NSRange range = [currProc rangeOfString:@"/Contents/MacOS/iTunes "];
        
        if (!NSEqualRanges(range, NSMakeRange(NSNotFound, 0)))
        {
            if ([currProc characterAtIndex:0] == 'S')
            {
                rval = YES;
                i = [processes count];
            }
        }
    }
    
    return rval;
}

- (BOOL) iTunesPlaying
{
    BOOL rval = NO;
    
    if ([self iTunesRunning])
    {
		NSDictionary *errorDict = [[NSDictionary alloc] init];
		int rplaying = [[playing executeAndReturnError:&errorDict] int32Value];
		[errorDict release];

        
        if (!rplaying)
        {
            rval = YES;
        }
    }
    
    return rval;
}



/*
 *  returns:
 *      0 = not running
 *      1 = not playing
 *      2 = playing
 *
 */
- (int) iTunesState
{
    int rval = 0;
    
    if ([self iTunesRunning])
    {
        if ([self iTunesPlaying])
        {
            rval = 2;
        }
        else
        {
            rval = 1;
        }
    }
    
    return rval;
}

- (NSAppleEventDescriptor *) doAppleScript:(NSString *)script
{
    NSURL *url;
	NSAppleScript *theScript;
	NSString *appleScriptPath;
	NSAppleEventDescriptor *desc;
	NSDictionary *errorDict = [[NSDictionary alloc] init];

	appleScriptPath = [[[NSBundle mainBundle] resourcePath] 
							stringByAppendingPathComponent:[NSString stringWithFormat:@"Scripts/%@.scpt", script]];
    url = [NSURL fileURLWithPath:appleScriptPath];
	
    theScript = [[NSAppleScript alloc] initWithContentsOfURL:url error:&errorDict];
    if (!theScript)
    {
        [theScript release];
        [errorDict release];
        return nil;
    }
	 
    desc = [theScript executeAndReturnError:&errorDict];
    if (!desc)
    {
        [desc release];
        [theScript release];
        return nil;
    }
	
	[theScript release];
	[errorDict release];
	
	return desc;
}

- (NSAppleEventDescriptor *) search:(NSString *)search inPlaylist:(NSString *)playlist
{
    //First we'll set up the path to the AppleScript we need to run
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Scripts/findSong.applescript"];
    NSMutableString *findScript = [NSMutableString stringWithContentsOfFile:path];
    
    //Then we'll enter the user's search string into the script
    [findScript replaceOccurrencesOfString:@"searchValue" withString:search options:NSLiteralSearch range:NSMakeRange(0, [findScript length])];
    //And we'll enter the user's selected playlist into the script
    [findScript replaceOccurrencesOfString:@"playlistValue" withString:playlist options:NSLiteralSearch range:NSMakeRange(0, [findScript length])];
    
    //then we'll run it
	NSAppleScript *theScript = [[NSAppleScript alloc] initWithSource:findScript];
	NSDictionary *errorDict = [[NSDictionary alloc] init];
    NSAppleEventDescriptor *rval = [theScript executeAndReturnError:&errorDict];
    if (!rval)
    {
        NSLog(@"Search error!\n%@", errorDict);
        [rval release];
        [theScript release];
        return nil;
    }
	[errorDict release];
	[theScript release];
    
    return rval;
}

- (void) launchiTunes:(id)sender
{
    NSAutoreleasePool *pool = [[ NSAutoreleasePool alloc] init];
    NSAppleScript *theScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nactivate\nend tell"];
    NSDictionary *errorDict = [[NSDictionary alloc] init];
    if (![theScript executeAndReturnError:&errorDict])
    {
        NSLog(@"Error launching iTunes!\n%@", errorDict);
        [theScript release];
        //brsadffsafasfasdfasfexit(-1);
    }
    [errorDict release];
    [theScript release];
    [pool release];
}

@end

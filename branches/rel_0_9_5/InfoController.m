//
//  InfoController.m
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/14/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "InfoController.h"
#import <AGRegex/AGRegex.h>
#import "ScriptController.h"


@implementation InfoController
+ (id) sharedController
{
    static id sharedController;
    
    if (!sharedController)
    {
        sharedController = [[self alloc] init];
    }
    
    return sharedController;
}

- (id)init
{
    if (![super init])
        return nil;
    
    _infoWindow = [[InfoWindow alloc] init];
    
    return self;
}

- (void) displayView:(NSString *)view fromNotification:(NSNotification *)aNotification
{
    //NSLog(@"%@", aNotification);
    NSLog(@"Received iTunes notification.");
    if (aNotification)
    {
        static NSDictionary *previousTrackInfo = nil;
        NSDictionary *trackInfo = [aNotification userInfo];
        if (
            ![[trackInfo objectForKey:@"Name"] isEqual:[previousTrackInfo objectForKey:@"Name"]] ||
            ![[trackInfo objectForKey:@"Album"] isEqual:[previousTrackInfo objectForKey:@"Album"]] ||
            ![[trackInfo objectForKey:@"Artist"] isEqual:[previousTrackInfo objectForKey:@"Artist"]] ||
            ![[trackInfo objectForKey:@"Genre"] isEqual:[previousTrackInfo objectForKey:@"Genre"]] ||
            ![[trackInfo objectForKey:@"Total Time"] isEqual:[previousTrackInfo objectForKey:@"Total Time"]]
            )
        {
            [self displayView:view];
            [previousTrackInfo release];
            previousTrackInfo = [trackInfo retain];
        }
    }
}

- (void) displayView:(NSString *)view
{
    if (view)
    {
        // Load the requested view from the file
        NSString *path = [[[NSBundle mainBundle] resourcePath] 
                                stringByAppendingPathComponent:[NSString stringWithFormat:@"Views/%@/index.html", view]];
        //NSString *path = @"/Users/ssilver/Documents/Programs/iTCWebRenderTest/Views/classic/index.html";
        NSURL *url = [NSURL fileURLWithPath:path];
        NSMutableString *page = [NSMutableString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
        
        if (page)
        {
            // Search for replaceable tags
            int opts = AGRegexCaseInsensitive;
            // search for pattern: [[tag]]
            AGRegex *regex = [AGRegex regexWithPattern:@"\\[\\[([\\w ]*?)\\]\\]" options:opts];
            // Go in reverse so that we don't mess up ranges as we replace tags
            NSEnumerator *enumerator = [[regex findAllInString:page] reverseObjectEnumerator];
            AGRegexMatch *match;
            ScriptController *sc = [ScriptController sharedController];
            // Replace each tag with info obtained from the script controller
            while (match = [enumerator nextObject])
            {
                NSString *name = [match groupAtIndex:1];
                //NSLog(name);
                NSString *info = [sc infoForTag:name];
                if (info)
                {
                    [page replaceCharactersInRange:[match range] withString:info];
                }
            }
            /*
             // Write the source code to a file
             NSError *error;
             if (![page writeToFile:@"/Users/ssilver/Desktop/test.html" atomically:NO encoding:NSUTF8StringEncoding error:&error])
             {
                 NSLog(@"Could not write file: %@", error);
             }
             */
            // Create and show the info window
            [_infoWindow displayPage:page relativeTo:url];
        }
        else
        {
            // page was nil
            NSLog(@"Could not load page for %@ inside [InfoController displayView:].", url);
        }
    }
    else
    {
        // view was nil!
        NSLog(@"nil view for [InfoController displayView:]. Are preferences broken?");
    }
}
@end

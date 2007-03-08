//
//  FindController.m
//  iTunesCheck
//
//  Created by StormSilver on 3/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "FindWindowController.h"
#import "QuickPlayWindow.h"
#import "ScriptController.h"


@implementation FindWindowController

static id sharedController;

+ (id) sharedController
{
    if (!sharedController)
    {
        [[self alloc] init];
    }
    
    return sharedController;
}

- (id) init
{
    if (!sharedController)
    {
        self = [super init];
        
        if (self)
        {
            _findWindow = [[QuickPlayWindow alloc] init];
        }
        
        sharedController = self;
    }
    
    return sharedController;
}

- (void) dealloc
{
    if (_playlists)
    {
        [_playlists release];
    }
    [_findWindow release];
    [super dealloc];
}

- (void) show
{
    if ([[_findWindow window] isKeyWindow])
    {
        [_findWindow closeWindow];
    }
    else if ([[_findWindow window] isVisible])
    {
        [[_findWindow window] makeKeyAndOrderFront:nil];
    }
    else
    {
        NSString *path = [[[NSBundle mainBundle] resourcePath] 
                                    stringByAppendingPathComponent:[NSString stringWithFormat:@"Views/%@/find.html", @"classic"]];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSMutableString *page = [NSMutableString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
        [_findWindow displayPage:page relativeTo:url];
    }
}

- (void) close
{
    [_findWindow closeWindow];
}



- (NSArray *) resultsForSearch:(NSString *)search inPlaylist:(NSString *)playlist
{
    //get the results for the search
    NSString *searchPlaylist = [_playlists objectForKey:playlist];
    NSAppleEventDescriptor *searchResults = [[ScriptController sharedController] searchFor:search inPlaylist:searchPlaylist];
    
    //if the search returned more than one result, we'll show a window so the user can select what song they want
    if (!searchResults)
    {
        return [NSArray arrayWithObject:@"Script error while searching."];
    }
    else if ([searchResults numberOfItems] > 0)
    {
        //So let's set up an array that will contain the display information the user can select
        NSMutableArray *songs = [NSMutableArray array];
        
        int i;
        for (i = 1; i <= [searchResults numberOfItems]; ++i)
        {
            //Great, we've got the search results. We need to extract the name and artist so that we can show them to the user,
            //and the Applescript location of the track so that we can play it when the user selects something
            NSAppleEventDescriptor *currDescriptor = [searchResults descriptorAtIndex:i];
            NSString *title = [[currDescriptor descriptorAtIndex:1] stringValue];
            NSString *artist = [[currDescriptor descriptorAtIndex:2] stringValue];
            NSString *replaceValue = [NSString stringWithFormat:@"%Cclass %@%C id %@ of %@",
                0x00AB,
                [[[currDescriptor descriptorAtIndex:3] descriptorAtIndex:2] stringValue],
                0x00BB,
                [[[currDescriptor descriptorAtIndex:3] descriptorAtIndex:3] stringValue],
                searchPlaylist
                ];
            [songs addObject:[NSArray arrayWithObjects:
                    title,
                    artist,
                    replaceValue,
                    nil]];
        }
        
        return songs;
    } else {
        //if the search only returned one result, we'll handle it here, as one of three possibilites:
        switch ([searchResults int32Value])
        {
            case -1:
                //The track was found, but the file wasn't.
                //[self showError:@"file does not exist"];
                //[_searchProgressIndicator stopAnimation:nil];
                return [NSArray arrayWithObject:@"File does not exist!"];
                break;
            case 1:
                //The search was not found.
                //[self showError:[NSString stringWithFormat:@"not found", [_findField stringValue]]];
                //[_searchProgressIndicator stopAnimation:nil];
                return [NSArray arrayWithObject:@"Search string not found."];
                break;
            case 2:
            default:
                //The search was found, and is now playing (because the search AppleScript told it to.)
                //[_searchProgressIndicator stopAnimation:nil];
                //[_findWindow close];
                //[_infoController display];
                [self close];
                return nil;
                break;
        }
    }
    
    /*
    NSLog(@"performing a search for %@", search);
    return [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
    */
}

- (NSArray *) playlists
{
    NSAppleEventDescriptor *rval = [[ScriptController sharedController] runAppleScript:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Scripts/getPlaylists.scpt"]];
	
    NSAppleEventDescriptor *playlistNames = [rval descriptorAtIndex:2];
    NSAppleEventDescriptor *playlistSources = [rval descriptorAtIndex:1];
    if (_playlists)
    {
        [_playlists release];
        _playlists = nil;
    }
    _playlists = [[NSMutableDictionary alloc] init];
    int i, j;
    //load the playlist names into the menu
    for (i = 1; i <= [playlistNames numberOfItems]; ++i)
    {
        NSAppleEventDescriptor *currSource = [playlistSources descriptorAtIndex:i];
        NSAppleEventDescriptor *currName = [playlistNames descriptorAtIndex:i];
        
        NSString *loc = [NSString stringWithFormat:@"%Cclass %@%C id %@ of source id %@", 
                            0x00AB,
                            [[[currSource descriptorAtIndex:1] descriptorAtIndex:2] stringValue], 
                            0x00BB,
                            [[[currSource descriptorAtIndex:1] descriptorAtIndex:3] stringValue], 
                            [[[[currSource descriptorAtIndex:1] descriptorAtIndex:4] descriptorAtIndex:3] stringValue]];
        NSString *ky = [[currName descriptorAtIndex:1] stringValue];
        [_playlists setObject:loc forKey:ky];
        
        for (j = 2; j <= [currName numberOfItems]; ++j)
        {
            NSString *src = [NSString stringWithFormat:@"%Cclass %@%C id %@ of source id %@", 
                                0x00AB,
                                [[[currSource descriptorAtIndex:j] descriptorAtIndex:2] stringValue], 
                                0x00BB,
                                [[[currSource descriptorAtIndex:j] descriptorAtIndex:3] stringValue], 
                                [[[[currSource descriptorAtIndex:j] descriptorAtIndex:4] descriptorAtIndex:3] stringValue]];
            NSString *key = [[NSString stringWithString:@" -"] stringByAppendingString:[[currName descriptorAtIndex:j] stringValue]];
            [_playlists setObject:src forKey:key];
        }
    }
    
    return [_playlists allKeys];
}


- (void) resize
{
    [_findWindow resize];
}

- (void) playSong:(NSString *)path
{
    [[ScriptController sharedController] playSongWithID:path];
    [self close];
}

+ (NSString *) webScriptNameForSelector:(SEL)sel
{
    NSString *name = nil;
    if (sel == @selector(playlists))
    {
        name = @"playlists";
    }
    else if (sel == @selector(resultsForSearch:inPlaylist:))
    {
        name = @"resultsForSearchInPlaylist";
    }
    else if (sel == @selector(resize))
    {
        name = @"resize";
    }
    else if (sel == @selector(close))
    {
        name = @"close";
    }
    else if (sel == @selector(playSong:))
    {
        name = @"playSong";
    }

    return name;
}

+ (BOOL) isSelectorExcludedFromWebScript:(SEL)sel
{
    BOOL excluded = YES;
    
    if (sel == @selector(playlists) || sel == @selector(resultsForSearch:inPlaylist:) || sel == @selector(resize) || sel == @selector(close) || sel == @selector(playSong:))
    {
        excluded = NO;
    }

    return excluded;
}

- (id) invokeUndefinedMethodFromWebScript:(NSString *)name withArguments:(NSArray *)args
{
    NSLog(@"[JS ERROR]    undefined method \"%@\" called on FindWindowController", name);
    return nil;
}

@end

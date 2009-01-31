//
//  NetStormsilverItunescheckQuickPlayFindController.m
//  iTunesCheck
//
//  Created by Eric Hankins on 1/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NetStormsilverItunescheckQuickPlayFindController.h"
#import <WebKit/WebKit.h>
#import <iTCBundle/iTunes.h>

@implementation FindController

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        windowController = [[WebViewWindowController alloc] init];
        [windowController setFrameLoadDelegate:self];
    }
    return self;
}

- (void) finishLoading
{
    NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithIdentifier:bundleIdentifier] pathForResource:@"QuickPlayDefaults" ofType:@"plist"]];
    if (defaultPrefs)
    {
        [preferencesController setPreferences:defaultPrefs forBundle:bundleIdentifier];
    }
    
    [preferencesController setTarget:self forHotKeyNamed:@"QuickPlay" withKeyCode:3 andModifiers:2304];
}

- (NSString *) shortName
{
    return @"QuickPlay";
}

- (BOOL) isHotKeyBundle
{
    return YES;
}

- (BOOL) defaultAction
{
    [self playlists];
    return YES;
}


- (void) quickPlayHotKey
{
    NSString *bundleId = [preferencesController preferenceForKey:@"viewBundle" forBundle:bundleIdentifier];
    NSString *view = [preferencesController preferenceForKey:@"view" forBundle:bundleIdentifier];
    NSBundle *bundle = [NSBundle bundleWithIdentifier:bundleId];
    if (bundle)
    {
        [self displayBundle:bundle view:view];
    }
    else
    {
        NSLog(@"Could not instantiate bundle %@", bundleId);
    }
}

- (void) displayBundle:(NSBundle *)bundle view:(NSString *)view
{
    if (view)
    {
        // Load the requested view from the file
        NSString *path = [[bundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"Views/%@/quickplay.html", view]];
        //NSString *path = @"/Users/ssilver/Desktop/iTunesCheck/Views/classic/index.html";
        NSURL *url = [NSURL fileURLWithPath:path];
        NSMutableString *page = [NSMutableString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
        
        if (page)
        {
            //// Write the source code to a file
            //NSError *error;
            //if (![page writeToFile:@"/Users/ssilver/Desktop/test.html" atomically:NO encoding:NSUTF8StringEncoding error:&error])
            //{
            //    NSLog(@"Could not write file: %@", error);
            //}
            // Create and show the info window
            [windowController displayPage:page relativeTo:url];
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







- (void)webView:(WebView *)sender didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame
{
    [windowObject setValue:self forKey:@"FindWindowController"];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    WebScriptObject *script = [sender windowScriptObject];
    float height = [[script evaluateWebScript:HEIGHT_SCRIPT] floatValue];
    float width = [[script evaluateWebScript:WIDTH_SCRIPT] floatValue];
    //NSLog(@"width: %f, height: %f", width, height);
    // TODO: all SORTS of math to be done here
    // origin calculations
    // width/height constraints
    // paddings against the sides of the screen
    // oh yeah, don't forget it might be on a different screen...
    NSPoint origin = [[windowController window] frame].origin;
    [sender setFrame:NSMakeRect(0, 0, width, height)];
    [[windowController window] setFrame:NSMakeRect(origin.x, origin.y, width, height) display:YES];
    [[windowController window] center];
    [windowController showWindow:nil];
}






- (NSArray *) resultsForSearch:(NSString *)search inPlaylist:(NSString *)playlistName
{
    NSLog(@"resultsForSearch: %@ inPlaylist: %@", search, playlistName);
    iTunesPlaylist *playlist = [playlists objectForKey:playlistName];
    NSArray *searchResults = (NSArray *)[playlist searchFor:search only:iTunesESrAAll];
    lastSearchResults = [NSMutableDictionary dictionary];

    //if the search returned more than one result, we'll show a window so the user can select what song they want
    if ([searchResults count] < 1)
    {
        return nil;
    }
    else if ([searchResults count] > 0)
    {
        //So let's set up an array that will contain the display information the user can select
        NSMutableArray *songs = [NSMutableArray array];        
        //int i;
        //for (i = 1; i <= [searchResults numberOfItems]; ++i)
        //{
        //    //Great, we've got the search results. We need to extract the name and artist so that we can show them to the user,
        //    //and the Applescript location of the track so that we can play it when the user selects something
        //    NSAppleEventDescriptor *currDescriptor = [searchResults descriptorAtIndex:i];
        //    NSString *title = [[currDescriptor descriptorAtIndex:1] stringValue];
        //    NSString *artist = [[currDescriptor descriptorAtIndex:2] stringValue];
        //    NSString *replaceValue = [NSString stringWithFormat:@"%Cclass %@%C id %@ of %@",
        //                              0x00AB,
        //                              [[[currDescriptor descriptorAtIndex:3] descriptorAtIndex:2] stringValue],
        //                              0x00BB,
        //                              [[[currDescriptor descriptorAtIndex:3] descriptorAtIndex:3] stringValue],
        //                              searchPlaylist
        //                              ];
        //    [songs addObject:[NSArray arrayWithObjects:
        //                      title,
        //                      artist,
        //                      replaceValue,
        //                      nil]];
        //}
        for (iTunesTrack *track in searchResults)
        {
            NSString *idString = [[NSNumber numberWithInteger:[track id]] stringValue];
            [songs addObject:[NSArray arrayWithObjects:[track name], [track artist], idString, nil]];
            [lastSearchResults setValue:track forKey:idString];
        }
        
        return songs;
    }
    //} else {
    //    //if the search only returned one result, we'll handle it here, as one of three possibilites:
    //    switch ([searchResults int32Value])
    //    {
    //        case -1:
    //            //The track was found, but the file wasn't.
    //            //[self showError:@"file does not exist"];
    //            //[_searchProgressIndicator stopAnimation:nil];
    //            return [NSArray arrayWithObject:@"File does not exist!"];
    //            break;
    //        case 1:
    //            //The search was not found.
    //            //[self showError:[NSString stringWithFormat:@"not found", [_findField stringValue]]];
    //            //[_searchProgressIndicator stopAnimation:nil];
    //            return [NSArray arrayWithObject:@"Search string not found."];
    //            break;
    //        case 2:
    //        default:
    //            //The search was found, and is now playing (because the search AppleScript told it to.)
    //            //[_searchProgressIndicator stopAnimation:nil];
    //            //[_findWindow close];
    //            //[_infoController display];
    //            [self close];
    //            return nil;
    //            break;
    //    }
    //}
    //
    ///*
    // NSLog(@"performing a search for %@", search);
    return [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
    // */
    //NSLog(@"searchResults: %@", searchResults);//
}

- (NSArray *) playlists
{
    playlists = [NSMutableDictionary dictionary];
    NSArray *sources = [iTunes sources];
    for (iTunesSource *source in sources)
    {
        if ([source kind] != iTunesESrcRadioTuner)
        {
            for (iTunesPlaylist *playlist in [source playlists])
            {
                [playlists setValue:playlist forKey:[playlist name]];
            }
        }
    }
    return [playlists allKeys];
}

- (void) resize
{
    NSLog(@"resize");
    [windowController resizeWindow];
}

- (void) close
{
    [windowController closeWindow];
}

- (void) playSong:(NSString *)idString
{
    NSLog(@"playSong: %@", idString);
    [[lastSearchResults objectForKey:idString] playOnce:NO];
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

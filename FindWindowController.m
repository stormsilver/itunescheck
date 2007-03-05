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



- (NSArray *) resultsForSearch:(NSString *)search
{
    //crank up the progress indicator
    //[_searchProgressIndicator startAnimation:nil];
    //get the results for the search
    /*
    NSString *searchPlaylist = [_playlists objectAtIndex:[_playlistMenu indexOfSelectedItem]];
    NSAppleEventDescriptor *searchResults = [[ScriptController sharedController] search:[_findField stringValue] inPlaylist:searchPlaylist];
    
    //if the search returned more than one result, we'll show a window so the user can select what song they want
    if ([searchResults numberOfItems] > 0)
    {
        //So let's set up an array that will contain the display information the user can select
        NSMutableArray * songs = [[NSMutableArray alloc] init];
        float currTitleLen = 0.0;
        float currArtistLen = 0.0;
        float currHeight = 0.0;
        NSDictionary *attrs = [NSDictionary dictionaryWithObject:[NSFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
        
        for (int i = 1; i <= [searchResults numberOfItems]; ++i)
        {
            //Great, we've got the search results. We need to extract the name and artist so that we can show them to the user,
            //and the Applescript location of the track so that we can play it when the user selects something
            NSAppleEventDescriptor *currDescriptor = [searchResults descriptorAtIndex:i];
            NSString *title = [[currDescriptor descriptorAtIndex:1] stringValue];
            NSString *artist = [[currDescriptor descriptorAtIndex:2] stringValue];
            NSString * replaceValue = [NSString stringWithFormat:@"«class %@» id %@ of %@",
                [[[currDescriptor descriptorAtIndex:3] descriptorAtIndex:2] stringValue],
                [[[currDescriptor descriptorAtIndex:3] descriptorAtIndex:3] stringValue],
                searchPlaylist
                ];
            
            //Keep a running track of the longest title and artist. We'll use these when we're done to set the size of the window (somewhat) appropriately.
            if (title && artist)
            {
                if (!currHeight)
                {
                    currHeight = [title sizeWithAttributes:attrs].height;
                }
                if ([title sizeWithAttributes:attrs].width > currTitleLen)
                {
                    currTitleLen = [title sizeWithAttributes:attrs].width;
                }
                if ([artist sizeWithAttributes:attrs].width > currArtistLen)
                {
                    currArtistLen = [artist sizeWithAttributes:attrs].width;
                }
                [songs addObject:[NSArray arrayWithObjects:
                    title,
                    artist,
                    replaceValue,
                    nil]];
            }
        }
        
        
        //then set the size of the window appropriately
        //currTitleLen *= 7.6;
        //currArtistLen *= 7.7;
        NSRect visibleArea = [[_selectWindow screen] frame];
        float width = (currTitleLen + currArtistLen) + 35.0;
        if (width < 325.0)
        {
            width = 325.0;
        }
        //NSFont *font = [NSFont boldSystemFontOfSize:13.1];
        //NSRect drawArea = NSMakeRect(0.0, 0.0, width + 4, ([songs count] * ([font boundingRectForFont].size.height - (-0.9*[font descender]))) + 40.0);
        //NSRect drawArea = NSMakeRect(0.0, 0.0, width + 4, ([songs count] * currHeight) + 40.0);
        NSRect drawArea = NSMakeRect(0.0, 0.0, width + 4, ([songs count] * 20.10) + 40.0);
        if (!NSContainsRect(visibleArea, drawArea))
        {
            drawArea = NSIntersectionRect(visibleArea, drawArea);
            drawArea.size.height -= 60.0;
        }
        
        [[[_selectTable tableColumns] objectAtIndex:0] setWidth:currTitleLen];
        [[[_selectTable tableColumns] objectAtIndex:1] setWidth:currArtistLen];
        //Show the number of songs returned by the search
        [_numResultsField setStringValue:[NSString stringWithFormat:@"%i songs", [songs count]]];
        //Tell the selectTable to use the array we just set up
        [[_selectTable dataSource] setDataArray:songs];
        [_selectWindow setFrame:drawArea display:NO animate:NO];
        [_selectWindow center];
        //[_selectWindow display];
        [_selectWindow orderFrontRegardless];
        [_selectWindow makeKeyWindow];
        [_searchProgressIndicator stopAnimation:nil];
        [_findWindow close];
    } else {
        //if the search only returned one result, we'll handle it here, as one of three possibilites:
        switch ([searchResults int32Value])
        {
            case -1:
                //The track was found, but the file wasn't.
                [self showError:@"file does not exist"];
                [_searchProgressIndicator stopAnimation:nil];
                break;
            case 1:
                //The search was not found.
                [self showError:[NSString stringWithFormat:@"not found", [_findField stringValue]]];
                [_searchProgressIndicator stopAnimation:nil];
                break;
            case 2:
            default:
                //The search was found, and is now playing (because the search AppleScript told it to.)
                [_searchProgressIndicator stopAnimation:nil];
                [_findWindow close];
                [_infoController display];
                break;
        }
    }
    */
    NSLog(@"performing a search for %@", search);
    return [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
}

- (NSArray *) playlists
{
    NSAppleEventDescriptor *rval = [[ScriptController sharedController] runAppleScript:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Scripts/getPlaylists.scpt"]];
	
    NSAppleEventDescriptor *playlistNames = [rval descriptorAtIndex:2];
    NSAppleEventDescriptor *playlistSources = [rval descriptorAtIndex:1];
    NSMutableArray *returnArray = [NSMutableArray array];
    int i, j;
    //load the playlist names into the menu
    for (i = 1; i <= [playlistNames numberOfItems]; ++i)
    {
        NSAppleEventDescriptor *currSource = [playlistSources descriptorAtIndex:i];
        NSAppleEventDescriptor *currName = [playlistNames descriptorAtIndex:i];
        
        //NSString *loc = [NSString stringWithFormat:@"«class %@» id %@ of source id %@", [[[currSource descriptorAtIndex:1] descriptorAtIndex:2] stringValue], [[[currSource descriptorAtIndex:1] descriptorAtIndex:3] stringValue], [[[[currSource descriptorAtIndex:1] descriptorAtIndex:4] descriptorAtIndex:3] stringValue]];
        NSString *ky = [[currName descriptorAtIndex:1] stringValue];
        //[[_playlistMenu menu] addItemWithTitle:ky action:nil keyEquivalent:@""];
        //[_playlists addObject:loc];
        [returnArray addObject:ky];
        
        for (j = 2; j <= [currName numberOfItems]; ++j)
        {
            //NSString *src = [NSString stringWithFormat:@"«class %@» id %@ of source id %@", [[[currSource descriptorAtIndex:j] descriptorAtIndex:2] stringValue], [[[currSource descriptorAtIndex:j] descriptorAtIndex:3] stringValue], [[[[currSource descriptorAtIndex:j] descriptorAtIndex:4] descriptorAtIndex:3] stringValue]];
            NSString *key = [[NSString stringWithString:@" -"] stringByAppendingString:[[currName descriptorAtIndex:j] stringValue]];
            //[[_playlistMenu menu] addItemWithTitle:key action:nil keyEquivalent:@""];
            //[_playlists addObject:src];
            [returnArray addObject:key];
        }
    }
    
    return returnArray;
}

+ (NSString *) webScriptNameForSelector:(SEL)sel
{
    NSString *name = nil;
    if (sel == @selector(playlists))
    {
        name = @"playlists";
    }
    else if (sel == @selector(resultsForSearch:))
    {
        name = @"resultsForSearch";
    }

    return name;
}

+ (BOOL) isSelectorExcludedFromWebScript:(SEL)sel
{
    BOOL excluded = YES;
    
    if (sel == @selector(playlists) || sel == @selector(resultsForSearch:))
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

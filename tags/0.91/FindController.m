#import "FindController.h"
//#import "AppController.h"
#import "InfoController.h"
#import "SelectTableSource.h"
#import "RoundedView.h"
#import "ScriptController.h"

@implementation FindController

#pragma mark -
#pragma mark Initialization

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
    static BOOL initing = NO;
    self = [super init];
    
    if (self && !initing)
    {
        initing = YES;
        //Set up our infoController pointer to the infoController object.
        _infoController = [InfoController sharedController];
        //Load up the interface file
        [NSBundle loadNibNamed:@"Find" owner:self];
    }
    
    initing = NO;
    
    return self;
}

- (void) dealloc
{
    [_infoController release];
    [_playlists release];
    
    [super dealloc];
}

- (void) awakeFromNib
{
    //Set up some interface prettiness values. Bind text and background colors to the appropriate places.
    [_findRounded setRadius:15.0];
    [_findRounded bind:@"backgroundColor" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.backgroundColor" options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
    [_selectRounded setRadius:17.0];
    [_selectRounded bind:@"backgroundColor" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.backgroundColor" options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
    [_findWindow center];
    [_findField setFocusRingType:NSFocusRingTypeNone];
    
    //NSFont *font = [NSFont boldSystemFontOfSize:13.0];
    //[_selectTable setRowHeight:([font boundingRectForFont].size.height + (-1*[font descender]))];
    [_selectTable bind:@"backgroundColor" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.backgroundColor" options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
    [[[[_selectTable tableColumns] objectAtIndex:0] dataCell] bind:@"textColor" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.textColor" options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
    [[[[_selectTable tableColumns] objectAtIndex:1] dataCell] bind:@"textColor" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.textColor" options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];

    //Get the list of playlists
    [self refreshPlaylists:nil];
}

#pragma mark -
#pragma mark IB Methods

- (IBAction) close:(id)sender
{
    [_findWindow close];
    [NSApp deactivate];
}

- (IBAction) performFind:(id)sender
{
    [self clearError];
    //crank up the progress indicator
    [_searchProgressIndicator startAnimation:nil];
    //get the results for the search
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
            NSString * replaceValue = [NSString stringWithFormat:@"Çclass %@È id %@ of %@",
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
                 /*
                if ([title length] > currTitleLen)
                {
                    currTitleLen = [title length];
                }
                if ([artist length] > currArtistLen)
                {
                    currArtistLen = [artist length];
                }
                  */
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
    
    //stop the progress indicator and close the window
    
    //[searchResults release];
}

- (IBAction) cancelSelect:(id)sender
{
    [_selectWindow close];
    [[_selectTable dataSource] clearData];
}

- (IBAction) refreshPlaylists:(id)sender
{
    //Ditch all the old menu items
    [_playlistMenu removeAllItems];
    [_playlists release];
    _playlists = nil;
    
    _playlists = [[NSMutableArray alloc] init];
    //Set up an AppleScript to ask iTunes what the playlists are
    NSAppleScript *theScript = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[[NSBundle mainBundle] resourcePath] 
                                stringByAppendingPathComponent:@"Scripts/getPlaylists.scpt"]] error:nil];
								
	NSDictionary *errorDict = [[NSDictionary alloc] init];
    NSAppleEventDescriptor *rval = [theScript executeAndReturnError:&errorDict];
	[errorDict release];
	
    NSAppleEventDescriptor *playlistNames = [rval descriptorAtIndex:2];
    NSAppleEventDescriptor *playlistSources = [rval descriptorAtIndex:1];
    
    //load the playlist names into the menu
    for (int i = 1; i <= [playlistNames numberOfItems]; ++i)
    {
        NSAppleEventDescriptor *currSource = [playlistSources descriptorAtIndex:i];
        NSAppleEventDescriptor *currName = [playlistNames descriptorAtIndex:i];
        
        NSString *loc = [NSString stringWithFormat:@"Çclass %@È id %@ of source id %@", [[[currSource descriptorAtIndex:1] descriptorAtIndex:2] stringValue], [[[currSource descriptorAtIndex:1] descriptorAtIndex:3] stringValue], [[[[currSource descriptorAtIndex:1] descriptorAtIndex:4] descriptorAtIndex:3] stringValue]];
        NSString *ky = [[currName descriptorAtIndex:1] stringValue];
        [[_playlistMenu menu] addItemWithTitle:ky action:nil keyEquivalent:@""];
        [_playlists addObject:loc];
        
        for (int j = 2; j <= [currName numberOfItems]; ++j)
        {
            NSString *src = [NSString stringWithFormat:@"Çclass %@È id %@ of source id %@", [[[currSource descriptorAtIndex:j] descriptorAtIndex:2] stringValue], [[[currSource descriptorAtIndex:j] descriptorAtIndex:3] stringValue], [[[[currSource descriptorAtIndex:j] descriptorAtIndex:4] descriptorAtIndex:3] stringValue]];
            NSString *key = [[NSString stringWithString:@" -"] stringByAppendingString:[[currName descriptorAtIndex:j] stringValue]];
            [[_playlistMenu menu] addItemWithTitle:key action:nil keyEquivalent:@""];
            [_playlists addObject:src];
        }
    }
    [theScript release];
}

//This method will just start playing the selected playlist without having to search for anything.
- (IBAction) playList:(id)sender
{
    //Get the selected playlist
    NSString *searchList = [_playlists objectAtIndex:[_playlistMenu indexOfSelectedItem]];
    //Set up the AppleScript to tell iTunes to play the playlist
    NSString *script = [NSString stringWithFormat:@"tell application \"iTunes\"\nset the view of browser window \"iTunes\" to %@\nplay %@\nend tell", searchList, searchList];
	
	NSAppleScript *theScript = [[NSAppleScript alloc] initWithSource:script];
	NSDictionary *errorDict = [[NSDictionary alloc] init];
    [theScript executeAndReturnError:&errorDict];
	[errorDict release];
	[theScript release];

    [_findWindow close];
}

#pragma mark -
#pragma mark Other Methods

- (void) display
{
    if ([_findWindow isKeyWindow])
    {
        //if the window is already open, close it
        [_findWindow close];
        [NSApp hide:nil];
    } else {
        [self refreshPlaylists:nil];
        //otherwise show the find window
        //[_findWindow orderFrontRegardless];
        //[_findWindow makeKeyWindow];
        //this is needed to set the focus on the find window, otherwise the user has to click it and that's
        //not quite as useful
        [_findWindow makeKeyAndOrderFront:self];
        [NSApp activateIgnoringOtherApps:YES];
        [_findWindow makeKeyAndOrderFront:self];
    }
}

- (void) showError:(NSString *)errorMessage
{
    [_errorField setStringValue:errorMessage];
}

- (void) clearError
{
    [_errorField setStringValue:@""];
}

@end

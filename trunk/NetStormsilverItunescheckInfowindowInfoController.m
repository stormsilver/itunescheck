//
//  NetStormsilverItunescheckInfowindowInfoController.m
//  iTunesCheck
//
//  Created by Eric Hankins on 12/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetStormsilverItunescheckInfowindowInfoController.h"
#import <AGRegex/AGRegex.h>
#import <iTCBundle/iTunes.h>
#import <QuartzCore/CIFilter.h>
#import <WebKit/WebKit.h>
#import "NSData-Base64Extensions.h"

@implementation InfoController : AbstractBundle
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
    NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithIdentifier:bundleIdentifier] pathForResource:@"InfoWindowDefaults" ofType:@"plist"]];
    if (defaultPrefs)
    {
        [preferencesController setPreferences:defaultPrefs forBundle:bundleIdentifier];
    }
    [preferencesController setTarget:self forDisplayTag:@"title"];
    [preferencesController setTarget:self forDisplayTag:@"artist"];
    [preferencesController setTarget:self forDisplayTag:@"album"];
    [preferencesController setTarget:self forDisplayTag:@"rating"];
    [preferencesController setTarget:self forDisplayTag:@"artwork"];
    
    [preferencesController setTarget:self forHotKeyNamed:@"Show Info Window" withKeyCode:8 andModifiers:2304];

    //[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.netstormsilveritunescheckInfoWindow.showWindowOn" options:NSKeyValueObservingOptionNew context:nil];
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"netstormsilveritunescheckInfoWindow.showWindowOn" options:NSKeyValueObservingOptionNew context:nil];
    [self startListening];
}

- (void) finalize
{
    [self stopListening];
    [super finalize];
}

- (NSString *) shortName
{
    return @"Info Window";
}

- (void) showInfoWindowHotKey
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
- (BOOL) defaultAction
{
    //NSString *bundleId = [preferencesController preferenceForKey:@"viewBundle" forBundle:bundleIdentifier ];
    //NSString *view = [preferencesController preferenceForKey:@"view" forBundle:bundleIdentifier ];
    //NSBundle *bundle = [NSBundle bundleWithIdentifier:bundleId];
    //if (bundle)
    //{
    //    [self displayBundle:bundle view:view];
    //    return YES;
    //}
    //else
    //{
    //    NSLog(@"Could not instantiate bundle %@", bundleId);
    //    return NO;
    //}
    
    id values = [[NSUserDefaultsController sharedUserDefaultsController] values];
    NSDictionary *dict = [values valueForKey:@"netstormsilveritunescheckInfoWindow"];
    NSLog(@"bleh: %@", [dict valueForKey:@"showWindowOn"]);
    //NSLog(@"netstormsilveritunescheckInfoWindow.showWindowOn: %@", [values valueForKeyPath:@"netstormsilveritunescheckInfoWindow.showWindowOn"]);
    NSLog(@"value is: %@", [[NSUserDefaultsController sharedUserDefaultsController] valueForKeyPath:@"values.netstormsilveritunescheckInfoWindow.showWindowOn"]);
    return YES;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"Observed value for key path: %@ of object: %@, change: %@", keyPath, object, change);
}








- (BOOL) isHotKeyBundle
{
    return YES;
}

- (BOOL) isDisplayBundle
{
    return YES;
}

- (void) startListening
{
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(displayFromNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
}

- (void) stopListening
{
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:@"com.apple.iTunes.playerInfo" object:nil];
}

- (void) displayFromNotification:(NSNotification *)aNotification
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
            [self showInfoWindowHotKey];
            previousTrackInfo = trackInfo;
        }
    }
}

- (void) displayBundle:(NSBundle *)bundle view:(NSString *)view
{
    if (view)
    {
        // Load the requested view from the file
        NSString *path = [[bundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"Views/%@/index.html", view]];
        //NSString *path = @"/Users/ssilver/Desktop/iTunesCheck/Views/classic/index.html";
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
            // Replace each tag with info obtained from the script controller
            while (match = [enumerator nextObject])
            {
                NSString *name = [match groupAtIndex:1];
                id controller = [preferencesController targetForDisplayTag:name];
                SEL action = NSSelectorFromString([NSString stringWithFormat:@"%@Tag", name]);
                if ([controller respondsToSelector:action])
                {
                    NSString *info = [controller performSelector:action];
                    if (info)
                    {
                        [page replaceCharactersInRange:[match range] withString:info];
                    }
                }
            }
            //// Write the source code to a file
            //NSError *error;
            //if (![page writeToFile:@"/Users/ssilver/Desktop/test.html" atomically:NO encoding:NSUTF8StringEncoding error:&error])
            //{
            //    NSLog(@"Could not write file: %@", error);
            //}
            // Create and show the info window
            [windowController displayPage:page relativeTo:url];
            if (delayTimer)
            {
                [delayTimer invalidate];
                delayTimer = nil;
            }
            delayTimer = [NSTimer scheduledTimerWithTimeInterval:[[preferencesController preferenceForKey:PREFKEY_DELAY_TIME forBundle:bundleIdentifier] intValue] target:self selector:@selector(closeWindow) userInfo:nil repeats:NO];
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

- (void) closeWindow
{
    if (delayTimer)
    {
        [delayTimer invalidate];
        delayTimer = nil;
    }
    [windowController closeWindow];
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
    [windowController showWindow:nil];
}








- (NSString *) titleTag
{
    NSString *rval = @"";
    
    NSString *streamTitle = [iTunes currentStreamTitle];
    if (streamTitle)
    {
        // okay, we're streaming. Now we'll walk through the string and look for " - ", which most servers use to delimit the artist from the title.
        NSArray *components = [streamTitle componentsSeparatedByString:@" - "];
        if ([components count] > 1)
        {
            // found it. What we'll assume is that everything after the dash is the the title of the song
            rval = [components objectAtIndex:1];
        }
        else
        {
            // we couldn't find a dash... so we'll just return the whole thing
            rval = streamTitle;
        }
    }
    else
    {
        rval = [[iTunes currentTrack] name];
    }
    
    return rval;
}

- (NSString *) artistTag
{
    NSString *rval = @"";
    
    NSString *streamTitle = [iTunes currentStreamTitle];
    if (streamTitle)
    {
        // okay, we're streaming. Now we'll walk through the string and look for " - ", which most servers use to delimit the artist from the title.
        NSArray *components = [streamTitle componentsSeparatedByString:@" - "];
        if ([components count] > 1)
        {
            // found it. What we'll assume is that everything before the dash is the the title of the song
            rval = [components objectAtIndex:0];
        }
        else
        {
            // we couldn't find a dash... so we'll just return the whole thing
            rval = streamTitle;
        }
    }
    else
    {
        rval = [[iTunes currentTrack] artist];
    }
    
    return rval;
}

- (NSString *) albumTag
{
    NSString *rval = @"";
    
    if ([iTunes currentStreamTitle])
    {
        rval = [[iTunes currentTrack] name];
    }
    else
    {
        rval = [[iTunes currentTrack] album];
    }
    
    return rval;
}

- (NSString *) ratingTag
{
    NSString *rval = @"";
    
    int rating = [[iTunes currentTrack] rating];
    switch (rating)
    {
        case 20:
            rval = [NSString stringWithFormat:@"%C",0x2605];
            break;
        case 40:
            rval = [NSString stringWithFormat:@"%C%C",0x2605,0x2605];
            break;
        case 60:
            rval = [NSString stringWithFormat:@"%C%C%C",0x2605,0x2605,0x2605];
            break;
        case 80:
            rval = [NSString stringWithFormat:@"%C%C%C%C",0x2605,0x2605,0x2605,0x2605];
            break;
        case 100:
            rval = [NSString stringWithFormat:@"%C%C%C%C%C",0x2605,0x2605,0x2605,0x2605,0x2605];
            break;
        default:
            rval = @"";
    }
    
    return rval;
}

- (NSString *) artworkTag
{    
    NSString *rval = @"";
    SBElementArray *artworks = [[iTunes currentTrack] artworks];
    if ([artworks count] > 0)
    {
        iTunesArtwork *art = [artworks objectAtIndex:0];
        if (art)
        {
            NSImage *image = [art data];
            float imagePrefSize = [[preferencesController preferenceForKey:@"artworkSize" forBundle:bundleIdentifier] floatValue];
            NSSize imageSize = [image size];
            if ( imageSize.width > imagePrefSize || imageSize.height > imagePrefSize )
            {
                //Scale the image appropiately. This uses a nice high-quality scaling technique.
                //Much better than just telling the image to resize itself!
                float newWidth;
                float newHeight;
                if (imageSize.width > imageSize.height)
                {
                    newWidth = imagePrefSize;
                    newHeight = imagePrefSize / imageSize.width * imageSize.height;
                }
                else if (imageSize.width < imageSize.height)
                {
                    newWidth = imagePrefSize / imageSize.height * imageSize.width;
                    newHeight = imagePrefSize;
                }
                else
                {
                    newWidth = imagePrefSize;
                    newHeight = imagePrefSize;
                }
                
                // TODO: make this a CoreImage manipulation
                NSRect newBounds = NSMakeRect(0.0, 0.0, newWidth, newHeight);
                NSImageRep *sourceImageRep = [image bestRepresentationForDevice:nil];
                [image release];
                image = [[NSImage alloc] initWithSize:NSMakeSize(newWidth, newHeight)];
                [image lockFocus];
                [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
                [sourceImageRep drawInRect:newBounds];
                [image unlockFocus];
                
                return [NSString stringWithFormat:@"<img src=\"data:image/tiff;base64,%@\" alt=\"\" />", [[image TIFFRepresentation] encodeBase64WithNewlines:NO]];
            }
        }
    }
    
    return rval;
}

@end

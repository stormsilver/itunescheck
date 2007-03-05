//
//  ScriptController.m
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/20/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "ScriptController.h"
#import "NSData-Base64Extensions.h"
#import "PrefsController.h"
#import "AppController.h"


@implementation ScriptController
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
            
        }
        
        sharedController = self;
    }
    
    return sharedController;
}


- (void) dealloc
{
    [super dealloc];
}

- (NSString *) infoForTag:(NSString *)tag
{
    if ([tag isEqualToString:@"artwork"])
    {
        NSAppleEventDescriptor *art = [self runAppleScript:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Scripts/artwork.scpt"]];
        if (art)
        {
            NSImage *image = [[[NSImage alloc] initWithData:[art data]] autorelease];
            //[art release];
            if ([image isValid])
            {
                float imagePrefSize = [[[PrefsController sharedController] prefForKey:PREFKEY_IMAGE_SIZE] floatValue];
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
        return @"";
    }
    else
    {
        NSString *rval = nil;
        NSString *script = [[PrefsController sharedController] pathForDisplayScript:tag];
        if (script)
        {
            NSAppleEventDescriptor *desc = [self runAppleScript:script];
            if (desc)
            {
                rval = [desc stringValue];
                //If the current replacement is the song rating, we need to do some additional stuff to change the number returned by iTunes into 0-5 stars
                if ([tag isEqualToString:@"rating"])
                {
                    switch ([rval intValue])
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
                }
            }

            if (!rval)
            {
                rval = @"";
            }
            return rval;
        }
    }
    
    return nil;
}

- (void) runHotKey:(id)sender
{
    NSLog(@"[Hot Key]  %@", [sender name]);
    NSString *name = [sender name];
    // Handle the three non-script hotkeys
    if ([name isEqualToString:PREFKEY_INFOWINDOW_KEYNAME])
    {
        // show the info window
        [[AppController sharedController] displayInfoWindow:nil];
    }
    else if ([name isEqualToString:PREFKEY_PREFERENCES_KEYNAME])
    {
        [[AppController sharedController] displayPreferencesWindow:nil];
    }
    else if ([name isEqualToString:PREFKEY_QUICKPLAY_KEYNAME])
    {
        [[AppController sharedController] displayQuickplayWindow:nil];
    }
    else
    {
        // run the script
        NSString *script = [[PrefsController sharedController] pathForHotKeyScript:name];
        if (script)
        {
            NSAppleEventDescriptor *desc = [self runAppleScript:script];
            if (desc)
            {
                if ([[[PrefsController sharedController] pref:PREFKEY_HOTKEY_SHOWINFOAFTER forHotKeyNamed:name] boolValue])
                {
                    // show the info window
                    NSLog(@"showin' the info window after a key press");
                }
            }
        }
    }
}


- (NSAppleEventDescriptor *) searchFor:(NSString *)search inPlaylist:(NSString *)playlist
{
    //First we'll set up the path to the AppleScript we need to run
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Scripts/findSong.applescript"];
    NSMutableString *findScript = [NSMutableString stringWithContentsOfFile:path];
    
    //Then we'll enter the user's search string into the script
    [findScript replaceOccurrencesOfString:@"searchValue" withString:search options:NSLiteralSearch range:NSMakeRange(0, [findScript length])];
    //And we'll enter the user's selected playlist into the script
    [findScript replaceOccurrencesOfString:@"playlistValue" withString:playlist options:NSLiteralSearch range:NSMakeRange(0, [findScript length])];
    NSError *error;
    if (![findScript writeToFile:@"/Users/ssilver/Desktop/find.applescript" atomically:NO encoding:NSUnicodeStringEncoding error:&error])
    {
        NSLog(@"Could not write file: %@", error);
    }
    //then we'll run it
	NSAppleScript *theScript = [[NSAppleScript alloc] initWithSource:findScript];
	NSDictionary *errorDict;
    NSAppleEventDescriptor *rval = [theScript executeAndReturnError:&errorDict];
    if (!rval)
    {
        NSLog(@"Search error!\n%@", errorDict);
        [theScript release];
        return nil;
    }
	[theScript release];
    
    return rval;
}

- (NSAppleEventDescriptor *) runAppleScript:(NSString *)script
{
    NSAppleScript *theScript;
	NSAppleEventDescriptor *desc;
	NSDictionary *errorDict;
    
    theScript = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:script] error:&errorDict];
    if (!theScript)
    {
        NSLog(@"Error: Tried to load script \"%@\" but couldn't because %@", [NSURL fileURLWithPath:script], errorDict);
        [theScript release];
        return nil;
    }
    
    desc = [theScript executeAndReturnError:&errorDict];
    if (!desc)
    {
        [theScript release];
        return nil;
    }
	
	[theScript release];
	
	return desc;
}
@end

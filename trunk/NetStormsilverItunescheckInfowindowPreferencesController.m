//
//  NetStormsilverItunescheckInfowindowPreferencesController.m
//  iTunesCheck
//
//  Created by Eric Hankins on 12/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetStormsilverItunescheckInfowindowPreferencesController.h"


@implementation InfoWindowPreferencesController

+ (NSArray *) preferencePanes
{
    return [NSArray arrayWithObjects:[[[InfoWindowPreferencesController alloc] init] autorelease], nil];
}


- (NSView *) paneView
{
    BOOL loaded = YES;
    
    if (!prefsView)
    {
        loaded = [NSBundle loadNibNamed:@"InfoWindowPrefPane" owner:self];
    }
    
    if (loaded)
    {
        return prefsView;
    }
    
    return nil;
}


- (NSString *) paneName
{
    return @"Info Window";
}


- (NSImage *) paneIcon
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"InfoWindowPrefIcon"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile: path];
    return image;
}


- (NSString *) paneToolTip
{
    return @"Set the way the info window looks and behaves";
}


- (BOOL)allowsHorizontalResizing
{
    return NO;
}


- (BOOL)allowsVerticalResizing
{
    return NO;
}

@end

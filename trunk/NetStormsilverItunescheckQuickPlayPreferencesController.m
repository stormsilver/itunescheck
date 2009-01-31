//
//  NetStormsilverItunescheckQuickPlayPreferencesController.m
//  iTunesCheck
//
//  Created by Eric Hankins on 1/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NetStormsilverItunescheckQuickPlayPreferencesController.h"


@implementation QuickPlayPreferencesController

+ (NSArray *) preferencePanes
{
    return [NSArray arrayWithObjects:[[[QuickPlayPreferencesController alloc] init] autorelease], nil];
}

- (NSView *) paneView
{
    BOOL loaded = YES;
    
    if (!prefsView)
    {
        loaded = [NSBundle loadNibNamed:@"QuickPlayPrefPane" owner:self];
    }
    
    if (loaded)
    {
        return prefsView;
    }
    
    return nil;
}

- (NSString *) paneName
{
    return @"QuickPlay";
}

- (NSImage *) paneIcon
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"system-search"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile: path];
    return image;
}

- (NSString *) paneToolTip
{
    return @"Set the way QuickPlay looks and behaves";
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

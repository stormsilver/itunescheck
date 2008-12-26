//
//  HotKeyPreferencesController.m
//  iTunesCheck
//
//  Created by Eric Hankins on 12/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "HotKeyPreferencesController.h"


@implementation HotKeyPreferencesController
static HotKeyPreferencesController *sharedPreferencesController = nil;

+ (NSArray *) preferencePanes
{
    // this is to load the controller from a nib file
    if (!sharedPreferencesController)
    {
        sharedPreferencesController = [NSArray arrayWithObjects:[[HotKeyPreferencesController alloc] init], nil];
    }
    return [NSArray arrayWithObject:sharedPreferencesController];
}

- (void) awakeFromNib
{
    sharedPreferencesController = self;
}

- (NSView *) paneView
{
    return prefsView;
}


- (NSString *) paneName
{
    return @"Hot Keys";
}


- (NSImage *) paneIcon
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"PTKeyboardIcon"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile: path];
    return image;
}


- (NSString *) paneToolTip
{
    return @"Set hot key preferences";
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

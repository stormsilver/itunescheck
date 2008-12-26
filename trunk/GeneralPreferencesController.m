//
//  GeneralPreferencesController.m
//  iTunesCheck
//
//  Created by Eric Hankins on 12/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GeneralPreferencesController.h"


@implementation GeneralPreferencesController

static GeneralPreferencesController *sharedPreferencesController = nil;

+ (NSArray *) preferencePanes
{
    // this is to load the controller from a nib file
    if (!sharedPreferencesController)
    {
        sharedPreferencesController = [NSArray arrayWithObjects:[[GeneralPreferencesController alloc] init], nil];
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
    return @"General";
}


- (NSImage *) paneIcon
{
    return [NSImage imageNamed: @"NSPreferencesGeneral"];
}


- (NSString *) paneToolTip
{
    return @"Set general iTunesCheck preferences";
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
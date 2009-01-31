//
//  GeneralPreferencesController.m
//  iTunesCheck
//
//  Created by Eric Hankins on 12/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GeneralPreferencesController.h"
#import <QuartzCore/QuartzCore.h>

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
    aboutVisible = NO;
    [versionLabel setStringValue:[NSString stringWithFormat:@"Version %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]]];
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

- (IBAction) quitProgram:(id)sender
{
    [NSApp terminate:sender];
}
- (IBAction) visitWebsite:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[sender title]]];
}

- (IBAction) about:(id)sender
{
    if (!aboutVisible)
    {
        aboutVisible = YES;
        [[[window contentView] animator] replaceSubview:prefsView with:aboutView];
    }
    else
    {
        aboutVisible = NO;
        [[[window contentView] animator] replaceSubview:aboutView with:prefsView];
    }
}

@end
//
//  HotKeyPreferencesController.m
//  iTunesCheck
//
//  Created by Eric Hankins on 12/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "HotKeyPreferencesController.h"
#import "PTKeyComboPanel.h"
#import "PreferencesController.h"
#import "PTKeyCombo.h"
#import "PTHotKey.h"
#import "ShortcutRecorderCell.h"

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

- (IBAction) changeHotKey:(id)sender
{
    if ([sender representedObject] != nil && [[sender representedObject] isKindOfClass:[PTHotKey class]])
    {
        ShortcutRecorderCell *recorderCell = (ShortcutRecorderCell *)sender;
        PTHotKey *hotKey = [sender representedObject];
        PTKeyCombo *newKeyCombo = [recorderCell keyCombo];
        NSLog(@"Changing %@ to %@", hotKey, newKeyCombo);
        [hotKey setKeyCombo:newKeyCombo];
    }
}

@end

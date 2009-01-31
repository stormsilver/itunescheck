//
//  PreferencesWindowController.h
//  iTunesCheck
//
//  Created by Eric Hankins on 12/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
//
// Includes SS_PrefsController code by Matt Gemmell -> http://mattgemmell.com

#import <Cocoa/Cocoa.h>

@class PreferencesController, BundleController, GeneralPreferencesController, HotKeyPreferencesController, ShortcutRecorderTextView;

@interface PreferencesWindowController : NSWindowController
{
    IBOutlet PreferencesController          *preferencesController;
    BundleController                        *bundleController;
    
    NSMutableDictionary                     *preferencePanes;
    NSMutableArray                          *panesOrder;
    
    NSToolbar                               *prefsToolbar;
    NSMutableDictionary                     *prefsToolbarItems;
    
    IBOutlet GeneralPreferencesController   *generalPreferencesController;
    IBOutlet HotKeyPreferencesController    *hotKeyPreferencesController;
    
    ShortcutRecorderTextView                *shortcutRecorderTextView;
    
    NSView                                  *currentView;
}

- (BOOL) loadPrefsPaneNamed:(NSString *)name display:(BOOL)disp;

- (IBAction) prefsToolbarItemClicked:(NSToolbarItem*)item;

@end

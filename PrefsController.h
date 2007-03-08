//
//  PrefsController.h
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/27/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


#define PREFKEY_INITIAL_SETUP_DONE          @"initialSetupDone"

#define PREFKEY_WINDOW_TRANSITION_IN_TIME       @"windowTransitionInTime"
#define PREFKEY_WINDOW_TRANSITION_OUT_TIME      @"windowTransitionOutTime"
#define PREFKEY_WINDOW_TRANSITION_IN_STYLE      @"windowTransitionInStyle"
#define PREFKEY_WINDOW_TRANSITION_OUT_STYLE     @"windowTransitionOutStyle"

#define PREFKEY_INFO_ORIGIN                 @"infoOrigin"
#define PREFKEY_INFO_VIEW                   @"infoView"
// 0: always,   1: song change,     2: hot key only
#define PREFKEY_INFO_SHOW_ON                @"showInfoWindowOn"
#define PREFKEY_INFO_DELAY_TIME             @"infoDelayTime"
#define PREFKEY_IMAGE_SIZE                  @"imageSize"

#define PREFKEY_QUICKPLAY_KEYNAME           @"Show QuickPlay Window"
#define PREFKEY_PREFERENCES_KEYNAME         @"Show Preferences Window"
#define PREFKEY_INFOWINDOW_KEYNAME          @"Show Info Window"

#define PREFKEY_HOTKEY_NAME                 @"name"
#define PREFKEY_HOTKEY_PATH                 @"path"
#define PREFKEY_HOTKEY_SHOWINFOAFTER        @"showInfoWindowAfter"
#define PREFKEY_HOTKEY_HOTKEY               @"hotKey"
#define PREFKEY_HOTKEY_STRINGREP            @"keyComboStringRep"
#define PREFKEY_HOTKEY_ENABLED              @"enabled"
#define PREFKEY_HOTKEY_KEYCOMBO_KEYPATH     PREFKEY_HOTKEY_HOTKEY @".keyCombo"



@class PTHotKey;

@interface PrefsController : NSObject
{
    NSMutableArray          *_displayPlugins;
    NSMutableArray          *_hotKeyPlugins;
}
+ (id) sharedController;

- (NSArray *) transitionStyles;

- (void) save;

- (void) setPref:(id)pref forKey:(NSString *)key;
- (id) prefForKey:(NSString *)key;
- (id) pref:(NSString *)key forHotKeyNamed:(NSString *)name;
- (PTHotKey *) hotKeyAtIndex:(unsigned int)index;
- (NSString *) pathForDisplayScript:(NSString *)name;
- (NSString *) pathForHotKeyScript:(NSString *)name;

- (void) loadHotKeyPlugins;
- (void) loadDisplayPlugins;
- (NSMutableArray *) displayPlugins;
- (void) setDisplayPlugins:(NSMutableArray *)plugins;
- (NSMutableArray *) hotKeyPlugins;
- (void) setHotKeyPlugins:(NSMutableArray *)plugins;
@end

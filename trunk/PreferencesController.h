//
//  PreferencesController.h
//  iTunesCheck
//
//  Created by Eric Hankins on 12/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define PREFKEY_HOTKEY_NAME                 @"name"
//#define PREFKEY_HOTKEY_SHOWINFOAFTER        @"showInfoWindowAfter"
#define PREFKEY_HOTKEY_HOTKEY               @"hotKey"
#define PREFKEY_HOTKEY_STRINGREP            @"keyComboStringRep"
#define PREFKEY_HOTKEY_ENABLED              @"enabled"
#define PREFKEY_HOTKEY_KEYCOMBO_KEYPATH     PREFKEY_HOTKEY_HOTKEY @".keyCombo"

@interface PreferencesController : NSObject
{
    NSMutableDictionary     *displayTags;
    NSMutableDictionary     *hotKeys;
    NSMutableArray          *hotKeysArray;
}

+ (PreferencesController *) sharedController;

- (void) save;

- (void) setTarget:(id)target forDisplayTag:(NSString *)tag;
- (id) targetForDisplayTag:(NSString *)tag;

- (void) setTarget:(id)target forHotKeyNamed:(NSString *)name;
- (void) setTarget:(id)target forHotKeyNamed:(NSString *)name withKeyCode:(int)keyCode andModifiers:(int)modifiers;
- (id) targetForHotKeyNamed:(NSString *)name;
- (NSArray *) hotKeys;

- (id) prefForKey:(NSString *)key;
- (id) prefForBundle:(NSString *)bundleIdentifier key:(NSString *)key;

- (void) setPreferences:(NSDictionary *)dict forBundle:(NSString *)bundleIdentifier;
- (void) setPrefForBundle:(NSString *)bundleIdentifier key:(NSString *)key value:(id)value;

@end

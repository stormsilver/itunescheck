//
//  PrefsController.h
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/27/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PTHotKey;

@interface PrefsController : NSObject
{
    NSMutableDictionary     *_prefs;
    NSMutableArray          *_displayPlugins;
    NSMutableArray          *_hotKeyPlugins;
    NSUserDefaults          *_defaults;
}
+ (id) sharedController;

- (id) prefForKey:(id)key;
- (id) pref:(NSString *)key forHotKeyNamed:(NSString *)name;
- (PTHotKey *) hotKeyAtIndex:(unsigned int)index;
- (NSString *) pathForDisplayScript:(NSString *)name;
- (NSString *) pathForHotKeyScript:(NSString *)name;

- (void) loadPlugins;
- (NSMutableArray *) displayPlugins;
- (void) setDisplayPlugins:(NSMutableArray *)plugins;
- (NSMutableArray *) hotKeyPlugins;
- (void) setHotKeyPlugins:(NSMutableArray *)plugins;
@end

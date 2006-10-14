//
//  PrefsController.h
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/27/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PrefsController : NSObject
{
    NSMutableDictionary     *_prefs;
    NSMutableDictionary     *_displayPlugins;
    NSMutableDictionary     *_hotKeyPlugins;
    NSUserDefaults          *_defaults;
}
+ (id) sharedController;

- (id) prefForKey:(id)key;
- (NSString *) pathForScript:(NSString *)name;

- (void) loadPlugins;
- (NSArray *) displayPlugins;
- (void) setDisplayPlugins:(NSDictionary *)plugins;
- (NSArray *) hotKeyPlugins;
- (void) setHotKeyPlugins:(NSArray *)plugins;
@end

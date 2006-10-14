//
//  PluginsController.h
//  iTunesCheck
//
//  Created by StormSilver on Fri Aug 06 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PluginsController : NSObject
{
    IBOutlet id currentSelection;
    IBOutlet id objectController;
    
    NSMutableDictionary *hotKeyPlugins;
    NSString *thirdPartyPlugins;
}

- (IBAction) loadPlugins:(id)sender;
- (void) parsePlugins:(NSString *)directory;

- (NSArray *) hotKeyPlugins;
- (void) setHotKeyPlugins: (NSDictionary *)plugins;

- (IBAction) setHotKey:(id)sender;
- (IBAction) enableHotKey:(id)sender;
- (IBAction) enableOption1:(id)sender;
- (IBAction) enableShowInfo:(id)sender;

- (void) regHotKey:(NSString *)name;
- (IBAction) hotKeyDown:(id)sender;

- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;

@end

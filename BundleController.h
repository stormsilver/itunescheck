//
//  BundleController.h
//  iTunesCheck
//
//  Created by Eric Hankins on 12/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PreferencesController, AbstractBundle;

#define BUNDLE_EXT @"bundle"
#define PREFPANE_BUNDLE_EXT @"preferencePane"
#define APP_SUPPORT_SUBPATH  @"Application Support/iTunesCheck/PlugIns"

@interface BundleController : NSObject
{
    PreferencesController *preferencesController;
    
    //NSMutableArray *bundles;
    NSMutableDictionary *bundleInstances;
    NSMutableArray *preferencePanes;
    NSMutableArray *displayBundles;
    NSMutableArray *hotKeyBundles;
}

+ (BundleController*) sharedController;
//- (NSArray *) bundles;
- (AbstractBundle *) controllerForBundleIdentifier:(NSString *)bundleIdentifier;
- (NSArray *) bundleInstances;
- (NSArray*) displayBundles;
- (NSArray*) hotKeyBundles;
- (NSArray *) preferencePanes;
@end

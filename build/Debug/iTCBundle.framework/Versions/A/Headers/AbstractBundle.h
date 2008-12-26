//
//  AbstractBundle.h
//  iTunesCheck
//
//  Created by Eric Hankins on 12/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iTunes.h"
#import "BundleController.h"
#import "PreferencesController.h"


@interface AbstractBundle : NSObject
{
    @protected
    iTunesApplication *iTunes;
    BundleController *bundleController;
    PreferencesController *preferencesController;
    
    NSString *bundleIdentifier;
}

- (NSString *) shortName;
- (BOOL) defaultAction;
- (void) finishLoading;


- (void) setBundleController:(BundleController *)bc;
- (void) setPreferencesController:(PreferencesController *)pc;
- (void) setBundleIdentifier:(NSString *)ident;

- (BOOL) isDisplayBundle;
- (BOOL) isHotKeyBundle;

@end

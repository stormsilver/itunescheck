//
//  AbstractBundle.m
//  iTunesCheck
//
//  Created by Eric Hankins on 12/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractBundle.h"

@implementation AbstractBundle

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    }
    return self;
}

- (NSString *) shortName
{
    return @"AbstractBundle";
}

- (BOOL) defaultAction
{
    return YES;
}

- (void) finishLoading
{
}

- (void) setBundleController:(BundleController *)bc
{
    bundleController = bc;
}
- (void) setPreferencesController:(PreferencesController *)pc
{
    preferencesController = pc;
}
- (void) setBundleIdentifier:(NSString *)ident
{
    bundleIdentifier = ident;
}

- (BOOL) isDisplayBundle
{
    return NO;
}

- (BOOL) isHotKeyBundle
{
    return NO;
}

@end

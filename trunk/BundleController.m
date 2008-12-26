//
//  BundleController.m
//  iTunesCheck
//
//  Created by Eric Hankins on 12/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BundleController.h"
#import "PreferencesController.h"
#import <iTCBundle/iTC.h>


@interface BundleController (Private)
    - (void) loadAllPlugins;
    - (NSMutableArray *) allBundles;
@end




@implementation BundleController

static BundleController *sharedBundleController = nil;

+ (BundleController*) sharedController
{
    @synchronized (self)
    {
        if (sharedBundleController == nil)
        {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedBundleController;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (self)
    {
        if (sharedBundleController == nil)
        {
            sharedBundleController = [super allocWithZone:zone];
            return sharedBundleController;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        preferencesController = [PreferencesController sharedController];
        [self loadAllPlugins];
    }
    return self;
}

//- (NSArray *) bundles
//{
//    return [NSArray arrayWithArray:bundles];
//}
- (NSArray *) bundleInstances
{
    return [bundleInstances allValues];
}
//- (NSArray *) displayBundles
//{
//    return [NSArray arrayWithArray:displayBundles];
//}
//- (NSArray *) hotKeyBundles
//{
//    return [NSArray arrayWithArray:hotKeyBundles];
//}
- (NSArray *) preferencePanes
{
    return [NSArray arrayWithArray:preferencePanes];
}


- (AbstractBundle *) controllerForBundleIdentifier:(NSString *)bundleIdentifier
{
    return [bundleInstances objectForKey:bundleIdentifier];
}

@end









@implementation BundleController (Private)
- (void) loadAllPlugins
{
    NSMutableArray *bundlePaths;
    NSEnumerator *pathEnum;
    NSString *currPath;
    NSBundle *currBundle;
    Class currPrincipalClass;
    id currInstance;
    
    bundlePaths = [NSMutableArray array];
//    if (!bundles)
//    {
//        bundles = [[NSMutableArray alloc] init];
//    }
    if (!bundleInstances)
    {
        bundleInstances = [[NSMutableDictionary alloc] init];
    }
//    if (!displayBundles)
//    {
//        displayBundles = [[NSMutableArray alloc] init];
//    }
//    if (!hotKeyBundles)
//    {
//        hotKeyBundles = [[NSMutableArray alloc] init];
//    }
    if (!preferencePanes)
    {
        preferencePanes = [[NSMutableArray alloc] init];
    }
    [bundlePaths addObjectsFromArray:[self allBundles]];
    //NSLog(@"bundlePaths: %@", bundlePaths);
    
    pathEnum = [bundlePaths objectEnumerator];
    while (currPath = [pathEnum nextObject])
    {
        //NSLog(currPath);
        currBundle = [NSBundle bundleWithPath:currPath];
        if (currBundle)
        {
            currPrincipalClass = [currBundle principalClass];
            if (currPrincipalClass && [currPrincipalClass isSubclassOfClass:[AbstractBundle class]])
            {
                currInstance = [[currPrincipalClass alloc] init];
                if (currInstance)
                {
                    NSString *bundleId = [currBundle bundleIdentifier];
                    // dependency injection
                    [currInstance setBundleController:self];
                    [currInstance setPreferencesController:preferencesController];
                    [currInstance setBundleIdentifier:bundleId];
                    // tell the controller it's okay to load now
                    [currInstance finishLoading];
                    // add the bundle to various lists
                    //[bundles addObject:currBundle];
                    [bundleInstances setObject:currInstance forKey:bundleId];
//                    if ([currInstance isDisplayBundle])
//                    {
//                        [displayBundles addObject:currInstance];
//                    }
//                    if ([currInstance isHotKeyBundle])
//                    {
//                        [hotKeyBundles addObject:currInstance];
//                    }
                    
                    NSEnumerator* enumerator = [[NSBundle pathsForResourcesOfType:PREFPANE_BUNDLE_EXT inDirectory:[currBundle builtInPlugInsPath]] objectEnumerator];
                    NSString* panePath;
                    while ((panePath = [enumerator nextObject]))
                    {
                        NSBundle *paneBundle = [NSBundle bundleWithPath:panePath];
                        if (paneBundle)
                        {
                            [preferencePanes addObject:paneBundle];
                        }
                    }
                }
            }
        }
    }
}

- (NSMutableArray *) allBundles
{
    NSArray *librarySearchPaths;
    NSEnumerator *searchPathEnum;
    NSString *currPath;
    NSMutableArray *bundleSearchPaths = [NSMutableArray array];
    NSMutableArray *allBundles = [NSMutableArray array];
    
    librarySearchPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSAllDomainsMask - NSSystemDomainMask, YES);
    
    searchPathEnum = [librarySearchPaths objectEnumerator];
    while (currPath = [searchPathEnum nextObject])
    {
        [bundleSearchPaths addObject:[currPath stringByAppendingPathComponent:APP_SUPPORT_SUBPATH]];
    }
    [bundleSearchPaths addObject:[[NSBundle mainBundle] builtInPlugInsPath]];
    
    searchPathEnum = [bundleSearchPaths objectEnumerator];
    while (currPath = [searchPathEnum nextObject])
    {
        //NSLog(@"Checking path: %@", currPath);
        NSDirectoryEnumerator *bundleEnum;
        NSString *currBundlePath;
        bundleEnum = [[NSFileManager defaultManager] enumeratorAtPath:currPath];
        if (bundleEnum)
        {
            while (currBundlePath = [bundleEnum nextObject])
            {
                if ([[currBundlePath pathExtension] isEqualToString:BUNDLE_EXT])
                {
                    [allBundles addObject:[currPath stringByAppendingPathComponent:currBundlePath]];
                }
            }
        }
    }
    
    return allBundles;
}

@end

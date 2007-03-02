//
//  PrefsController.m
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/27/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PrefsController.h"
#import "Prefdefs.h"
#import "PTHotKeyCenter.h"
#import "PTHotKey.h"
#import "PTKeyComboPanel.h"
#import "PTKeyCombo.h"


@implementation PrefsController

static id sharedController;

+ (id) sharedController
{
    if (!sharedController)
    {
        [[self alloc] init];
    }
    
    return sharedController;
}

- (void) _loadPrefs
{
    [_prefs setObject:@"classic" forKey:PREFKEY_INFO_VIEW];
    [_prefs setObject:[NSNumber numberWithInt:160] forKey:PREFKEY_IMAGE_SIZE];
}

- (id) init
{
    if (!sharedController)
    {
        self = [super init];
        
        if (self)
        {
            _prefs = [[NSMutableDictionary alloc] init];
            _displayPlugins = nil;
            _hotKeyPlugins = nil;
            _defaults = [NSUserDefaults standardUserDefaults];
            [self loadPlugins];
            [self _loadPrefs];
        }
        
        sharedController = self;
    }
    
    return sharedController;
}

- (void) dealloc
{
    [_displayPlugins release];
    [_hotKeyPlugins release];
    [_prefs release];
    [_defaults release];
    [super dealloc];
}

- (id) prefForKey:(id)key
{
    return [_prefs objectForKey:key];
}

- (NSString *) pathForScript:(NSString *)name
{
    /* TODO: We should eventually do some caching here to make this process faster on subsequent lookups. */
    NSEnumerator *enumerator = [_displayPlugins objectEnumerator];
    NSMutableDictionary *dict;
    while (dict = [enumerator nextObject])
    {
        if ([[dict objectForKey:@"name"] isEqualToString:name])
        {
            return [dict objectForKey:@"path"];
        }
    }
    
    return nil;
}

- (NSMutableArray *) _parsePlugins:(NSString *)directory
{
    NSEnumerator *enumerator = [[[NSFileManager defaultManager] directoryContentsAtPath:directory] objectEnumerator];
    if (!enumerator)
    {
        return nil;
    }
    
    NSString *name;
    NSMutableArray *marr= [[NSMutableArray alloc] init];
    while (name = [enumerator nextObject])
    {
        // Filter out entires that start with '.'
        if ([name characterAtIndex:0] != '.')
        {
            [marr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [name stringByDeletingPathExtension],                   @"name",
                                [NSString stringWithFormat:@"%@/%@", directory, name],  @"path",
                                [NSNumber numberWithBool:NO],                           @"enabled",
                                [PTKeyCombo clearKeyCombo],                             @"keyCombo",
                                [NSNumber numberWithBool:NO],                           @"showInfoWindowAfter",
                                nil]];
        }
    }
    
    return [marr autorelease];
}

- (void) loadPlugins
{
    if (_displayPlugins != nil)
    {
        [_displayPlugins release];
    }
    if (_hotKeyPlugins != nil)
    {
        [_hotKeyPlugins release];
    }
    
    _displayPlugins = [[self _parsePlugins:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Scripts/Display"]] retain];
    _hotKeyPlugins = [[self _parsePlugins:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Scripts/Hot Key"]] retain];
    
    
}


- (NSMutableArray *) displayPlugins
{
    return _displayPlugins;
}
- (void) setDisplayPlugins:(NSMutableArray *)plugins
{
    NSLog(@"%@", plugins);
}
- (NSArray *) hotKeyPlugins
{
    return _hotKeyPlugins;
}
- (void) setHotKeyPlugins:(NSArray *)plugins
{
    NSLog(@"%@", plugins);
}


- (void) setValue:(id)value forKeyPath:(NSString *)keyPath
{
    NSLog(@"%@ for %@", value, keyPath);
}


@end

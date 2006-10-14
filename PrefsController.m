//
//  PrefsController.m
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/27/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PrefsController.h"
#import "Prefdefs.h"
/*
#import "PTHotKeyCenter.h"
#import "PTHotKey.h"
#import "PTKeyComboPanel.h"
#import "PTKeyCombo.h"
*/

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
    NSString *rval = [_displayPlugins objectForKey:name];
    if (rval)
    {
        return rval;
    }
    else
    {
        return [_hotKeyPlugins objectForKey:name];
    }
}

- (NSMutableDictionary *) _parsePlugins:(NSString *)directory
{
    NSEnumerator *enumerator = [[[NSFileManager defaultManager] directoryContentsAtPath:directory] objectEnumerator];
    if (!enumerator)
    {
        return nil;
    }
    
    NSString *name;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    while (name = [enumerator nextObject])
    {
        if (![name isEqual:@".DS_Store"])
        {
            [dict setObject:name forKey:[name stringByDeletingPathExtension]];
        }
    }
    
    return dict;
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
    
    _displayPlugins = [self _parsePlugins:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Scripts/Display"]];
    _hotKeyPlugins = [self _parsePlugins:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Scripts/Hot Key"]];
    
    
}


- (NSArray *) displayPlugins
{
    // NSArrayController expects the objects in the returned array to accept KVC, so we have to rebuild
    // the list into dictionaries
    NSMutableArray *marr = [[NSMutableArray alloc] init];
    NSEnumerator *enumerator = [[_displayPlugins allKeys] objectEnumerator];
    NSString *key;
    while (key = [enumerator nextObject])
    {
        [marr addObject:[NSDictionary dictionaryWithObject:key forKey:@"name"]];
    }
    
    return marr;
}
- (void) setDisplayPlugins:(NSDictionary *)plugins
{

}
- (NSArray *) hotKeyPlugins
{
    // NSArrayController expects the objects in the returned array to accept KVC, so we have to rebuild
    // the list into dictionaries
    NSMutableArray *marr = [[NSMutableArray alloc] init];
    NSEnumerator *enumerator = [[[_hotKeyPlugins allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectEnumerator];
    NSString *key;
    while (key = [enumerator nextObject])
    {
        [marr addObject:[NSMutableDictionary dictionaryWithObject:key forKey:@"name"]];
    }
    
    return marr;
}
- (void) setHotKeyPlugins:(NSArray *)plugins
{
    NSLog(@"%@", plugins);
}



@end

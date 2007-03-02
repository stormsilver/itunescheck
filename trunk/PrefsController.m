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
#import "PTKeyCombo.h"
#import "ScriptController.h"


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
    
    PTHotKey *hk = [[PTHotKey alloc] init];
    [hk setKeyCombo:[PTKeyCombo keyComboWithKeyCode:8 modifiers:2304]];
    [hk setName:@"Show Info Window"];
    [hk setTarget:[ScriptController sharedController]];
    [hk setAction:@selector(runHotKey:)];
    NSMutableDictionary *opts = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        @"Show Info Window", @"name",
        hk, @"hotKey",
        [NSNumber numberWithBool:NO], @"showInfoWindowAfter",
        [[hk keyCombo] description], @"keyComboStringRep",
        [NSNumber numberWithBool:YES], @"enabled",
        nil];
    [_hotKeyPlugins addObject:opts];
    
    [opts addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:@"Show Info Window"];
    [opts addObserver:self forKeyPath:@"showInfoWindowAfter" options:NSKeyValueObservingOptionNew context:@"Show Info Window"];
    [opts addObserver:self forKeyPath:@"hotKey.keyCombo" options:NSKeyValueObservingOptionNew context:@"Show Info Window"];
    [[PTHotKeyCenter sharedCenter] registerHotKey:hk];
    [hk release];
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
            // need to build the plugins first ...
            [self loadPlugins];
            // ... so we can load the prefs on top of them
            [self _loadPrefs];
            
            NSSortDescriptor *nameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
            [_hotKeyPlugins sortUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
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

- (id) pref:(NSString *)key forHotKeyNamed:(NSString *)name
{
    NSEnumerator *enumerator;
    NSMutableDictionary *dict;
    enumerator = [_hotKeyPlugins objectEnumerator];
    while (dict = [enumerator nextObject])
    {
        if ([[dict objectForKey:@"name"] isEqualToString:name])
        {
            return [dict objectForKey:key];
        }
    }
    
    return nil;
}

- (PTHotKey *) hotKeyAtIndex:(unsigned int)index
{
    return [[_hotKeyPlugins objectAtIndex:index] objectForKey:@"hotKey"];
}

- (NSString *) pathForDisplayScript:(NSString *)name
{
    NSEnumerator *enumerator;
    NSMutableDictionary *dict;
    enumerator = [_displayPlugins objectEnumerator];
    while (dict = [enumerator nextObject])
    {
        if ([[dict objectForKey:@"name"] isEqualToString:name])
        {
            return [dict objectForKey:@"path"];
        }
    }
    
    return nil;
}

- (NSString *) pathForHotKeyScript:(NSString *)name
{
    NSEnumerator *enumerator;
    NSMutableDictionary *dict;
    enumerator = [_hotKeyPlugins objectEnumerator];
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
    // TODO: split this into hotkey and display directories so we don't load a bunch of stuff that we don't need to
    // like hot keys for display plugins
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
            NSString *baseName = [name stringByDeletingPathExtension];
            // Set up a blank hotkey. We'll set it up later
            PTHotKey *hk = [[PTHotKey alloc] init];
            [hk setName:baseName];
            [hk setKeyCombo:[PTKeyCombo clearKeyCombo]];
            [hk setTarget:[ScriptController sharedController]];
            [hk setAction:@selector(runHotKey:)];
            NSMutableDictionary *opts = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                baseName,                                               @"name",
                [NSString stringWithFormat:@"%@/%@", directory, name],  @"path",
                [NSNumber numberWithBool:NO],                           @"enabled",
                hk,                                                     @"hotKey",
                [[PTKeyCombo clearKeyCombo] description],               @"keyComboStringRep",
                [NSNumber numberWithBool:NO],                           @"showInfoWindowAfter",
                nil];
            [marr addObject:opts];
            // Register for changes to these keys. This is how we know when the user is changing stuff.
            [opts addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:baseName];
            [opts addObserver:self forKeyPath:@"showInfoWindowAfter" options:NSKeyValueObservingOptionNew context:baseName];
            [opts addObserver:self forKeyPath:@"hotKey.keyCombo" options:NSKeyValueObservingOptionNew context:baseName];
            [hk release];
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
- (NSMutableArray *) hotKeyPlugins
{
    return _hotKeyPlugins;
}
- (void) setHotKeyPlugins:(NSMutableArray *)plugins
{
    NSLog(@"%@", plugins);
}


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //NSLog(@"(%@) keyPath: %@ -- new value: %@", context, keyPath, [change objectForKey:NSKeyValueChangeNewKey]);
    if ([keyPath isEqualToString:@"enabled"])
    {
        if ([[change objectForKey:NSKeyValueChangeNewKey] boolValue])
        {
            // enable the key
            [[PTHotKeyCenter sharedCenter] registerHotKey:[object objectForKey:@"hotKey"]];
        }
        else
        {
            // disable the key
            [[PTHotKeyCenter sharedCenter] unregisterHotKey:[object objectForKey:@"hotKey"]];
        }
    }
    else if ([keyPath isEqualToString:@"showInfoWindowAfter"])
    {
        // do we need to do anything here?
    }
    else if ([keyPath isEqualToString:@"hotKey.keyCombo"])
    {
        // Update the string rep of this key
        [object setObject:[[[object objectForKey:@"hotKey"] keyCombo] description] forKey:@"keyComboStringRep"];
        // The key combo changed. Register the new key.
        if ([[object objectForKey:@"enabled"] boolValue])
        {
            // register the key only if it's enabled
            [[PTHotKeyCenter sharedCenter] registerHotKey:[object objectForKey:@"hotKey"]];
        }
    }
}


@end

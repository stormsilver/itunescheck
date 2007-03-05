//
//  PrefsController.m
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/27/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PrefsController.h"
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
    //Load up the preferences defaults. User preferences are *automatically* applied over these defaults. We don't have to do anything more.
    NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UserDefaults" ofType:@"plist"]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:defaultPrefs];
    
    // Now get the preferences for hot keys out of the preferences (whether a default or user pref doesn't matter, it always gets the right one)
    // and turn them into actual hot keys. We'll also listen for changes to these hot keys and be sure to write them back to the defaults.
    // By this time the hot keys have already been loaded from the directory of hot key scripts, so we know which ones are available. We'll walk 
    // that list and then overwrite its values. Note that the values we're going to overwrite are being listened to; by simply changing them here 
    // we will automatically take the right action (registering the key, setting the stringRep, etc.). KVO rocks!
    NSEnumerator *enumerator = [_hotKeyPlugins objectEnumerator];
    NSMutableDictionary *dict;
    while (dict = [enumerator nextObject])
    {
        NSString *name = [dict objectForKey:PREFKEY_HOTKEY_NAME];
        NSDictionary *keyPrefs = [[NSUserDefaults standardUserDefaults] dictionaryForKey:name];
        // only if there's a dictionary for this key
        if (keyPrefs)
        {
            id pref = [keyPrefs objectForKey:@"keyCombo"];
            if (pref)
            {
                PTKeyCombo *keyCombo = [[PTKeyCombo alloc] initWithPlistRepresentation:pref];
                [[dict objectForKey:PREFKEY_HOTKEY_HOTKEY] setKeyCombo:keyCombo];
                [keyCombo release];
            }
            
            pref = [keyPrefs objectForKey:PREFKEY_HOTKEY_ENABLED];
            if (pref)
            {
                [dict setValue:pref forKey:PREFKEY_HOTKEY_ENABLED];
            }
            
            pref = [keyPrefs objectForKey:PREFKEY_HOTKEY_SHOWINFOAFTER];
            if (pref)
            {
                [dict setValue:pref forKey:PREFKEY_HOTKEY_SHOWINFOAFTER];
            }
        }
    }
}

- (id) init
{
    if (!sharedController)
    {
        self = [super init];
        
        if (self)
        {
            _displayPlugins = nil;
            _hotKeyPlugins = nil;
            // need to build the plugins first ...
            [self loadHotKeyPlugins];
            [self loadDisplayPlugins];
            // ... so we can load the prefs on top of them
            [self _loadPrefs];
            
            NSSortDescriptor *nameDescriptor = [[[NSSortDescriptor alloc] initWithKey:PREFKEY_HOTKEY_NAME ascending:YES] autorelease];
            [_hotKeyPlugins sortUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
        }
        
        sharedController = self;
    }
    
    return sharedController;
}

- (void) dealloc
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_displayPlugins release];
    [_hotKeyPlugins release];
    [super dealloc];
}

- (id) prefForKey:(id)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (id) pref:(NSString *)key forHotKeyNamed:(NSString *)name
{
    NSEnumerator *enumerator;
    NSMutableDictionary *dict;
    enumerator = [_hotKeyPlugins objectEnumerator];
    while (dict = [enumerator nextObject])
    {
        if ([[dict objectForKey:PREFKEY_HOTKEY_NAME] isEqualToString:name])
        {
            return [dict objectForKey:key];
        }
    }
    
    return nil;
}

- (PTHotKey *) hotKeyAtIndex:(unsigned int)index
{
    return [[_hotKeyPlugins objectAtIndex:index] objectForKey:PREFKEY_HOTKEY_HOTKEY];
}

- (NSString *) pathForDisplayScript:(NSString *)name
{
    NSEnumerator *enumerator;
    NSMutableDictionary *dict;
    enumerator = [_displayPlugins objectEnumerator];
    while (dict = [enumerator nextObject])
    {
        if ([[dict objectForKey:PREFKEY_HOTKEY_NAME] isEqualToString:name])
        {
            return [dict objectForKey:PREFKEY_HOTKEY_PATH];
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
        if ([[dict objectForKey:PREFKEY_HOTKEY_NAME] isEqualToString:name])
        {
            return [dict objectForKey:PREFKEY_HOTKEY_PATH];
        }
    }
    
    return nil;
}

- (NSMutableDictionary *) _createDictionaryWithName:(NSString *)name directory:(NSString *)directory
{
    // Set up a blank hotkey. We'll initialize it later
    PTHotKey *hk = [[PTHotKey alloc] init];
    [hk setName:name];
    [hk setKeyCombo:[PTKeyCombo clearKeyCombo]];
    [hk setTarget:[ScriptController sharedController]];
    [hk setAction:@selector(runHotKey:)];
    NSMutableDictionary *opts = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        name,                                               PREFKEY_HOTKEY_NAME,
        [NSNumber numberWithBool:NO],                           PREFKEY_HOTKEY_ENABLED,
        hk,                                                     PREFKEY_HOTKEY_HOTKEY,
        [[PTKeyCombo clearKeyCombo] description],               PREFKEY_HOTKEY_STRINGREP,
        [NSNumber numberWithBool:NO],                           PREFKEY_HOTKEY_SHOWINFOAFTER,
        nil];
    // only set the path if a directory was given. This is how we filter out the non-script hotkeys
    if (directory)
    {
        [opts setObject:[NSString stringWithFormat:@"%@/%@.scpt", directory, name] forKey:PREFKEY_HOTKEY_PATH];
    }
    // Register for changes to these keys. This is how we know when the user is changing stuff.
    [opts addObserver:self forKeyPath:PREFKEY_HOTKEY_ENABLED options:NSKeyValueObservingOptionNew context:NULL];
    [opts addObserver:self forKeyPath:PREFKEY_HOTKEY_SHOWINFOAFTER options:NSKeyValueObservingOptionNew context:NULL];
    [opts addObserver:self forKeyPath:PREFKEY_HOTKEY_KEYCOMBO_KEYPATH options:NSKeyValueObservingOptionNew context:NULL];
    [hk release];
    
    return opts;
}

- (void) loadHotKeyPlugins
{
    if (_hotKeyPlugins != nil)
    {
        [_hotKeyPlugins release];
    }
    
    //_hotKeyPlugins = [[self _parsePlugins:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Scripts/Hot Key"]] retain];
    NSString *directory = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Scripts/Hot Key"];
    NSEnumerator *enumerator = [[[NSFileManager defaultManager] directoryContentsAtPath:directory] objectEnumerator];
    if (!enumerator)
    {
        _hotKeyPlugins = nil;
        return;
    }
    
    NSString *name;
    NSMutableArray *marr= [[NSMutableArray alloc] init];
    while (name = [enumerator nextObject])
    {
        // Filter out entires that start with '.'
        if ([name characterAtIndex:0] != '.')
        {
            NSString *baseName = [name stringByDeletingPathExtension];
            [marr addObject:[self _createDictionaryWithName:baseName directory:directory]];
        }
    }
    
    // Add the three non-script hotkeys
    [marr addObject:[self _createDictionaryWithName:PREFKEY_INFOWINDOW_KEYNAME directory:nil]];
    [marr addObject:[self _createDictionaryWithName:PREFKEY_QUICKPLAY_KEYNAME directory:nil]];
    [marr addObject:[self _createDictionaryWithName:PREFKEY_PREFERENCES_KEYNAME directory:nil]];
    
    _hotKeyPlugins = marr;
}
- (void) loadDisplayPlugins
{
    if (_displayPlugins != nil)
    {
        [_displayPlugins release];
    }
    
    //_displayPlugins = [[self _parsePlugins:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Scripts/Display"]] retain];
    NSString *directory = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Scripts/Display"];
    NSEnumerator *enumerator = [[[NSFileManager defaultManager] directoryContentsAtPath:directory] objectEnumerator];
    if (!enumerator)
    {
        _displayPlugins = nil;
        return;
    }
    
    NSString *name;
    NSMutableArray *marr= [[NSMutableArray alloc] init];
    while (name = [enumerator nextObject])
    {
        // Filter out entires that start with '.'
        if ([name characterAtIndex:0] != '.')
        {
            NSString *baseName = [name stringByDeletingPathExtension];
            NSMutableDictionary *opts = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                baseName,                                               PREFKEY_HOTKEY_NAME,
                [NSString stringWithFormat:@"%@/%@", directory, name],  PREFKEY_HOTKEY_PATH,
                nil];
            [marr addObject:opts];
        }
    }
    
    _displayPlugins = marr;
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


- (void) _writeHotKeyPref:(id)pref name:(NSString *)key forKeyNamed:(NSString *)name
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:name];
    if (!dict)
    {
        // init a new dictionary
        dict = [NSDictionary dictionaryWithObject:pref forKey:key];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:name];
    }
    else
    {
        // convert the dictionary to a mutable one
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        // set the value
        [mutableDict setValue:pref forKey:key];
        [[NSUserDefaults standardUserDefaults] setObject:mutableDict forKey:name];
    }
}


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //NSLog(@"(%@) keyPath: %@ -- new value: %@", [object objectForKey:PREFKEY_HOTKEY_NAME], keyPath, [change objectForKey:NSKeyValueChangeNewKey]);
    if ([keyPath isEqualToString:PREFKEY_HOTKEY_ENABLED])
    {
        // write this back to defaults
        [self _writeHotKeyPref:[change objectForKey:NSKeyValueChangeNewKey] name:PREFKEY_HOTKEY_ENABLED forKeyNamed:[object objectForKey:PREFKEY_HOTKEY_NAME]];
        if ([[change objectForKey:NSKeyValueChangeNewKey] boolValue])
        {
            // enable the key
            [[PTHotKeyCenter sharedCenter] registerHotKey:[object objectForKey:PREFKEY_HOTKEY_HOTKEY]];
        }
        else
        {
            // disable the key
            [[PTHotKeyCenter sharedCenter] unregisterHotKey:[object objectForKey:PREFKEY_HOTKEY_HOTKEY]];
        }
    }
    else if ([keyPath isEqualToString:PREFKEY_HOTKEY_SHOWINFOAFTER])
    {
        // write this back to defaults
        [self _writeHotKeyPref:[change objectForKey:NSKeyValueChangeNewKey] name:PREFKEY_HOTKEY_SHOWINFOAFTER forKeyNamed:[object objectForKey:PREFKEY_HOTKEY_NAME]];
        // do we need to do anything else here?
    }
    else if ([keyPath isEqualToString:PREFKEY_HOTKEY_KEYCOMBO_KEYPATH])
    {
        // Update the string rep of this key
        [object setObject:[[[object objectForKey:PREFKEY_HOTKEY_HOTKEY] keyCombo] description] forKey:PREFKEY_HOTKEY_STRINGREP];
        // Write the new key back to defaults
        [self _writeHotKeyPref:[[[object objectForKey:PREFKEY_HOTKEY_HOTKEY] keyCombo] plistRepresentation] name:@"keyCombo" forKeyNamed:[object objectForKey:PREFKEY_HOTKEY_NAME]];
        // The key combo changed. Register the new key.
        if ([[object objectForKey:PREFKEY_HOTKEY_ENABLED] boolValue])
        {
            // register the key only if it's enabled
            [[PTHotKeyCenter sharedCenter] registerHotKey:[object objectForKey:PREFKEY_HOTKEY_HOTKEY]];
        }
    }
}


@end

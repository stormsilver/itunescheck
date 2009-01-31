//
//  PreferencesController.m
//  iTunesCheck
//
//  Created by Eric Hankins on 12/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PreferencesController.h"
#import "PTHotKeyCenter.h"
#import "PTHotKey.h"
#import "PTKeyCombo.h"
#import <AGRegex/AGRegex.h>
#include <wctype.h>

@interface PreferencesController (Private)
- (NSMutableDictionary *) initializeHotKeyNamed:(NSString *)name withTarget:(id)target;
- (void) writeHotKeyPref:(id)pref name:(NSString *)key forKeyNamed:(NSString *)name;
- (SEL) hotKeySelectorForName:(NSString *)name;
@end






@implementation PreferencesController

static PreferencesController *sharedPreferencesController = nil;

+ (PreferencesController*) sharedController
{
    @synchronized (self)
    {
        if (sharedPreferencesController == nil)
        {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedPreferencesController;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (self)
    {
        if (sharedPreferencesController == nil)
        {
            sharedPreferencesController = [super allocWithZone:zone];
            return sharedPreferencesController;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id) copyWithZone:(NSZone *)zone
{
    return self;
}

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        displayTags = [[NSMutableDictionary alloc] init];
        hotKeys = [[NSMutableDictionary alloc] init];
        NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UserDefaults" ofType:@"plist"]];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
        [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:defaultPrefs];
    }
    return self;
}

+ (BOOL) automaticallyNotifiesObserversForKey:(NSString *)theKey
{
    BOOL automatic = NO;
    if ([theKey isEqualToString:@"hotKeys"])
    {
        automatic = NO;
    }
    else
    {
        automatic = [super automaticallyNotifiesObserversForKey:theKey];
    }
    return automatic;
}

- (void) finalize
{
    [self save];
    [super finalize];
}



- (void) save
{
    NSLog(@"saving defaults");
    [[[NSUserDefaultsController sharedUserDefaultsController] defaults] synchronize];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (id) targetForDisplayTag:(NSString *)tag
{
    return [displayTags objectForKey:tag];
}
- (void) setTarget:(id)target forDisplayTag:(NSString *)tag
{
    [displayTags setObject:target forKey:tag];
}




// when the keycombo comes from code only
- (void) setTarget:(id)target forHotKeyNamed:(NSString *)name withKeyCode:(int)keyCode andModifiers:(int)modifiers
{
    //NSLog(@"setTarget:%@", target);
    // create a 'blank' dictionary
    NSMutableDictionary *keyDictionary = [self initializeHotKeyNamed:name withTarget:target];
    PTKeyCombo *keyCombo;
    
    // get values for each key
    NSDictionary *keyPrefs = [[NSUserDefaults standardUserDefaults] dictionaryForKey:name];
    // only if there's a dictionary for this key
    if (keyPrefs)
    {
        id pref = [keyPrefs objectForKey:@"keyCombo"];
        if (pref)
        {
            keyCombo = [[PTKeyCombo alloc] initWithPlistRepresentation:pref];
            [[keyDictionary objectForKey:PREFKEY_HOTKEY_HOTKEY] setKeyCombo:keyCombo];
        }
        else
        {
            keyCombo = [[PTKeyCombo alloc] initWithKeyCode:keyCode modifiers:modifiers];
        }
        
        pref = [keyPrefs objectForKey:PREFKEY_HOTKEY_ENABLED];
        if (pref)
        {
            [keyDictionary setValue:pref forKey:PREFKEY_HOTKEY_ENABLED];
        }
    }
    else
    {
        // no preferences located
        keyCombo = [[PTKeyCombo alloc] initWithKeyCode:keyCode modifiers:modifiers];
    }
    
    // write actual values into the dictionary
    [[keyDictionary objectForKey:PREFKEY_HOTKEY_HOTKEY] setKeyCombo:keyCombo];
    
    // set the dictionary in the appropriate places
    [hotKeys setObject:keyDictionary forKey:name];
    if (!hotKeysArray)
    {
        hotKeysArray = [[NSMutableArray alloc] init];
    }
    [self willChangeValueForKey:@"hotKeys"];
    [hotKeysArray addObject:keyDictionary];
    [self didChangeValueForKey:@"hotKeys"];
}
- (id) targetForHotKeyNamed:(NSString *)name
{
    id rval = nil;
    NSMutableDictionary *keyDictionary = [hotKeys objectForKey:name];
    if (keyDictionary)
    {
        [[keyDictionary objectForKey:PREFKEY_HOTKEY_HOTKEY] target];
    }
    return rval;
}
- (NSArray *) hotKeys
{
    //NSLog(@"hotKeys: %@", hotKeys);
    return hotKeysArray;
}


- (id) preferenceForKey:(NSString *)key
{
    return [self preferenceForKey:key forBundle:[[NSBundle mainBundle] bundleIdentifier]];
}
- (id) preferenceForKey:(NSString *)key forBundle:(NSString *)bundleIdentifier
{
    id rval = nil;
    NSMutableDictionary *bundleDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:[self sanitizeBundleIdentifier:bundleIdentifier]];

    if (bundleDictionary)
    {
        rval = [bundleDictionary objectForKey:key];
    }
    //NSLog(@"Returning %@ for key", rval, key);
    return rval;
}


- (void) setPreferences:(NSDictionary *)dict forBundle:(NSString *)bundleIdentifier;
{
    NSString *sanitizedBundleIdentifier = [self sanitizeBundleIdentifier:bundleIdentifier];
    NSMutableDictionary *bundleDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:sanitizedBundleIdentifier];
    if (!bundleDictionary)
    {
        // set the prefs to the dictionary passed to us
        bundleDictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    else
    {
        // merge the existing prefs with the dictionary passed to us, being sure to save user-defined prefs over default prefs
        NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:dict];
        [d addEntriesFromDictionary:bundleDictionary];
        bundleDictionary = d;
    }
    //NSLog(@"setPreferences:%@ forBundle:%@", bundleDictionary, bundleIdentifier);
    [[NSUserDefaults standardUserDefaults] setObject:bundleDictionary forKey:sanitizedBundleIdentifier];
}

- (void) setPreference:(id)value forKey:(NSString *)key forBundle:(NSString *)bundleIdentifier
{
    NSString *sanitizedBundleIdentifier = [self sanitizeBundleIdentifier:bundleIdentifier];
    NSMutableDictionary *bundleDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:sanitizedBundleIdentifier];
    if (!bundleDictionary)
    {
        bundleDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    [bundleDictionary setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:bundleDictionary forKey:sanitizedBundleIdentifier];
}

- (NSString *) sanitizeBundleIdentifier:(NSString *)bundleIdentifier
{
    // filter periods
    AGRegex *regex = [AGRegex regexWithPattern:@"\\."];
    NSString *sanitized = [regex replaceWithString:@"" inString:bundleIdentifier];
    return sanitized;
}
@end





@implementation PreferencesController (Private)
// 1. create a key and put it on the dictionary when a plugin creates a key
// 2. set up KVO on the key
// 3. load up the prefs and set them
- (NSMutableDictionary *) initializeHotKeyNamed:(NSString *)name withTarget:(id)target
{
    // Set up a blank hotkey. We'll initialize it later
    PTHotKey *hk = [[PTHotKey alloc] init];
    [hk setName:name];
    [hk setKeyCombo:[PTKeyCombo clearKeyCombo]];
    [hk setTarget:target];
    SEL action = [self hotKeySelectorForName:name];
    [hk setAction:action];
    NSMutableDictionary *opts = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 name,                                                   PREFKEY_HOTKEY_NAME,
                                 [NSNumber numberWithBool:YES],                          PREFKEY_HOTKEY_ENABLED,
                                 hk,                                                     PREFKEY_HOTKEY_HOTKEY,
                                 [[PTKeyCombo clearKeyCombo] description],               PREFKEY_HOTKEY_STRINGREP,
                                 nil];
    // Register for changes to these keys. This is how we know when the user is changing stuff.
    [opts addObserver:self forKeyPath:PREFKEY_HOTKEY_ENABLED options:NSKeyValueObservingOptionNew context:NULL];
    [opts addObserver:self forKeyPath:PREFKEY_HOTKEY_KEYCOMBO_KEYPATH options:NSKeyValueObservingOptionNew context:NULL];
    [hk release];
    
    return opts;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //NSLog(@"(%@) keyPath: %@ -- new value: %@", [object objectForKey:PREFKEY_HOTKEY_NAME], keyPath, [change objectForKey:NSKeyValueChangeNewKey]);
    if ([keyPath isEqualToString:PREFKEY_HOTKEY_ENABLED])
    {
        // write this back to defaults
        [self writeHotKeyPref:[change objectForKey:NSKeyValueChangeNewKey] name:PREFKEY_HOTKEY_ENABLED forKeyNamed:[object objectForKey:PREFKEY_HOTKEY_NAME]];
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
//    else if ([keyPath isEqualToString:PREFKEY_HOTKEY_SHOWINFOAFTER])
//    {
//        // write this back to defaults
//        [self _writeHotKeyPref:[change objectForKey:NSKeyValueChangeNewKey] name:PREFKEY_HOTKEY_SHOWINFOAFTER forKeyNamed:[object objectForKey:PREFKEY_HOTKEY_NAME]];
//        // do we need to do anything else here?
//    }
    else if ([keyPath isEqualToString:PREFKEY_HOTKEY_KEYCOMBO_KEYPATH])
    {
        //NSLog(@"Updating PREFKEY_HOTKEY_KEYCOMBO_KEYPATH");
        // Update the string rep of this key
        [object setObject:[[[object objectForKey:PREFKEY_HOTKEY_HOTKEY] keyCombo] description] forKey:PREFKEY_HOTKEY_STRINGREP];
        //NSLog(@"PREFKEY_HOTKEY_STRINGREP: %@", [object objectForKey:PREFKEY_HOTKEY_STRINGREP]);
        // Write the new key back to defaults
        [self writeHotKeyPref:[[[object objectForKey:PREFKEY_HOTKEY_HOTKEY] keyCombo] plistRepresentation] name:@"keyCombo" forKeyNamed:[object objectForKey:PREFKEY_HOTKEY_NAME]];
        // The key combo changed. Register the new key.
        if ([[object objectForKey:PREFKEY_HOTKEY_ENABLED] boolValue])
        {
            // register the key only if it's enabled
            [[PTHotKeyCenter sharedCenter] registerHotKey:[object objectForKey:PREFKEY_HOTKEY_HOTKEY]];
        }
    }
//    else if ([keyPath isEqualToString:PREFKEY_INFO_SHOW_ON])
//    {
//        switch ([[change objectForKey:NSKeyValueChangeNewKey] intValue])
//        {
//                // song change
//            case 1:
//                // tell the application that we want notifications
//                [[AppController sharedController] beginListeningTo:APPKEY_LISTENER_ITUNES];
//                switch ([[change objectForKey:NSKeyValueChangeOldKey] intValue])
//            {
//                case 0:
//                    // close the window
//                    [[AppController sharedController] displayInfoWindow];
//                    break;
//                default:
//                    break;
//            }
//                break;
//                
//                // always
//            case 0:
//                // tell the application that we don't want any more notifications
//                [[AppController sharedController] beginListeningTo:APPKEY_LISTENER_ITUNES];
//                switch ([[change objectForKey:NSKeyValueChangeOldKey] intValue])
//            {
//                case 1:
//                case 2:
//                    // open the window
//                    [[AppController sharedController] displayInfoWindow];
//                    break;
//                default:
//                    break;
//            }
//                break;
//                
//                // hot key only
//            case 2:
//                // tell the application that we don't want any more notifications
//                [[AppController sharedController] stopListeningTo:APPKEY_LISTENER_ITUNES];
//                switch ([[change objectForKey:NSKeyValueChangeOldKey] intValue])
//            {
//                case 0:
//                    // close the window
//                    [[AppController sharedController] displayInfoWindow];
//                    break;
//                default:
//                    break;
//            }
//                break;
//                
//            default:
//                break;
//        }
//    }
}


- (void) writeHotKeyPref:(id)pref name:(NSString *)key forKeyNamed:(NSString *)name
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

- (SEL) hotKeySelectorForName:(NSString *)name
{
    // filter spaces, question marks, etc.
    AGRegex *regex = [AGRegex regexWithPattern:@"[^a-zA-Z0-9]"];
    NSString *camelCase = [regex replaceWithString:@"" inString:name];
    unichar first = [camelCase characterAtIndex:0];
    // lowercase the letter... use the wide version of tolower()
    first = towlower(first);
    camelCase = [NSString stringWithFormat:@"%C%@", first, [camelCase substringFromIndex:1]];
    return NSSelectorFromString([NSString stringWithFormat:@"%@HotKey", camelCase]);   
}

@end

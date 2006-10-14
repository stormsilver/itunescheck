//
//  PluginsController.m
//  iTunesCheck
//
//  Created by StormSilver on Fri Aug 06 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import "PluginsController.h"
#import "PTHotKeyCenter.h"
#import "PTHotKey.h"
#import "PTKeyComboPanel.h"
#import "PTKeyCombo.h"
#import "DisplaySetupPanel.h"
#import "InfoController.h"


@implementation PluginsController

- (id) init
{
    static id sharedController;
    
    if (!sharedController)
    {
        self = [super init];
    
        if (self)
        {
            hotKeyPlugins = nil;
            
            [self loadPlugins:nil];
        }
        
        sharedController = self;
    }
    
    return sharedController;
}

- (void) dealloc
{
    [hotKeyPlugins release];
    [thirdPartyPlugins release];
    
    [super dealloc];
}

- (IBAction) loadPlugins:(id)sender
{
    if (hotKeyPlugins != nil)
    {
        [hotKeyPlugins release];
    }
    [[PTHotKeyCenter sharedCenter] unregisterAllHotKeys];
    hotKeyPlugins = [[NSMutableDictionary alloc] init];

    //Load up the built in plugins
    [self parsePlugins:[[[NSBundle mainBundle] builtInPlugInsPath] stringByAppendingPathComponent:@"HotKey"]];
    
    //load up the third party plugins
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0)
    {
        thirdPartyPlugins = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"Application Support/iTunesCheck/PlugIns/HotKey"] retain];
        [self parsePlugins:thirdPartyPlugins];
    }
    
    [objectController setContent:nil];
    [objectController setContent:self];
}

- (void) parsePlugins:(NSString *)directory
{
    NSEnumerator *enumerator = [[[NSFileManager defaultManager] directoryContentsAtPath:directory] objectEnumerator];
    if (!enumerator)
    {
        return;
    }
    
    id thing;
    while (thing = [enumerator nextObject])
    {
        if (![thing isEqual:@".DS_Store"])
        {
            NSString *error;
            NSPropertyListFormat format;
            NSString *path = [[directory stringByAppendingPathComponent:thing] stringByAppendingPathComponent:@"Info.plist"];
            NSData *plistData = [NSData dataWithContentsOfFile:path];
            id plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
            
            if (!plist)
            {
                NSLog(@"Error opening Info.plist (%@) for plugin: %@", path, error);
                [error release];
            } else
            {
                NSNumber *key;
                NSNumber *modifiers;
                NSUserDefaults *usd = [NSUserDefaults standardUserDefaults];
                //An array with all the keys that are supposed to exist in the plugin's plist
                NSArray *keys = [NSArray arrayWithObjects:
                    @"name",
                    @"actionPath",
                    @"key",
                    @"modifiers",
                    @"enabled",
                    @"stringRep",
                    @"kind",
                    nil];
                //The name of the plugin
                NSString *name = [plist objectForKey:@"Name"];
                
                //Check to make sure we haven't already loaded this plugin
                if ([hotKeyPlugins objectForKey:name])
                {
                    NSLog(@"Error: Two or more plugins with the same name (%@). Check your plugins directory for conflicting plugins.", name);
                    continue;
                }
                
                //Whether or not to enable the plugin
                BOOL ena;
                if ([usd objectForKey:[name stringByAppendingString:@"Enabled"]])
                {
                    ena = [usd boolForKey:[NSString stringWithFormat:@"%@Enabled", name]];
                } else
                {
                    ena = [[plist objectForKey:@"Enabled"] boolValue];
                }
                
                //If we have some user defaults for what hotkey to use, we'll load those up.
                //Otherwise we'll fall back on what's in the plugin's plist
                if ([usd objectForKey:[name stringByAppendingString:@"Key"]] && [usd objectForKey:[name stringByAppendingString:@"Modifiers"]])
                {
                    key = [usd objectForKey:[name stringByAppendingString:@"Key"]];
                    modifiers = [usd objectForKey:[name stringByAppendingString:@"Modifiers"]];
                } else
                {
                    key = [plist objectForKey:@"Key"];
                    modifiers = [plist objectForKey:@"Modifiers"];
                }
                
                //Put all of the plugin info into one array
                NSArray *objects = [NSArray arrayWithObjects:
                    name, 
                    [plist objectForKey:@"ActionPath"], 
                    key, 
                    modifiers, 
                    [NSNumber numberWithBool:ena],
                    [[PTKeyCombo keyComboWithKeyCode:[key intValue] modifiers:[modifiers intValue]] description],
                    [plist objectForKey:@"Kind"],
                    nil];
                
                //Make sure all the data exists. If the keys and objects aren't equal, then something was missing from the plist
                //And if that's the case, then we can't guarantee that the plugin will work, so let's just not even register it
                if ([keys count] == [objects count])
                {
                    NSMutableDictionary *plug = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
                    
                    //Alright, we'll load up optional data now, the plugin should have enough basic info to function at this point
                    if ([usd objectForKey:[name stringByAppendingString:@"ShowInfo"]])
                    {
                        [plug setObject:[usd objectForKey:[name stringByAppendingString:@"ShowInfo"]] forKey:@"showInfo"];
                    } else
                    {
                        if ([plist objectForKey:@"Show Info"])
                        {
                            [plug setObject:[plist objectForKey:@"Show Info"] forKey:@"showInfo"];
                        }
                    }
                    
                    if ([plist objectForKey:@"Option 1 Title"] && [plist objectForKey:@"Option 1 ActionPath"])
                    {
                        [plug setObject:[plist objectForKey:@"Option 1 Title"] forKey:@"option1Title"];
                        [plug setObject:[plist objectForKey:@"Option 1 ActionPath"] forKey:@"option1ActionPath"];
                        
                        if ([usd objectForKey:[name stringByAppendingString:@"Option1Enabled"]])
                        {
                            [plug setObject:[usd objectForKey:[name stringByAppendingString:@"Option1Enabled"]] forKey:@"option1Enabled"];
                        } else
                        {
                            if ([plist objectForKey:@"Option 1 Enabled"])
                            {
                                [plug setObject:[plist objectForKey:@"Option 1 Enabled"] forKey:@"option1Enabled"];
                            }
                        }
                    }
                    
                    //Finally, we'll check for plugins that aren't really plugins, just overrides from within the program so that everything
                    //uses the same hotkey system
                    if ([plist objectForKey:@"OverrideAction"])
                    {
                        [plug setObject:[plist objectForKey:@"OverrideAction"] forKey:@"overrideAction"];
                    }
                    
                    //Register the plugin
                    [hotKeyPlugins setObject:plug forKey:name];
                    
                    //Turn on this hotkey if it's supposed to be
                    if (ena)
                    {
                        [self regHotKey:name];
                    }
                } else
                {
                    NSLog(@"Error: %@ is not a valid plugin. Some Info.plist data missing.\nKeys: %@\nObjects: %@", name, keys, objects);
                }
            }
        }
    }
}

- (NSArray *) hotKeyPlugins
{
    NSSortDescriptor *nameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
    return [[hotKeyPlugins allValues] sortedArrayUsingDescriptors:sortDescriptors];
}

- (void) setHotKeyPlugins: (NSDictionary *)plugins
{
    if (plugins != hotKeyPlugins)
    {
        [hotKeyPlugins release];
        hotKeyPlugins = [[NSMutableDictionary alloc] initWithDictionary:plugins];
    }
}


- (IBAction) setHotKey:(id)sender
{
    NSString *name;
    PTHotKey *hk;
    
    if ([hotKeyPlugins objectForKey:sender])
    {
        name = sender;
    } else
    {
        name = [currentSelection stringValue];
    }
    if (!(hk = [[PTHotKeyCenter sharedCenter] hotKeyForName:name]))
    {
        hk = [[PTHotKey alloc] init];
        int key = [[[hotKeyPlugins objectForKey:name] objectForKey:@"key"] intValue];
        int modifiers = [[[hotKeyPlugins objectForKey:name] objectForKey:@"modifiers"] intValue];
        [hk setKeyCombo:[PTKeyCombo keyComboWithKeyCode:key modifiers:modifiers]];
        [hk setTarget:self];
        [hk setAction:@selector(hotKeyDown:)];
        [hk setName:name];
    }
    [NSApp beginSheet:[[PTKeyComboPanel sharedPanel] window] modalForWindow:[currentSelection window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
    [[PTKeyComboPanel sharedPanel] runModalForHotKey:hk];
    [NSApp endSheet:[[PTKeyComboPanel sharedPanel] window]];
    
    //save the new key to user defaults
    PTKeyCombo *combo = [[PTKeyComboPanel sharedPanel] keyCombo];
    NSUserDefaults *usd = [NSUserDefaults standardUserDefaults];
    NSNumber *key = [NSNumber numberWithInt:[combo keyCode]];
    NSNumber *modifiers = [NSNumber numberWithInt:[combo modifiers]];
    [usd setObject:key forKey:[name stringByAppendingString:@"Key"]];
    [usd setObject:modifiers forKey:[name stringByAppendingString:@"Modifiers"]];
    
    //update the dictionary
    [[hotKeyPlugins objectForKey:name] setObject:[combo description] forKey:@"stringRep"];
    [[hotKeyPlugins objectForKey:name] setObject:key forKey:@"key"];
    [[hotKeyPlugins objectForKey:name] setObject:modifiers forKey:@"modifiers"];
    
    [hk release];
}

- (IBAction) enableHotKey:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:[[currentSelection stringValue] stringByAppendingString:@"Enabled"]];
    
    if ([sender state] == NSOnState)
    {
        [self regHotKey:[currentSelection stringValue]];
    } else
    {
        [[PTHotKeyCenter sharedCenter] unregisterHotKeyForName:[currentSelection stringValue]];
    }
}
- (IBAction) enableShowInfo:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:[[currentSelection stringValue] stringByAppendingString:@"ShowInfo"]];
}
- (IBAction) enableOption1:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:[[currentSelection stringValue] stringByAppendingString:@"Option1Enabled"]];
}

- (void) regHotKey:(NSString *)name
{
    PTHotKey *hk = [[PTHotKey alloc] init];
    int key = [[[hotKeyPlugins objectForKey:name] objectForKey:@"key"] intValue];
    int modifiers = [[[hotKeyPlugins objectForKey:name] objectForKey:@"modifiers"] intValue];
    [hk setKeyCombo:[PTKeyCombo keyComboWithKeyCode:key modifiers:modifiers]];
    [hk setTarget:self];
    [hk setAction:@selector(hotKeyDown:)];
    [hk setName:name];
    
    if (![[PTHotKeyCenter sharedCenter] registerHotKey:hk] && [[currentSelection window] isVisible])
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"Alright"];
        [alert addButtonWithTitle:@"Nevermind"];
        [alert setMessageText:@"Already registered."];
        [alert setInformativeText:@"This key combination is already registered to a different hot key. Please set a different one."];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert beginSheetModalForWindow:[currentSelection window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:name];
    }
    
    [hk release];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
    if (returnCode == NSAlertFirstButtonReturn)
    {
        [[alert window] orderOut:self];
        [self setHotKey:contextInfo];
    } else
    {
        [[hotKeyPlugins objectForKey:contextInfo] setObject:[NSNumber numberWithBool:NO] forKey:@"enabled"];
    }
    
    [alert release];
}


- (IBAction) hotKeyDown:(id)sender
{
    NSMutableDictionary *plugin = [hotKeyPlugins objectForKey:[sender name]];
    
    if ([plugin objectForKey:@"overrideAction"])
    {
        [[NSApp delegate] performSelector:sel_registerName([[plugin objectForKey:@"overrideAction"] cString]) withObject:self];
        return;
    }
    
    NSString *action;
    NSString *path;
    if ([plugin objectForKey:@"option1Enabled"])
    {
        action = [plugin objectForKey:@"option1ActionPath"];
    } else
    {
        action = [plugin objectForKey:@"actionPath"];
    }
    
    if ([[plugin objectForKey:@"kind"] isEqual:@"Built-In"])
    {
        path = [[[[NSBundle mainBundle] builtInPlugInsPath] stringByAppendingPathComponent:@"HotKey"] stringByAppendingPathComponent:action];
    } else
    {
        //NSLog(thirdPartyPlugins);
        path = [thirdPartyPlugins stringByAppendingPathComponent:action];
    }

    if (![[NSFileManager defaultManager] isReadableFileAtPath:path])
    {
        NSLog(@"Error - file  does not exist or is a directory: %@", path);
    } else
    {
		NSDictionary *errorDict = [[NSDictionary alloc] init];
        NSAppleScript *theScript = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&errorDict];

		if (![theScript executeAndReturnError:&errorDict])
        {
            NSLog(@"%@ returned AppleScript error: %@", path, errorDict);
        } else
        {
            if ([[plugin objectForKey:@"showInfo"] boolValue])
            {
                [[InfoController sharedController] display];
            }
        }
        [errorDict release];

        [theScript release];
    }
}


@end

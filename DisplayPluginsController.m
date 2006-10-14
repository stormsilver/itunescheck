//
//  DisplayPluginsController.m
//  iTunesCheck
//
//  Created by StormSilver on 8/29/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//

#import "DisplayPluginsController.h"


@implementation DisplayPluginsController

- (id) init
{
    static id sharedController;
    
    if (!sharedController)
    {
        self = [super init];
        
        if (self)
        {
            displayPlugins = nil;
            
            [self loadPlugins:nil];
        }
        
        sharedController = self;
    }
    
    return sharedController;
}

- (void) dealloc
{
    [displayPlugins release];
    [thirdPartyPlugins release];
    
    [super dealloc];
}

- (void) awakeFromNib
{
    [displayTable setTarget:self];
    [displayTable setDoubleAction:@selector(tableViewDoubleClicked:)];
}

- (IBAction) loadPlugins:(id)sender
{
    if (displayPlugins != nil)
    {
        [displayPlugins release];
    }
    displayPlugins = [[NSMutableDictionary alloc] init];
    
    //Load up the builtin plugins
    [self parsePlugins:[[[NSBundle mainBundle] builtInPlugInsPath] stringByAppendingPathComponent:@"Display"]];
    
    //Load up the third party plugins
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0)
    {
        thirdPartyPlugins = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"Application Support/iTunesCheck/PlugIns/Display"] retain];
        [self parsePlugins:thirdPartyPlugins];
    }
    
    [objectController setContent:nil];
    [objectController setContent:self];
}

- (void) parsePlugins:(NSString *)directory;
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
                NSLog(@"Error opening Info.plist (%@) for display plugin: %@", path, error);
                [error release];
            } else
            {
                //An array with all the keys that are supposed to exist in the plugin's plist
                NSArray *keys = [NSArray arrayWithObjects:
                    @"name",
                    @"bracketName",
                    @"actionPath",
                    @"kind",
                    nil];
                //The name of the plugin
                NSString *name = [plist objectForKey:@"Name"];
                NSString *bracketName = [NSString stringWithFormat:@"<<%@>>", name];
                
                //Check to make sure we haven't already loaded this plugin
                if ([displayPlugins objectForKey:name])
                {
                    NSLog(@"Error: Two or more display plugins with the same name (%@). Check your display plugins directory for conflicts. (%@)", name, path);
                    continue;
                }
                
                //Put all of the plugin info into one array
                NSArray *objects = [NSArray arrayWithObjects:
                    name,
                    bracketName,
                    [plist objectForKey:@"ActionPath"],
                    [plist objectForKey:@"Kind"],
                    nil];
                
                //Make sure all the data exists. If the keys and objects aren't equal, then something was missing from the plist
                //And if that's the case, then we can't guarantee that the plugin will work, so let's just not even register it
                if ([keys count] == [objects count])
                {
                    NSMutableDictionary *plug = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
                    
                    //Alright, we'll load up optional data now, the plugin should have enough basic info to function at this point
                    
                    
                    
                    //Finally, we'll check for plugins that aren't really plugins, just overrides from within the program so that everything
                    //uses the same hotkey system
                    
                    
                    //Register the plugin
                    [displayPlugins setObject:plug forKey:name];
                } else
                {
                    NSLog(@"Error: %@ is not a valid display plugin. Some Info.plist data missing.\nKeys: %@\nObjects: %@", name, keys, objects);
                }
            }
        }
    }
}

- (NSArray *) displayPlugins
{
    NSSortDescriptor *nameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
    return [[displayPlugins allValues] sortedArrayUsingDescriptors:sortDescriptors];
}
- (void) setDisplayPlugins:(NSDictionary *)plugins
{
    if (plugins != displayPlugins)
    {
        [displayPlugins release];
        displayPlugins = [[NSMutableDictionary alloc] initWithDictionary:plugins];
    }
}

- (IBAction) tableViewDoubleClicked:(id)sender
{
    NSString *name = [[displayPlugins valueForKey:[[[[displayTable tableColumns] objectAtIndex:0] dataCell] objectValue]] valueForKey:@"name"];
    //shift the focus over to the textView so that the user doesn't have to
    [[displaySetupField window] makeFirstResponder:displaySetupField];
    [displaySetupField insertText:[[displayPlugins objectForKey:name] objectForKey:@"bracketName"]];
}

- (NSString *) runPlugin:(NSString *)name
{
    NSString *rval = nil;
    NSMutableDictionary *plugin = [displayPlugins objectForKey:name];
    
    NSString *action = [plugin objectForKey:@"actionPath"];
    NSString *path;
    if ([[plugin objectForKey:@"kind"] isEqual:@"Built-In"])
    {
        path = [[[[NSBundle mainBundle] builtInPlugInsPath] stringByAppendingPathComponent:@"Display"] stringByAppendingPathComponent:action];
    } else
    {
        path = [thirdPartyPlugins stringByAppendingPathComponent:action];
    }
    
    if (![[NSFileManager defaultManager] isReadableFileAtPath:path])
    {
        NSLog(@"Error - file does not exist or is a directory: %@", path);
    } else
    {
        NSAppleScript *script = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        //NSDictionary *errorDict = [NSDictionary dictionary];
		NSDictionary *errorDict = [[NSDictionary alloc] init];
		NSAppleEventDescriptor *desc = [script executeAndReturnError:&errorDict];

        if (!desc)
        {
            NSLog(@"%@ returned AppleScript error: %@", path, errorDict);
        } else
        {
            rval = [desc stringValue];
            
            //If the current replacement is the song rating, we need to do some additional stuff to change the number returned by iTunes into 0-5 stars
            if ([name isEqualToString:@"Rating"])
            {
                switch ([rval intValue])
                {
                    case 20:
                        rval = [NSString stringWithFormat:@"%C",0x2605];
                        break;
                    case 40:
                        rval = [NSString stringWithFormat:@"%C%C",0x2605,0x2605];
                        break;
                    case 60:
                        rval = [NSString stringWithFormat:@"%C%C%C",0x2605,0x2605,0x2605];
                        break;
                    case 80:
                        rval = [NSString stringWithFormat:@"%C%C%C%C",0x2605,0x2605,0x2605,0x2605];
                        break;
                    case 100:
                        rval = [NSString stringWithFormat:@"%C%C%C%C%C",0x2605,0x2605,0x2605,0x2605,0x2605];
                        break;
                    default:
                        rval = @"";
                }
            }
        }
		[errorDict release];
		[script release];    
    }
    
    if (!rval)
    {
        rval = @"";
    }

    return rval;
}

- (NSMutableAttributedString *) retrieveInfo
{
    //Pull in the track info string from preferences.
    //What we're going to do here is walk through the string and replace things in it with information from iTunes. This allows the user to customize
    //what shows up in the info window
    NSMutableAttributedString* info = [[[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"displayString"]] mutableCopy] autorelease];
    NSRange range;
    NSMutableDictionary *currPlugin;
    NSEnumerator *dataEnumerator = [displayPlugins objectEnumerator];

    
    while (currPlugin = [dataEnumerator nextObject])
    {
        range = [[info string] rangeOfString:[currPlugin objectForKey:@"bracketName"]  options:NSCaseInsensitiveSearch];
       
        //Check to make sure this display option was found - no sense going through all the work of getting the information if it's not going to be used
        if (!NSEqualRanges(range, NSMakeRange(NSNotFound, 0)))
        {
            NSString *rval = [self runPlugin:[currPlugin objectForKey:@"name"]];
            
            //If nothing was returned by the AppleScript and this marker is on a line by itself, then we'll junk that line, since there's nothing on it
            if ([rval isEqualToString:@""])
            {
                if ([[info string] characterAtIndex:(range.location-1)] == '\n')
                {
                    --range.location;
                    ++range.length;
                } 
            }
            //Replace the marker in the preferences string with real information
            [info replaceCharactersInRange:range withString:rval];
        }
    }
    
    return info;
}

@end

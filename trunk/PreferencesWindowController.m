//
//  PreferencesWindowController.m
//  iTunesCheck
//
//  Created by Eric Hankins on 12/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
//
// Includes SS_PrefsController code by Matt Gemmell -> http://mattgemmell.com

#import "PreferencesWindowController.h"
#import "PreferencesController.h"
#import "BundleController.h"
#import "GeneralPreferencesController.h"
#import "HotKeyPreferencesController.h"
#import <iTCBundle/SS_PreferencePaneProtocol.h>
#import "ShortcutRecorderCell.h"
#import "ShortcutRecorderTextView.h"


@interface PreferencesWindowController (Private)
    - (void) addPanesFromClass:(Class)paneClass;
@end


@implementation PreferencesWindowController

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        preferencesController = [PreferencesController sharedController];
        bundleController = [BundleController sharedController];
        
        if (![NSBundle loadNibNamed:@"PreferencesWindow" owner:self])
        {
            NSLog(@"Could not load PreferencesWindow nib!");
        }
        
        [preferencesController setTarget:self forHotKeyNamed:@"Show Preferences Window" withKeyCode:35 andModifiers:2304];
    }
    return self;
}

- (void) awakeFromNib
{
    preferencePanes = [[NSMutableDictionary alloc] init];
    panesOrder = [[NSMutableArray alloc] init];
    
    //show transparency in the color panel
    [[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
    
    [[self window] setLevel:NSFloatingWindowLevel];
    
    // load default prefpanes
    [self addPanesFromClass:[GeneralPreferencesController class]];
    [self addPanesFromClass:[HotKeyPreferencesController class]];
    
    // load preference panes
    NSArray *panes = [bundleController preferencePanes];
    //NSLog(@"Loading preference panes: %@", panes);
    NSEnumerator *paneBundles = [panes objectEnumerator];
    NSBundle *paneBundle;
    while (paneBundle = [paneBundles nextObject])
    {
        NSDictionary* paneDict = [paneBundle infoDictionary];
        NSString* paneName = [paneDict objectForKey:@"NSPrincipalClass"];
        if (paneName)
        {
            Class paneClass = NSClassFromString(paneName);
            if (!paneClass)
            {
                paneClass = [paneBundle principalClass];
                if ([paneClass conformsToProtocol:@protocol(SS_PreferencePaneProtocol)] && [paneClass isKindOfClass:[NSObject class]])
                {
                    [self addPanesFromClass:paneClass];
                }
                else
                {
                    NSLog([NSString stringWithFormat:@"Did not load bundle: %@ because its Principal Class is either not an NSObject subclass, or does not conform to the PreferencePane Protocol.", paneBundle]);
                }
            }
            else
            {
                NSLog([NSString stringWithFormat:@"Did not load bundle: %@ because its Principal Class was already used in another Preference pane.", paneBundle]);
            }
        }
        else
        {
            NSLog([NSString stringWithFormat:@"Could not obtain name of Principal Class for bundle: %@", paneBundle]);
        }
    }
    
    prefsToolbarItems = [[NSMutableDictionary alloc] init];
    NSEnumerator *itemEnumerator = [panesOrder objectEnumerator];
    NSString *name;
    NSImage *itemImage;
    
    while (name = [itemEnumerator nextObject])
    {
        if ([preferencePanes objectForKey:name] != nil)
        {
            NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:name];
            [item setPaletteLabel:name]; // item's label in the "Customize Toolbar" sheet (not relevant here, but we set it anyway)
            [item setLabel:name]; // item's label in the toolbar
            NSString *tempTip = [[preferencePanes objectForKey:name] paneToolTip];
            if (!tempTip || [tempTip isEqualToString:@""])
            {
                [item setToolTip:nil];
            }
            else
            {
                [item setToolTip:tempTip];
            }
            itemImage = [[preferencePanes objectForKey:name] paneIcon];
            [item setImage:itemImage];
            
            [item setTarget:self];
            [item setAction:@selector(prefsToolbarItemClicked:)]; // action called when item is clicked
            [prefsToolbarItems setObject:item forKey:name]; // add to items
            [item release];
        }
        else
        {
            NSLog([NSString stringWithFormat:@"Could not create toolbar item for preference pane \"%@\", because that pane does not exist.", name]);
        }
    }
    
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    prefsToolbar = [[NSToolbar alloc] initWithIdentifier:[bundleIdentifier stringByAppendingString:@"_Preferences_Toolbar_Identifier"]];
    [prefsToolbar setDelegate:self];
    [prefsToolbar setAllowsUserCustomization:NO];
    [prefsToolbar setAutosavesConfiguration:NO];
    [[self window] setToolbar:prefsToolbar];
    
    //NSLog(@"Done awaking. panesOrder: %@, preferencePanes: %@", panesOrder, preferencePanes);
}

- (void) windowShouldClose:(NSNotification *)note
{
    [preferencesController save];
}

float ToolbarHeightForWindow(NSWindow *window)
{
    NSToolbar *toolbar;
    float toolbarHeight = 0.0;
    NSRect windowFrame;
    
    toolbar = [window toolbar];
    
    if (toolbar && [toolbar isVisible])
    {
        windowFrame = [NSWindow contentRectForFrameRect:[window frame] styleMask:[window styleMask]];
        toolbarHeight = NSHeight(windowFrame) - NSHeight([[window contentView] frame]);
    }
    
    return toolbarHeight;
}

- (BOOL) loadPrefsPaneNamed:(NSString *)name display:(BOOL)disp
{
    id tempPane = nil;
    tempPane = [preferencePanes objectForKey:name];
    if (!tempPane)
    {
        NSLog([NSString stringWithFormat:@"Could not load preference pane \"%@\", because that pane does not exist.", name]);
        return NO;
    }
    
    NSView *prefsView = nil;
    prefsView = [tempPane paneView];
    if (!prefsView)
    {
        NSLog([NSString stringWithFormat:@"Could not load \"%@\" preference pane because its view could not be loaded from the bundle.", name]);
        return NO;
    }
    
    // Get rid of old view before resizing, for display purposes.
    if (disp)
    {
        NSView *tempView = [[NSView alloc] initWithFrame:[[[self window] contentView] frame]];
        [[self window] setContentView:tempView];
        [tempView release]; 
    }
    
    // Preserve upper left point of window during resize.
    NSRect newFrame = [[self window] frame];
    newFrame.size.height = [prefsView frame].size.height + ([[self window] frame].size.height - [[[self window] contentView] frame].size.height);
    newFrame.size.width = [prefsView frame].size.width;
    newFrame.origin.y += ([[[self window] contentView] frame].size.height - [prefsView frame].size.height);
    
    id <SS_PreferencePaneProtocol> pane = [preferencePanes objectForKey:name];
    [[self window] setShowsResizeIndicator:([pane allowsHorizontalResizing] || [pane allowsHorizontalResizing])];
    
    [[self window] setFrame:newFrame display:disp animate:disp];
    
    [[self window] setContentView:prefsView];
    
    // Set appropriate resizing on window.
    NSSize theSize = [[self window] frame].size;
    theSize.height -= ToolbarHeightForWindow([self window]);
    [[self window] setMinSize:theSize];
    
    BOOL canResize = NO;
    if ([pane allowsHorizontalResizing])
    {
        theSize.width = FLT_MAX;
        canResize = YES;
    }
    if ([pane allowsVerticalResizing])
    {
        theSize.height = FLT_MAX;
        canResize = YES;
    }
    [[self window] setMaxSize:theSize];
    [[self window] setShowsResizeIndicator:canResize];
    
//    if ((prefsToolbarItems && ([prefsToolbarItems count] > 1)) || alwaysShowsToolbar) {
        [[self window] setTitle:name];
//    }
    
//    // Update defaults
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:name forKey:Last_Pane_Defaults_Key];
    
    [prefsToolbar setSelectedItemIdentifier:name];
    
    return YES;
}

- (IBAction) prefsToolbarItemClicked:(NSToolbarItem*)item
{
    if (![[item itemIdentifier] isEqualToString:[[self window] title]])
    {
        [self loadPrefsPaneNamed:[item itemIdentifier] display:YES];
    }
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar
{
    return panesOrder;
}


- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar
{
    return panesOrder;
}


- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar
{
    return panesOrder;
}


- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    return [prefsToolbarItems objectForKey:itemIdentifier];
}

- (id)windowWillReturnFieldEditor:(NSWindow *)window toObject:(id)anObject
{
    if ([anObject isKindOfClass:[NSTableView class]])
    {
        NSTableColumn *column = [anObject tableColumnWithIdentifier:@"ShortcutTableColumn"];
        if (column && [[column dataCell] isKindOfClass:[ShortcutRecorderCell class]])
        {
            if (!shortcutRecorderTextView)
            {
                shortcutRecorderTextView = [[ShortcutRecorderTextView alloc] init];
            }
            return shortcutRecorderTextView;
        }
    }
    return nil;
}



- (void) showPreferencesWindowHotKey
{
    if ([[self window] isKeyWindow])
    {
        [[self window] performClose:nil];
    }
    else
    {
        BOOL done = NO;
        NSEnumerator* panes = [panesOrder objectEnumerator];
        NSString *pane;
        while (!done)
        {
            pane = [panes nextObject];
            if (!pane)
            {
                done = YES;
            }
            else
            {
                if ([self loadPrefsPaneNamed:pane display:NO])
                {
                    [[self window] center];
                    [NSApp activateIgnoringOtherApps:YES];
                    [[self window] makeKeyAndOrderFront:nil];
                    done = YES;
                }
            }
        }
    }
}

@end






@implementation PreferencesWindowController (Private)
- (void) addPanesFromClass:(Class)paneClass
{
    NSArray *panes = [paneClass preferencePanes];
    NSEnumerator *enumerator = [panes objectEnumerator];
    id <SS_PreferencePaneProtocol> aPane;
    
    while (aPane = [enumerator nextObject])
    {
        //NSLog(@"aPane: %@", [aPane paneName]);
        [panesOrder addObject:[aPane paneName]];
        //NSLog(@"aPane panesOrder: %@", panesOrder);
        [preferencePanes setObject:aPane forKey:[aPane paneName]];
    }
}
@end
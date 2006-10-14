#import "PrefsController.h"
#import "DisplaySetupPanel.h"
#import "InfoController.h"
#import "AppController.h"


@implementation PrefsController

+ (id) sharedController
{
    static id sharedController;
    
    if (!sharedController)
    {
        sharedController = [[self alloc] init];
    }
    
    return sharedController;
}

- (id) init
{
    static BOOL initing = NO;
    self = [super init];
    
    if (self && !initing)
    {
        initing = YES;
        
        [NSBundle loadNibNamed:@"Preferences" owner:self];
    }
    
    initing = NO;
    
    return self;
}

- (void) awakeFromNib
{
    //show transparency in the color panel
    [[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
    
    //set the delegate of the prefsWindow to us, so that we can receive windowShouldClose messages
    [prefsWindow setDelegate:self];
    
    //select the first tab item
    [[[[prefsWindow contentView] subviews] lastObject] selectFirstTabViewItem:nil];
    
    [prefsWindow center];
    [positioner bind:@"backgroundColor" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.backgroundColor" options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
    //[_roundedView bind:@"backgroundColor" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.backgroundColor" options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
}

#pragma mark -
#pragma mark Other Methods

- (void) display
{
    if ([prefsWindow isKeyWindow])
    {
        [prefsWindow performClose:nil];
    } else {
        [NSApp activateIgnoringOtherApps:YES];
        [prefsWindow makeKeyAndOrderFront:self];
    }
}

- (void) about
{
    [[[[prefsWindow contentView] subviews] lastObject] selectLastTabViewItem:nil];
    [prefsWindow makeKeyAndOrderFront:self];
}
#pragma mark -
#pragma mark IB Methods

- (IBAction) runDisplaySetupPanel:(id)sender
{
    [backgroundColorWell deactivate];
    [NSApp beginSheet:[[DisplaySetupPanel sharedPanel] window] modalForWindow:prefsWindow modalDelegate:nil didEndSelector:nil contextInfo:nil];
    NSAttributedString *stra = (NSAttributedString *)[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"displayString"]];
    [[DisplaySetupPanel sharedPanel] runModalForAttributedString:stra];
    [NSApp endSheet:[[DisplaySetupPanel sharedPanel] window]];
}

- (IBAction) togglePositioner:(id)sender
{
    if ([[positioner window] isVisible])
    {
        [[positioner window] close];
    } else {
        [[positioner window] makeKeyAndOrderFront:self];
    }
}

- (IBAction) visitWebsite:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[sender title]]];
}

- (IBAction) quitProgram:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"confirmQuit"])
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"Quit"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert setMessageText:@"Really Quit?"];
        [alert setInformativeText:@"Are you sure you want to quit iTunesCheck?\nThis dialog can be turned off in the Advanced tab."];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert beginSheetModalForWindow:prefsWindow modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:2];
    } else
    {
        [NSApp terminate:sender];
    }
}


- (IBAction) toggleHeadless:(id)sender
{
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Info.plist"];
    NSString *error;
    NSPropertyListFormat format;
    
    NSData *plistData = [NSData dataWithContentsOfFile:path];
    id plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    
    if (!plist)
    {
        NSLog(@"Error opening Info.plist (%@) for headless mode change: %@", path, error);
        [error release];
    } else
    {
        NSString *element;
        if ([sender state] == NSOnState)
        {
            element = @"1";
        } else
        {
            element = @"0";
        }
        [plist setObject:element forKey:@"LSUIElement"];
        
        plistData = [NSPropertyListSerialization dataFromPropertyList:plist format:format errorDescription:&error];
        
        if (plistData)
        {
            [plistData writeToFile:path atomically:YES];
            [[NSFileManager defaultManager] changeFileAttributes:[NSDictionary dictionaryWithObject:[NSDate date] forKey:NSFileModificationDate] atPath:[[NSBundle mainBundle] bundlePath]];
        } else
        {
            NSLog(@"Error writing Info.plist (%@) for headless mode change: %@. Do you have write permissions?", path, error);
            [error release];
        }
    }
}

- (IBAction) factorySettings:(id)sender
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Reset"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Are you sure?"];
    [alert setInformativeText:@"Continuing will reset all preferences to defaults. You will lose all settings. This action is not undoable!"];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:prefsWindow modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:1];
}

- (IBAction) readme:(id)sender
{
    [[NSWorkspace sharedWorkspace] openFile:[[NSBundle mainBundle] pathForResource:@"ReadMe" ofType:@"rtfd"]];
}

#pragma mark -
#pragma mark Support Methods
- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
    switch ((int)contextInfo)
    {
        case 1:
            if (returnCode == NSAlertFirstButtonReturn)
            {
                [[NSUserDefaultsController sharedUserDefaultsController] revertToInitialValues:nil];
                [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
                [[NSUserDefaults standardUserDefaults] removeVolatileDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
                NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UserDefaults" ofType:@"plist"]];
                [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"InitPrefsDone"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [pluginsController loadPlugins:nil];
            }
            break;
            
        case 2:
            if (returnCode == NSAlertFirstButtonReturn)
            {
                [NSApp terminate:nil];
            }
            break;
    }
    [alert release];
}

#pragma mark -
#pragma mark Delegate methods
- (BOOL)windowShouldClose:(id)sender
{
    if ([[positioner window] isVisible])
    {
        [[positioner window] close];
        [positionerButton setState:NSOffState];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}
@end

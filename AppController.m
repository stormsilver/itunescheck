#import "AppController.h"
#import "InfoController.h"
#import "PrefsController.h"
#import "PrefsWindowController.h"
#import "FindWindowController.h"

@implementation AppController
static id sharedController;
+ (id) sharedController
{
    if (!sharedController)
    {
        [[self alloc] init];
    }
    
    return sharedController;
}
- (id)init
{
    if (!sharedController)
    {
        self = [super init];
        
        if (self)
        {
        }
        
        sharedController = self;
    }
    
    return sharedController;
}
- (void) dealloc
{
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(displayInfoWithNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
    // show the prefs window if the app's never been run before
    if (![[[PrefsController sharedController] prefForKey:PREFKEY_INITIAL_SETUP_DONE] boolValue])
    {
        [self displayPreferencesWindow:nil];
        [[PrefsController sharedController] setPref:[NSNumber numberWithBool:YES] forKey:PREFKEY_INITIAL_SETUP_DONE];
    }
}


- (void) displayInfo
{
    [[InfoController sharedController] displayView:[[PrefsController sharedController] prefForKey:PREFKEY_INFO_VIEW]];
}
- (void) displayInfoWithNotification:(NSNotification *)note
{
    [[InfoController sharedController] displayView:[[PrefsController sharedController] prefForKey:PREFKEY_INFO_VIEW] fromNotification:note];
}
- (void) displayInfoWindow:(id)sender
{
    [self displayInfo];
}


- (void) displayPreferencesWindow:(id)sender
{
    [[PrefsWindowController sharedController] show];
}


- (void) displayQuickplayWindow:(id)sender
{
    [[FindWindowController sharedController] show];
}
@end

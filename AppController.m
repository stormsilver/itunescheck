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
            _infoController = [InfoController sharedController];
            _prefsController = [PrefsController sharedController];
        }
        
        sharedController = self;
    }
    
    return sharedController;
}
- (void) dealloc
{
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
    //[_infoController release];
    //[_prefsController release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(displayInfoWithNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
    //[self displayPrefsWindow:nil];
    //[self displayInfo];
    [self displayQuickplayWindow:nil];
}

- (void) displayInfo
{
    [_infoController displayView:[_prefsController prefForKey:PREFKEY_INFO_VIEW]];
}
- (void) displayInfoWithNotification:(NSNotification *)note
{
    [_infoController displayView:[_prefsController prefForKey:PREFKEY_INFO_VIEW] fromNotification:note];
}



- (void) displayInfoWindow:(id)sender
{
    [self displayInfo];
}

- (void) displayPreferencesWindow:(id)sender
{
    PrefsWindowController *pwc = [PrefsWindowController sharedController];
    [pwc show];
}

- (void) displayQuickplayWindow:(id)sender
{
    FindWindowController *fc = [FindWindowController sharedController];
    [fc show];
}
@end

#import "AppController.h"
#import "Prefdefs.h"
#import "PrefsWindowController.h"

@implementation AppController
- (id)init
{
    if (![super init])
        return nil;
    
    _infoController = [InfoController sharedController];
    _prefsController = [PrefsController sharedController];
    
    return self;
}
- (void) dealloc
{
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
    [_infoController release];
    [_prefsController release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(displayInfoWithNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
    [self displayPrefsWindow:nil];
    //[self displayInfo];
}

- (void) displayInfo
{
    [_infoController displayView:[_prefsController prefForKey:PREFKEY_INFO_VIEW]];
}
- (void) displayInfo:(id)sender
{
    [self displayInfo];
}
- (void) displayInfoWithNotification:(NSNotification *)note
{
    [_infoController displayView:[_prefsController prefForKey:PREFKEY_INFO_VIEW] fromNotification:note];
}

- (void) displayPrefsWindow:(id)sender
{
    PrefsWindowController *pwc = [PrefsWindowController sharedController];
    [pwc show];
}
@end

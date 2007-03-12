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
            // This will cause the prefs controller to initialize itself. It's about the most core object 
            // to the application so we HAVE to have it and if it breaks, the whole app is done dealing.
            [PrefsController sharedController];
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
    // show the prefs window if the app's never been run before
    if (![[[PrefsController sharedController] prefForKey:PREFKEY_INITIAL_SETUP_DONE] boolValue])
    {
        [self displayPreferencesWindow:nil];
        [[PrefsController sharedController] setPref:[NSNumber numberWithBool:YES] forKey:PREFKEY_INITIAL_SETUP_DONE];
    }
    
    // show the info window if the setting is "always"
    if ([[[PrefsController sharedController] prefForKey:PREFKEY_INFO_SHOW_ON] intValue] == 0)
    {
        [self displayInfoWindow];
    }
}


- (void) beginListeningTo:(NSString *)object
{
    if ([object isEqualToString:APPKEY_LISTENER_ITUNES])
    {
        NSLog(@"turning ON itunes listening");
        [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(displayInfoWindowWithNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
    }
}
- (void) stopListeningTo:(NSString *)object
{
    if ([object isEqualToString:APPKEY_LISTENER_ITUNES])
    {
        NSLog(@"turning off itunes listening");
        [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:@"com.apple.iTunes.playerInfo" object:nil];
    }
}


- (void) displayInfoWindow
{
    [[InfoController sharedController] displayView:[[PrefsController sharedController] prefForKey:PREFKEY_INFO_VIEW]];
}
- (void) displayInfoWindowWithNotification:(NSNotification *)note
{
    [[InfoController sharedController] displayView:[[PrefsController sharedController] prefForKey:PREFKEY_INFO_VIEW] fromNotification:note];
}
- (void) displayInfoWindow:(id)sender
{
    [self displayInfoWindow];
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

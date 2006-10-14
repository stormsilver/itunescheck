#import "AppController.h"
#import "PrefsController.h"
#import "FindController.h"
#import "PTHotKeyCenter.h"
#import "PTKeyCombo.h"
#import "PTHotKey.h"
#import "RoundedNumberTransformer.h"
#import "BooleanColorTransformer.h"


@implementation AppController
#pragma mark Initialization

+ (void) initialize
{
    //Load up the preferences defaults
    NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UserDefaults" ofType:@"plist"]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:defaultPrefs];
    
    //Load up the value transformers. These make user interaction prettier, so that slider feedback, instead of being a float, is a nice string, etc.
    RoundedNumberTransformer *rounderSpeed;
    RoundedNumberTransformer *rounderTime;
    RoundedNumberTransformer *rounderFrequency;
    rounderSpeed = [[[RoundedNumberTransformer alloc] init] autorelease];
    rounderTime = [[[RoundedNumberTransformer alloc] init] autorelease];
    rounderFrequency = [[[RoundedNumberTransformer alloc] init] autorelease];
    [rounderSpeed setType:0];
    [NSValueTransformer setValueTransformer:rounderSpeed forName:@"NumberToSpeedTransformer"];
    [rounderTime setType:1];
    [NSValueTransformer setValueTransformer:rounderTime forName:@"NumberToTimeTransformer"];
    [rounderFrequency setType:2];
    [NSValueTransformer setValueTransformer:rounderFrequency forName:@"NumberToFrequencyTransformer"];
    
    BooleanColorTransformer *enabler = [[[BooleanColorTransformer alloc] init] autorelease];
    [NSValueTransformer setValueTransformer:enabler forName:@"BooleanColorTransformer"];
    
    // Expose some bindings
    [self exposeBinding:@"iTunesWatcher"];
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        //Necessary so that other parts of the program can communicate with this object
        [NSApp setDelegate:self];
            
        //Crank up the controllers
        pluginsController = [[PluginsController alloc] init];
        scriptController = [ScriptController sharedController];
    }
    
    return self;
}

- (void) dealloc
{
    [prefsController release];
    [findController release];
    [infoController release];
    [pluginsController release];
    [scriptController release];
    
    [super dealloc];
}

- (void) awakeFromNib
{
    NSUserDefaults *usd = [NSUserDefaults standardUserDefaults];
    //Show the splash screen if the preferences say so
    if ([usd boolForKey:@"showSplashScreen"])
    {
        [splashWindow center];
        [splashWindow orderFront:self];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:splashWindow selector:@selector(close) userInfo:nil repeats:NO];
    }
    
    //If the user hasn't set up preferences yet, open the prefs window
    if (![usd boolForKey:@"InitPrefsDone"])
    {
        [[self prefsController] display];
        [usd setBool:YES forKey:@"InitPrefsDone"];
    }
    
    [self bind:@"iTunesWatcher" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.keyPressAction" options:nil];
    [self setiTunesWatcher:[usd integerForKey:@"keyPressAction"] andDisplay:NO];
}

#pragma mark -
#pragma mark Hot Keys
//These methods tell the various controllers to show themselves when a hotkey is pressed.
//Other hot keys are taken care of in the PluginsController.
- (IBAction) infoHotKeyDown:(id)sender
{
    [[self infoController] display];
}

- (IBAction) findHotKeyDown:(id)sender
{
    [[self findController] display];
}

- (IBAction) preferencesHotKeyDown:(id)sender
{
    [[self prefsController] display];
}

#pragma mark -
#pragma mark Controllers
//These methods initialize a controller if it hasn't been already, or it returns the current instance of the controller
//if it has been initalized. The methods also take into account the fact that they might be called multiple times before
//initialization has been completed.
- (PrefsController *) prefsController 
{
    static BOOL initing = NO;
    
    if (initing) {
        return nil;
    }
    
    if (!prefsController) {
        initing = YES;
        prefsController = [PrefsController sharedController];
        initing = NO;
    }
    
    return prefsController; 
}

- (InfoController *) infoController 
{
    static BOOL initing = NO;
    
    if (initing) {
        return nil;
    }
    
    if (!infoController) {
        initing = YES;
        infoController = [InfoController sharedController];
        initing = NO;
    }
    
    return infoController; 
}

- (FindController *) findController 
{
    static BOOL initing = NO;
    
    if (initing) {
        return nil;
    }
    
    if (!findController) {
        initing = YES;
        findController = [FindController sharedController];
        initing = NO;
    }
    
    return findController; 
}

#pragma mark -
#pragma mark Interface Methods
//Pass-thru method from the main menu
- (IBAction) about:(id)sender
{
    [[self prefsController] about];
}

#pragma mark -
#pragma mark iTunesWatcher
- (int) iTunesWatcher;
{
    return iTunesWatcher;
}

- (void) setITunesWatcher:(int)watch
{
    [self setiTunesWatcher:watch andDisplay:YES];
}
- (void) setiTunesWatcher:(int)watch andDisplay:(BOOL)display
{
    //NSLog(@"set itunes watcher");
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:[self infoController]];
    switch (watch)
    {
        case 0:
            [[NSDistributedNotificationCenter defaultCenter] addObserver:[self infoController] selector:@selector(displayFromNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
            break;
        
        case 1:
            break;
            
        case 2:
            [[NSDistributedNotificationCenter defaultCenter] addObserver:[self infoController] selector:@selector(displayFromNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
            if (!display)
            {
                [[self infoController] display];
            }
            break;
            
        case 3:
            [[NSDistributedNotificationCenter defaultCenter] addObserver:[self infoController] selector:@selector(displayFromNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
            if (!display)
            {
                [[self infoController] display];
            }
            break;
    }
    iTunesWatcher = watch;
    if (display)
    {
        [[self infoController] display];
    }
}
@end

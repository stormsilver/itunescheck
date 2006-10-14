/* AppController */

#import <Cocoa/Cocoa.h>
#import "PrefsController.h"
#import "FindController.h"
#import "InfoController.h"
#import "PluginsController.h"
#import "ScriptController.h"

@interface AppController : NSObject
{
    IBOutlet id splashWindow;
    
    PrefsController *prefsController;
    FindController *findController;
    InfoController *infoController;
    PluginsController *pluginsController;
    ScriptController *scriptController;
    
    int iTunesWatcher;
}

#pragma mark -
#pragma mark Hot Keys
- (IBAction) infoHotKeyDown:(id)sender;
- (IBAction) findHotKeyDown:(id)sender;
- (IBAction) preferencesHotKeyDown:(id)sender;

#pragma mark -
#pragma mark Controllers
- (PrefsController *) prefsController;
- (FindController *) findController;
- (InfoController *) infoController;

#pragma mark -
#pragma mark Interface Methods
- (IBAction) about:(id)sender;

#pragma mark -
#pragma mark iTunesWatcher
- (int) iTunesWatcher;
- (void) setITunesWatcher:(int)watch;
- (void) setiTunesWatcher:(int)watch andDisplay:(BOOL)display;

@end

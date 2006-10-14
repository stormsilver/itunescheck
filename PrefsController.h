/* PrefsController */

#import <Cocoa/Cocoa.h>
#import "PluginsController.h"
#import "RoundedView.h"

@interface PrefsController : NSObject
{
    IBOutlet NSWindow *prefsWindow;
    IBOutlet id positioner;
    IBOutlet id positionerButton;
    IBOutlet PluginsController *pluginsController;
    IBOutlet NSColorWell *      backgroundColorWell;
    IBOutlet RoundedView *      _roundedView;
}

+ (id) sharedController;

- (void) display;
- (void) about;

#pragma mark -
#pragma mark IB Methods
- (IBAction) runDisplaySetupPanel:(id)sender;
- (IBAction) togglePositioner:(id)sender;
- (IBAction) visitWebsite:(id)sender;
- (IBAction) quitProgram:(id)sender;
- (IBAction) toggleHeadless:(id)sender;
- (IBAction) factorySettings:(id)sender;
- (IBAction) readme:(id)sender;

#pragma mark -
#pragma mark Support Methods
- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;


@end

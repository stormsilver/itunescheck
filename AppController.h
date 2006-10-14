/* AppController */

#import <Cocoa/Cocoa.h>
#import "InfoController.h"
#import "PrefsController.h"

@interface AppController : NSObject
{
    InfoController  *_infoController;
    PrefsController *_prefsController;
}

- (void) displayInfo:(id)sender;
- (void) displayInfoWithNotification:(NSNotification *)note;
- (void) displayInfo;

- (void) displayPrefsWindow:(id)sender;

@end

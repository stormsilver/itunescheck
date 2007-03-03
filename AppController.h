/* AppController */

#import <Cocoa/Cocoa.h>

@class InfoController;
@class PrefsController;

@interface AppController : NSObject
{
    InfoController  *_infoController;
    PrefsController *_prefsController;
}

+ (id) sharedController;

- (void) displayInfo:(id)sender;
- (void) displayInfoWithNotification:(NSNotification *)note;
- (void) displayInfo;

- (void) displayPrefsWindow:(id)sender;

@end

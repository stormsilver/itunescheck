/* AppController */

#import <Cocoa/Cocoa.h>

@class InfoController;
@class PrefsController;

@interface AppController : NSObject
{
}

+ (id) sharedController;

- (void) displayInfoWithNotification:(NSNotification *)note;
- (void) displayInfo;

- (void) displayInfoWindow:(id)sender;
- (void) displayPreferencesWindow:(id)sender;
- (void) displayQuickplayWindow:(id)sender;

@end

/* AppController */

#import <Cocoa/Cocoa.h>

#define APPKEY_LISTENER_ITUNES      @"iTunes"

@class InfoController;
@class PrefsController;

@interface AppController : NSObject
{
}

+ (id) sharedController;

- (void) beginListeningTo:(NSString *)object;
- (void) stopListeningTo:(NSString *)object;

- (void) displayInfoWindowWithNotification:(NSNotification *)note;
- (void) displayInfoWindow;
- (void) displayInfoWindow:(id)sender;

- (void) displayPreferencesWindow:(id)sender;

- (void) displayQuickplayWindow:(id)sender;

@end

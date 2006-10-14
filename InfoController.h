/* InfoController */

#import <Cocoa/Cocoa.h>
#import "DisplayPluginsController.h"
#import "ScriptController.h"
#import "InfoView.h"
#import "RoundedView.h"



@interface InfoController : NSWindowController
{
    NSPanel                     *_panel;
    RoundedView                 *_roundedView;
    DisplayPluginsController    *_displayPluginsController;
    ScriptController            *_scriptController;
    NSTimer                     *_fadeTimer;
    BOOL                        _fadeOut;
    NSDictionary *              _previousTrackInfo;
    
    float                       _delayTime;
    float                       _fadeInSpeed;
    float                       _fadeOutSpeed;
    float                       _positionX;
    float                       _positionY;
}

+ (id) sharedController;

- (void) startFadeIn;
- (void) startFadeOut;
- (void) goAway;

#pragma mark -
#pragma mark Bindings
- (void) setFadeInSpeed:(float)fade;
- (float) fadeInSpeed;
- (void) setFadeOutSpeed:(float)fade;
- (float) fadeOutSpeed;
- (void) setDelayTime:(float)time;
- (float) delayTime;
- (void) setPositionX:(NSString *)x;
- (float) positionX;
- (void) setPositionY:(NSString *)y;
- (float) positionY;


- (void) displayFromNotification:(NSNotification *)aNotification;
- (void) display;
- (void) showMessage:(NSString *)theMessage;
- (void) showMessage:(NSString *)theMessage withLaunchButton:(BOOL)launch andFade:(BOOL)fade;
- (void) updateTrackInfoWithView:(InfoView *)view;
- (InfoView *) trackInfo;

@end

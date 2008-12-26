//
//  InfoController.h
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/14/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "InfoWindow.h"


@interface InfoController : NSObject
{
    InfoWindow *_infoWindow;
}
+ (id) sharedController;
- (void) displayView:(NSString *)view;
- (void) displayView:(NSString *)view fromNotification:(NSNotification *)aNotification;
@end

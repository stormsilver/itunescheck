//
//  NetStormsilverItunescheckInfowindowInfoController.h
//  iTunesCheck
//
//  Created by Eric Hankins on 12/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <iTCBundle/iTC.h>
#include "defines.h"

#define PREFKEY_DELAY_TIME          @"delayTime"
#define PREFKEY_SHOW_WINDOW_ON      @"showWindowOn"

@interface InfoController : AbstractBundle
{
    WebViewWindowController     *windowController;
    NSTimer                     *delayTimer;
}

- (void) displayBundle:(NSBundle *)bundle view:(NSString *)view;
- (void) startListening;
- (void) stopListening;

@end

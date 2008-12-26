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

@interface InfoController : AbstractBundle
{
    WebViewWindowController     *windowController;
}

- (void) displayBundle:(NSBundle *)bundle view:(NSString *)view;

@end

//
//  InfoWindow.h
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/14/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WebViewWindow.h"

@interface InfoWindow : WebViewWindow
{
    NSTimer             *_delayTimer;
}

@end

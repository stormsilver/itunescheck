//
//  InfoWindow.m
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/14/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "InfoWindow.h"
#import "PrefsController.h"

@implementation InfoWindow

- (void) displayPage:(NSString *)pageData relativeTo:(NSURL *)base
{
    if (_delayTimer)
    {
        [_delayTimer invalidate];
        [_delayTimer release];
        _delayTimer = nil;
    }
    [super displayPage:pageData relativeTo:base];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    [super webView:sender didFinishLoadForFrame:frame];
    [super showWindow:nil];
    [_tabView transitionIn];
    _delayTimer = [[NSTimer scheduledTimerWithTimeInterval:[[[PrefsController sharedController] prefForKey:PREFKEY_INFO_DELAY_TIME] floatValue] target:self selector:@selector(closeWindow) userInfo:nil repeats:NO] retain];
}

@end

//
//  InfoWindow.h
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/14/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WebView;
@class AnimatedTabView;

@interface InfoWindow : NSWindowController
{
    WebView *_webView;
    AnimatedTabView *_tabView;
}
- (void) displayPage:(NSString *)pageData relativeTo:(NSURL *)base;
- (void) closeWindow;
- (void) showWebInspector:(id)sender;
@end

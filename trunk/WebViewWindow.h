//
//  WebViewWindow.h
//  iTunesCheck
//
//  Created by StormSilver on 3/5/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WebView;
@class AnimatedTabView;

@interface InfoWindow : NSWindowController
{
    WebView             *_webView;
    AnimatedTabView     *_tabView;
}
- (void) displayPage:(NSString *)pageData relativeTo:(NSURL *)base;
- (void) closeWindow;
- (void) showWebInspector:(id)sender;

@end

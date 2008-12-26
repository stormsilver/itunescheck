//
//  WebViewWindow.h
//  iTunesCheck
//
//  Created by StormSilver on 3/5/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "defines.h"

@class WebView;

@interface WebViewWindowController : NSWindowController
{
    WebView          *_webView;
}

- (void) displayPage:(NSString *)pageData relativeTo:(NSURL *)base;
- (void) userDidMoveWindow;
- (void) closeWindow;
- (void) showWebInspector:(id)sender;

@end

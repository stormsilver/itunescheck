//
//  QuickPlayWindow.h
//  iTunesCheck
//
//  Created by StormSilver on 3/4/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WebView;
@class AnimatedTabView;

@interface QuickPlayWindow : NSWindowController
{
    WebView             *_webView;
    AnimatedTabView     *_tabView;
}

- (void) displayPage:(NSString *)pageData relativeTo:(NSURL *)base;
- (void) closeWindow;

@end

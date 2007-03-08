//
//  WebPanel.h
//  iTunesCheck
//
//  Created by StormSilver on 3/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WebView;

@interface WebPanel : NSPanel
{
    BOOL _mouseInRegion;
    WebView *_webView;
}

@end

@interface NSObject (WebPanel)

- (void) userDidMoveWindow;

@end

//
//  InfoWindow.h
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/14/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


@interface InfoWindow : NSWindowController
{
    WebView *_webView;
}
- (void) displayPage:(NSString *)pageData relativeTo:(NSURL *)base;
- (void) showWebInspector:(id)sender;
@end

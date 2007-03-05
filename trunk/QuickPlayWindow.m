//
//  QuickPlayWindow.m
//  iTunesCheck
//
//  Created by StormSilver on 3/4/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "QuickPlayWindow.h"
#import "FindWindowController.h"

@implementation QuickPlayWindow

- (void) webView:(WebView *)sender windowScriptObjectAvailable:(WebScriptObject *)windowScriptObject
{
    [windowScriptObject setValue:[FindWindowController sharedController] forKey:@"FindWindowController"];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    [super webView:sender didFinishLoadForFrame:frame];
    [[self window] center];
    [[self window] orderFrontRegardless];
    [_tabView transitionIn];
    [[self window] makeKeyWindow];
    [[self window] makeFirstResponder:_webView];
}

@end

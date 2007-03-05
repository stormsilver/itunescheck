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



- (void) resize
{
    WebScriptObject *script = [_webView windowScriptObject];
    NSNumber *height = [script evaluateWebScript:@"document.getElementById('body').scrollHeight"];
    NSNumber *width = [script evaluateWebScript:@"document.getElementById('body').scrollWidth"];
    [[self window] disableFlushWindow];
    [[self window] disableScreenUpdatesUntilFlush];
    NSRect savedFrame = [[self window] frame];
    [[self window] setFrame:NSMakeRect(0.0f, 0.0f, [width floatValue], [height floatValue]) display:NO];
    [[self window] center];
    NSRect newFrame = [[self window] frame];
    [[self window] setFrame:savedFrame display:NO];
    [[self window] enableFlushWindow];
    [[self window] setFrame:newFrame display:YES animate:YES];
}

@end

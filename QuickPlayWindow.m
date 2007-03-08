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
    WebScriptObject *script = [_webView windowScriptObject];
    NSNumber *height = [script evaluateWebScript:@"document.getElementById('body').scrollHeight"];
    NSNumber *width = [script evaluateWebScript:@"document.getElementById('body').scrollWidth"];
    //NSLog(@"    h: %i, w: %i", [height intValue], [width intValue]);
    NSPoint origin = [[self window] frame].origin;
    [[self window] setFrame:NSMakeRect(origin.x, origin.y, [width floatValue], [height floatValue]) display:YES];
    [[self window] center];
    [[self window] orderFrontRegardless];
    [_tabView transitionIn];
    [[self window] makeKeyWindow];
    [[self window] makeFirstResponder:_webView];
}



- (void) resize
{
    // first make sure that none of these calculations make it to the screen
    [[self window] disableFlushWindow];
    [[self window] disableScreenUpdatesUntilFlush];
    // save the current frame so that we can do a smooth transition from it at the end
    NSRect savedFrame = [[self window] frame];
    // go ahead and max out the webview size so it'll recalculate its size based on a full screen
    [_webView setFrame:[[NSScreen mainScreen] visibleFrame]];
    WebScriptObject *script = [_webView windowScriptObject];
    NSNumber *height = [script evaluateWebScript:@"document.getElementById('body').scrollHeight"];
    NSNumber *width = [script evaluateWebScript:@"document.getElementById('body').scrollWidth"];
    // set the new size. note the 0,0 origin. we don't really care about where it is, just how big it is.
    [[self window] setFrame:NSMakeRect(0.0f, 0.0f, [width floatValue], [height floatValue]) display:NO];
    // now that we have a new size, center it
    [[self window] center];
    // snag this frame so that we can animate TO it
    NSRect newFrame = [[self window] frame];
    // restore the old frame so that we can animate FROM it
    [[self window] setFrame:savedFrame display:NO];
    // enable screen drawing again
    [[self window] enableFlushWindow];
    // now set the new frame and animate
    [[self window] setFrame:newFrame display:YES animate:YES];
}


- (void) webViewFocus:(WebView *)sender
{
    NSLog(@"web view got focus");
}
- (void) webViewUnocus:(WebView *)sender
{
    NSLog(@"web view lost focus");
}

@end

//
//  QuickPlayWindow.m
//  iTunesCheck
//
//  Created by StormSilver on 3/4/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <WebKit/WebViewPrivate.h>
#import "QuickPlayWindow.h"
#import "AnimatedTabView.h"
#import "FindWindowController.h"

@interface SuperWindow : NSPanel

@end
@implementation SuperWindow
- (BOOL) canBecomeKeyWindow
{
    return YES;
}
@end

@implementation QuickPlayWindow

- (id)init
{
    if (![super initWithWindow:nil])
        return nil;
    
    return self;
}


- (void) dealloc
{
    if ([super window])
    {
        [_webView release];
    }
    [super dealloc];
}


- (NSWindow *)window
{
    NSWindow *window = [super window];
    if (!window) {
        //NSPanel *window = [[NSPanel alloc] initWithContentRect:NSMakeRect(10.0f, 10.0f, 1.0f, 1.0f) styleMask:(NSBorderlessWindowMask | NSUtilityWindowMask) backing:NSBackingStoreBuffered defer:YES];
        //NSPanel *window = [[NSPanel alloc] initWithContentRect:NSMakeRect(10.0f, 10.0f, 1.0f, 1.0f) styleMask:(NSTitledWindowMask | NSUtilityWindowMask | NSNonactivatingPanelMask) backing:NSBackingStoreBuffered defer:YES];
        NSWindow *window = [[SuperWindow alloc] initWithContentRect:NSMakeRect(10.0f, 10.0f, 1.0f, 1.0f) styleMask:(NSBorderlessWindowMask | NSUtilityWindowMask | NSNonactivatingPanelMask) backing:NSBackingStoreBuffered defer:NO];
        [window setLevel:NSFloatingWindowLevel];
        [window setBackgroundColor:[NSColor clearColor]];
        //[window setBecomesKeyOnlyIfNeeded:NO];
        [window setOpaque:NO];
        [window setHasShadow:NO];
        //[window setWorksWhenModal:YES];
        //[window setAcceptsMouseMovedEvents:YES];
        //[window setIgnoresMouseEvents:NO];
        //[window setFloatingPanel:YES];
        //[window setReleasedWhenClosed:YES];
        //[window setMovableByWindowBackground:YES];
        //[window setHidesOnDeactivate:NO];
        //[window setDelegate:self];
        
        _tabView = [[AnimatedTabView alloc] init];
        
        _webView = [[WebView alloc] initWithFrame:[[NSScreen mainScreen] visibleFrame] frameName:nil groupName:nil];
        [_webView setFrameLoadDelegate:self];
        [_webView setUIDelegate:self];
        [_webView setDrawsBackground:NO];
        [_webView setMaintainsBackForwardList:NO];
        //[_webView _setDashboardBehavior:WebDashboardBehaviorAlwaysSendMouseEventsToAllWindows to:YES];
        //[_webView _setDashboardBehavior:WebDashboardBehaviorAlwaysAcceptsFirstMouse to:YES];
        //[[_webView windowScriptObject] setValue:[FindWindowController sharedController] forKey:@"FindWindowController"];
        
        NSView *blankView = [[[NSView alloc] initWithFrame:[[NSScreen mainScreen] visibleFrame]] autorelease];
        NSTabViewItem *blankTabItem = [[NSTabViewItem alloc] init];
        [blankTabItem setView:blankView];
        [_tabView addTabViewItem:blankTabItem];
        NSTabViewItem *webViewTabItem = [[NSTabViewItem alloc] init];
        [webViewTabItem setView:_webView];
        [_tabView addTabViewItem:webViewTabItem];
        
        [window setContentView:_tabView];
        //[window setInitialFirstResponder:_webView];
        
        [self setWindow:window];
        return window;
    }
    
    return window;
}

- (void) closeWindow
{
    [_tabView transitionOut];
    [[self window] orderOut:nil];
}

- (void) displayPage:(NSString *)pageData relativeTo:(NSURL *)base
{
    if ([[self window] isVisible])
    {
        [_tabView queueTabTransition];
    }
    else
    {
        [[self window] orderOut:nil];
    }
    [[self window] setContentSize:[[NSScreen mainScreen] visibleFrame].size];
    [[_webView mainFrame] loadHTMLString:pageData baseURL:base];
}

- (void) webView:(WebView *)sender windowScriptObjectAvailable:(WebScriptObject *)windowScriptObject
{
    [windowScriptObject setValue:[FindWindowController sharedController] forKey:@"FindWindowController"];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    // Only report feedback for the main frame.
    if (frame == [sender mainFrame])
    {
        WebScriptObject *script = [sender windowScriptObject];
        NSNumber *height = [script evaluateWebScript:@"document.getElementById('body').scrollHeight"];
        NSNumber *width = [script evaluateWebScript:@"document.getElementById('body').scrollWidth"];
        //NSLog(@"    h: %i, w: %i", [height intValue], [width intValue]);
        [[self window] setFrame:NSMakeRect(0.0f, 0.0f, [width floatValue], [height floatValue]) display:YES];
        [[self window] center];
        [[self window] orderFrontRegardless];
        [_tabView transitionIn];
        //[NSTimer scheduledTimerWithTimeInterval:[[[PrefsController sharedController] prefForKey:PREFKEY_INFO_DELAY_TIME] floatValue] target:self selector:@selector(closeWindow) userInfo:nil repeats:NO];
        [[self window] makeKeyWindow];
        [[self window] makeFirstResponder:_webView];
    }
}

- (void) webView:(WebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    NSLog(@"[JS ALERT]    %@", message);
}
/*
- (void) webView:(WebView *)sender setContentRect:(NSRect)contentRect
{
    NSLog(@"setContentRect: %@", NSRectToString(contentRect));
}
- (void) webView:(WebView *)sender setFrame:(NSRect)frame
{
    NSLog(@"setFrame: %@", NSRectToString(frame));
}
- (NSRect) webViewContentRect:(WebView *)sender
{
    NSRect rect = [[self window] frame];
    NSLog(@"webViewContentRect: %@", NSRectToString(rect));
    return rect;
}
- (NSRect) webViewFrame:(WebView *)sender
{
    NSRect rect = [[self window] frame];
    NSLog(@"webViewFrame: %@", NSRectToString(rect));
    return rect;
}
*/
@end

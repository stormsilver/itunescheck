//
//  WebViewWindow.m
//  iTunesCheck
//
//  Created by StormSilver on 3/5/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "WebViewWindowController.h"
#import "WebPanel.h"
#import <WebKit/WebKit.h>
//#import <WebKit/WebInspector.h>
//#import <WebKit/WebViewPrivate.h>


@interface NSWindow (NSWindowPrivate)
- (void)_setContentHasShadow:(BOOL)hasShadow;
@end


@implementation WebViewWindowController

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        
    }
    
    return self;
}


- (NSWindow *)window
{
    NSWindow *window = [super window];
    if (!window)
    {
        WebPanel *window = [[WebPanel alloc] initWithContentRect:NSMakeRect(10.0f, 10.0f, 1.0f, 1.0f) styleMask:(NSBorderlessWindowMask | NSUtilityWindowMask) backing:NSBackingStoreBuffered defer:YES];
        [window setBackgroundColor:[NSColor clearColor]];
        [window setOpaque:NO];
        [window setHasShadow:YES];
        [window _setContentHasShadow:NO];
        [window setWorksWhenModal:YES];
        [window setAcceptsMouseMovedEvents:YES];
        [window setIgnoresMouseEvents:NO];
        [window setFloatingPanel:YES];
        [window setReleasedWhenClosed:YES];
        [window setMovableByWindowBackground:YES];
        [window setHidesOnDeactivate:NO];
        [window setDelegate:self];
        
        //_tabView = [[AnimatedTabView alloc] init];
        
        _webView = [[WebView alloc] initWithFrame:[[NSScreen mainScreen] visibleFrame] frameName:nil groupName:nil];
        [_webView setFrameLoadDelegate:self];
        [_webView setUIDelegate:self];
        [_webView setDrawsBackground:NO];
        [_webView setMaintainsBackForwardList:NO];
//        [_webView _setDashboardBehavior:WebDashboardBehaviorAlwaysSendMouseEventsToAllWindows to:YES];
//        [_webView _setDashboardBehavior:WebDashboardBehaviorAlwaysAcceptsFirstMouse to:YES];
        
//        NSView *blankView = [[[NSView alloc] initWithFrame:[[NSScreen mainScreen] visibleFrame]] autorelease];
//        NSTabViewItem *blankTabItem = [[NSTabViewItem alloc] init];
//        [blankTabItem setView:blankView];
//        [_tabView addTabViewItem:blankTabItem];
//        NSTabViewItem *webViewTabItem = [[NSTabViewItem alloc] init];
//        [webViewTabItem setView:_webView];
//        [_tabView addTabViewItem:webViewTabItem];
        
        [window setContentView:_webView];
        //[window setInitialFirstResponder:_webView];
        
        [self setWindow:window];
    }
    
    return window;
}

- (void) closeWindow
{
//    [_tabView transitionOut];
    [[self window] orderOut:nil];
}

- (void) userDidMoveWindow
{

}

- (void) displayPage:(NSString *)pageData relativeTo:(NSURL *)base
{
    NSLog(@"settin it up on the line");
    if ([[self window] isVisible])
    {
        NSLog(@"Window visible... queueing transition");
        //        [_tabView queueTabTransition];
        [[self window] orderOut:nil];
    }
    else
    {
        NSLog(@"Window not visible... uhm...");
        [[self window] orderOut:nil];
    }
    
    // TODO: make this screen-agnostic
    [_webView setFrame:[[NSScreen mainScreen] visibleFrame]];
    [[_webView mainFrame] loadHTMLString:pageData baseURL:base];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    NSString *widthScript = @"var d = document.getElementById('body');var cs = getComputedStyle(d, '');var width = (d.scrollWidth + parseInt(cs.borderLeftWidth) + parseInt(cs.borderRightWidth) + parseInt(cs.marginLeft) + parseInt(cs.marginRight));width;";
    NSString *heightScript = @"var d = document.getElementById('body');var cs = getComputedStyle(d, '');var height = (d.scrollHeight + parseInt(cs.borderTopWidth) + parseInt(cs.borderBottomWidth) + parseInt(cs.marginTop) + parseInt(cs.marginBottom));height;";
    WebScriptObject *script = [sender windowScriptObject];
    float height = [[script evaluateWebScript:heightScript] floatValue];
    float width = [[script evaluateWebScript:widthScript] floatValue];
    //NSLog(@"width: %f, height: %f", width, height);
    // TODO: all SORTS of math to be done here
    // origin calculations
    // width/height constraints
    // paddings against the sides of the screen
    // oh yeah, don't forget it might be on a different screen...
    NSPoint origin = [[self window] frame].origin;
    [sender setFrame:NSMakeRect(0, 0, width, height)];
    [[self window] setFrame:NSMakeRect(origin.x, origin.y, width, height) display:YES];
    [self showWindow:nil];
}


- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems
{
//    NSMenuItem *prefs = [[NSMenuItem alloc] initWithTitle:@"Preferences" action:@selector(displayPrefsWindow:) keyEquivalent:@""];
//    [reload setTarget:[AppController sharedController]];
    
    NSMenuItem *inspector = [[NSMenuItem alloc] initWithTitle:@"Inspect Element" action:@selector(showWebInspector:) keyEquivalent:@""];
    [inspector setTarget:self];
    [inspector setRepresentedObject:element];
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:inspector, nil];
    [arr addObjectsFromArray:defaultMenuItems];
    return arr;
}

- (void) webView:(WebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    NSLog(@"[JS ALERT]    %@", message);
}

- (void) showWebInspector:(id)sender
{
//    WebInspector *webInspector = [WebInspector sharedWebInspector];
//    [webInspector setWebFrame:[_webView mainFrame]];
//    [webInspector setFocusedDOMNode:[[sender representedObject] objectForKey:WebElementDOMNodeKey]];
//    [webInspector showWindow:nil];
}
@end

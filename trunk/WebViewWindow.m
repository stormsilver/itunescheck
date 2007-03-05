//
//  WebViewWindow.m
//  iTunesCheck
//
//  Created by StormSilver on 3/5/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "WebViewWindow.h"
#import "PrefsController.h"
#import "AppController.h"

@interface KeyablePanel : NSPanel

@end
@implementation KeyablePanel
- (BOOL) canBecomeKeyWindow
{
    return YES;
}
@end

@implementation WebViewWindow

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
        NSWindow *window = [[KeyablePanel alloc] initWithContentRect:NSMakeRect(10.0f, 10.0f, 1.0f, 1.0f) styleMask:(NSBorderlessWindowMask | NSUtilityWindowMask | NSNonactivatingPanelMask) backing:NSBackingStoreBuffered defer:NO];
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
    NSLog(@"settin it up on the line");
    if ([[self window] isVisible])
    {
        NSLog(@"Window visible... queueing tab transition");
        [_tabView queueTabTransition];
    }
    else
    {
        NSLog(@"Window not visible... uhm...");
        [[self window] orderOut:nil];
    }
    //[[self window] setContentSize:[[NSScreen mainScreen] visibleFrame].size];
    //[[self window] setFrame:[[NSScreen mainScreen] visibleFrame] display:YES];
    //[[_tabView tabViewItemAtIndex:1] setView:[[[NSView alloc] initWithFrame:[[NSScreen mainScreen] visibleFrame]] autorelease]];
    [_webView setFrame:[[NSScreen mainScreen] visibleFrame]];
    [[_webView mainFrame] loadHTMLString:pageData baseURL:base];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    WebScriptObject *script = [sender windowScriptObject];
    NSNumber *height = [script evaluateWebScript:@"document.getElementById('body').scrollHeight"];
    NSNumber *width = [script evaluateWebScript:@"document.getElementById('body').scrollWidth"];
    //NSLog(@"    h: %i, w: %i", [height intValue], [width intValue]);
    [[self window] setFrame:NSMakeRect(20.0f, 20.0f, [width floatValue], [height floatValue]) display:YES];
}


- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems
{
    NSMenuItem *reload = [[NSMenuItem alloc] initWithTitle:@"Reload" action:@selector(displayInfoWindow:) keyEquivalent:@""];
    [reload setTarget:[AppController sharedController]];
    
    NSMenuItem *prefs = [[NSMenuItem alloc] initWithTitle:@"Preferences" action:@selector(displayPrefsWindow:) keyEquivalent:@""];
    [reload setTarget:[AppController sharedController]];
    
    NSMenuItem *inspector = [[NSMenuItem alloc] initWithTitle:@"Inspect Element" action:@selector(showWebInspector:) keyEquivalent:@""];
    [inspector setTarget:self];
    [inspector setRepresentedObject:element];
    
    return [NSArray arrayWithObjects:prefs, reload, inspector, nil];
}

- (void) webView:(WebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    NSLog(@"[JS ALERT]    %@", message);
}

- (void) showWebInspector:(id)sender
{
    WebInspector *webInspector = [WebInspector sharedWebInspector];
    [webInspector setWebFrame:[_webView mainFrame]];
    [webInspector setFocusedDOMNode:[[sender representedObject] objectForKey:WebElementDOMNodeKey]];
    [webInspector showWindow:nil];
}
@end

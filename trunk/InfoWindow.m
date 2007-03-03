//
//  InfoWindow.m
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/14/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "InfoWindow.h"
#import "AnimatedTabView.h"
#import <WebKit/WebKit.h>
#import <WebKit/WebInspector.h>
#import <WebKit/WebViewPrivate.h>

@implementation InfoWindow

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
        NSPanel *window = [[NSPanel alloc] initWithContentRect:NSMakeRect(20.0f, 20.0f, 1.0f, 1.0f)\
                                                               styleMask:(NSBorderlessWindowMask | NSUtilityWindowMask) backing:NSBackingStoreBuffered defer:YES];
        [window setBackgroundColor:[NSColor clearColor]];
        [window setBecomesKeyOnlyIfNeeded:YES];
        [window setOpaque:NO];
        [window setHasShadow:NO];
        [window setWorksWhenModal:YES];
        [window setAcceptsMouseMovedEvents:YES];
        [window setIgnoresMouseEvents:NO];
        [window setFloatingPanel:YES];
        [window setReleasedWhenClosed:YES];
        [window setMovableByWindowBackground:YES];
        [window setHidesOnDeactivate:NO];
        [window setDelegate:self];
        
        _tabView = [[AnimatedTabView alloc] init];
        [_tabView setTabViewType:NSNoTabsNoBorder];
        [_tabView setDrawsBackground:NO];
        
        _webView = [[WebView alloc] initWithFrame:[[NSScreen mainScreen] visibleFrame] frameName:nil groupName:nil];
        [_webView setFrameLoadDelegate:self];
        [_webView setUIDelegate:self];
        [_webView setDrawsBackground:NO];
        [_webView _setDashboardBehavior:WebDashboardBehaviorAlwaysSendMouseEventsToAllWindows to:YES];
        [_webView _setDashboardBehavior:WebDashboardBehaviorAlwaysAcceptsFirstMouse to:YES];
        //[[_webView windowScriptObject] setValue:self forKey:@"Inspector"];
        
        NSView *blankView = [[[NSView alloc] initWithFrame:[[NSScreen mainScreen] visibleFrame]] autorelease];
        NSTabViewItem *blankTabItem = [[NSTabViewItem alloc] init];
        [blankTabItem setView:blankView];
        [_tabView addTabViewItem:blankTabItem];
        NSTabViewItem *webViewTabItem = [[NSTabViewItem alloc] init];
        [webViewTabItem setView:_webView];
        [_tabView addTabViewItem:webViewTabItem];
        [window setContentView:_tabView];
        
        
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
    [[self window] orderOut:nil];
    [[self window] setContentSize:[[NSScreen mainScreen] visibleFrame].size];
    [[_webView mainFrame] loadHTMLString:pageData baseURL:base];
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
        [[self window] setFrame:NSMakeRect(20.0f, 20.0f, [width floatValue], [height floatValue]) display:YES];
        /*
        NSRect blank = [[_tabView tabViewItemAtIndex:0] frame];
        NSRect web = [[_tabView tabViewItemAtIndex:1] frame];
        NSLog(@"blank: %f, %f\tweb: %f, %f", blank.size.height, blank.size.width, web.size.height, web.size.width);
        */
        [super showWindow:nil];
        [_tabView transitionIn];
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(closeWindow) userInfo:nil repeats:NO];
    }
}


- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems
{
    NSMenuItem *reload = [[NSMenuItem alloc] initWithTitle:@"Reload" action:@selector(displayInfo:) keyEquivalent:@""];
    [reload setTarget:[NSApp delegate]];
    
    NSMenuItem *prefs = [[NSMenuItem alloc] initWithTitle:@"Preferences" action:@selector(displayPrefsWindow:) keyEquivalent:@""];
    [reload setTarget:[NSApp delegate]];
    
    NSMenuItem *inspector = [[NSMenuItem alloc] initWithTitle:@"Inspect Element" action:@selector(showWebInspector:) keyEquivalent:@""];
    [inspector setTarget:self];
    [inspector setRepresentedObject:element];
    
    return [NSArray arrayWithObjects:prefs, reload, inspector, nil];
}

- (void) showWebInspector:(id)sender
{
    WebInspector *webInspector = [WebInspector sharedWebInspector];
    [webInspector setWebFrame:[_webView mainFrame]];
    [webInspector setFocusedDOMNode:[[sender representedObject] objectForKey:WebElementDOMNodeKey]];
    [webInspector showWindow:nil];
}
@end

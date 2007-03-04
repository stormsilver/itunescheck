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
        NSPanel *window = [[NSPanel alloc] initWithContentRect:NSMakeRect(10.0f, 10.0f, 1.0f, 1.0f)\
                                                     styleMask:(NSBorderlessWindowMask | NSUtilityWindowMask) backing:NSBackingStoreBuffered defer:YES];
        [window setBackgroundColor:[NSColor clearColor]];
        //[window setBecomesKeyOnlyIfNeeded:YES];
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
        NSRect newFrame = NSMakeRect(0.0f, 0.0f, [width floatValue], [height floatValue]);
        [[self window] setFrame:newFrame display:YES];
        //[_webView setFrame:newFrame];
        
        /*
         NSRect blank = [[_tabView tabViewItemAtIndex:0] frame];
         NSRect web = [[_tabView tabViewItemAtIndex:1] frame];
         NSLog(@"blank: %f, %f\tweb: %f, %f", blank.size.height, blank.size.width, web.size.height, web.size.width);
         */
        [[self window] center];
        [super showWindow:nil];
        [_tabView transitionIn];
        //[NSTimer scheduledTimerWithTimeInterval:[[[PrefsController sharedController] prefForKey:PREFKEY_INFO_DELAY_TIME] floatValue] target:self selector:@selector(closeWindow) userInfo:nil repeats:NO];
    }
}
@end

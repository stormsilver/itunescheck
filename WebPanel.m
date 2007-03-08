//
//  WebPanel.m
//  iTunesCheck
//
//  Created by StormSilver on 3/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "WebPanel.h"

#import <WebKit/WebView.h>
#import <WebKit/WebViewPrivate.h>
#import <WebKit/WebDashboardRegion.h>
#import <WebKit/DOMCore.h>
#import <WebKit/DOMHTML.h>
#import <WebKit/DOMCSS.h>


@implementation WebPanel

- (BOOL)canBecomeKeyWindow
{
    return YES;
}
/*
 - (BOOL)canBecomeMainWindow
 {
     // prevent the inspector from confusing other panels
     return NO;
 }
 */
- (void)moveWindow:(NSEvent *)event
{
    NSPoint startLocation = [event locationInWindow];
    NSPoint lastLocation = startLocation;
    BOOL mouseUpOccurred = NO;
    
    while (!mouseUpOccurred) {
        // set mouseUp flag here, but process location of event before exiting from loop, leave mouseUp in queue
        event = [self nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask) untilDate:[NSDate distantFuture] inMode:NSEventTrackingRunLoopMode dequeue:YES];
        
        if ([event type] == NSLeftMouseUp)
            mouseUpOccurred = YES;
        
        NSPoint newLocation = [event locationInWindow];
        if (NSEqualPoints(newLocation, lastLocation))
            continue;
        
        NSPoint origin = [self frame].origin;
        [self setFrameOrigin:NSMakePoint(origin.x + newLocation.x - startLocation.x, origin.y + newLocation.y - startLocation.y)];
        lastLocation = newLocation;
        
        [[self delegate] userDidMoveWindow];
    }
}
/*
 - (void)resizeWindow:(NSEvent *)event
 {
     NSRect startFrame = [self frame];
     NSPoint startLocation = [self convertBaseToScreen:[event locationInWindow]];
     NSPoint lastLocation = startLocation;
     NSSize minSize = [self minSize];
     NSSize maxSize = [self maxSize];
     BOOL mouseUpOccurred = NO;
     
     while (!mouseUpOccurred) {
         // set mouseUp flag here, but process location of event before exiting from loop, leave mouseUp in queue
         event = [self nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask) untilDate:[NSDate distantFuture] inMode:NSEventTrackingRunLoopMode dequeue:YES];
         
         if ([event type] == NSLeftMouseUp)
             mouseUpOccurred = YES;
         
         NSPoint newLocation = [self convertBaseToScreen:[event locationInWindow]];
         if (NSEqualPoints(newLocation, lastLocation))
             continue;
         
         NSRect proposedRect = startFrame;
         proposedRect.size.width += newLocation.x - startLocation.x;;
         proposedRect.size.height -= newLocation.y - startLocation.y;
         proposedRect.origin.y += newLocation.y - startLocation.y;
         
         if (proposedRect.size.width < minSize.width) {
             proposedRect.size.width = minSize.width;
         } else if (proposedRect.size.width > maxSize.width) {
             proposedRect.size.width = maxSize.width;
         }
         
         if (proposedRect.size.height < minSize.height) {
             proposedRect.origin.y -= minSize.height - proposedRect.size.height;
             proposedRect.size.height = minSize.height;
         } else if (proposedRect.size.height > maxSize.height) {
             proposedRect.origin.y -= maxSize.height - proposedRect.size.height;
             proposedRect.size.height = maxSize.height;
         }
         
         [self setFrame:proposedRect display:YES];
         lastLocation = newLocation;
     }
 }
 */
- (void)sendEvent:(NSEvent *)event
{
    if (_mouseInRegion && [event type] == NSLeftMouseUp)
        _mouseInRegion = NO;
    
    if (([event type] == NSLeftMouseDown || [event type] == NSLeftMouseDragged) && !_mouseInRegion) {
        NSPoint pointInView = [[[[_webView mainFrame] frameView] documentView] convertPoint:[event locationInWindow] fromView:nil];
        NSDictionary *regions = [_webView _dashboardRegions];
        
        WebDashboardRegion *region = [[regions objectForKey:@"resizeTop"] lastObject];
        /*
         region = [[regions objectForKey:@"resize"] lastObject];
         if (region) {
             if (NSPointInRect(pointInView, [region dashboardRegionClip])) {
                 // we are in a resize control region, resize the window now and eat the event
                 [self resizeWindow:event];
                 return;
             }
         }
         */
        NSArray *controlRegions = [regions objectForKey:@"control"];
        NSEnumerator *enumerator = [controlRegions objectEnumerator];
        while ((region = [enumerator nextObject])) {
            if (NSPointInRect(pointInView, [region dashboardRegionClip])) {
                // we are in a control region, lets pass the event down
                _mouseInRegion = YES;
                [super sendEvent:event];
                return;
            }
        }
        
        // if we are dragging and the mouse isn't in a control region move the window
        if ([event type] == NSLeftMouseDragged) {
            [self moveWindow:event];
            return;
        }
    }
    
    [super sendEvent:event];
}

- (void) setWebView:(WebView *)webView
{
    _webView = webView;
}
- (WebView *) webView
{
    return _webView;
}
@end

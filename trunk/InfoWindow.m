//
//  InfoWindow.m
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/14/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "InfoWindow.h"
#import "PrefsController.h"

@implementation InfoWindow

- (void) displayPage:(NSString *)pageData relativeTo:(NSURL *)base
{
    switch ([[[PrefsController sharedController] prefForKey:PREFKEY_INFO_SHOW_ON] intValue])
    {
        // always
        case 0:
            break;
        
        // song change
        case 1:
            if (_delayTimer)
            {
                [_delayTimer invalidate];
                [_delayTimer release];
                _delayTimer = nil;
            }
            break;
        
        // hot key only
        case 2:
            if (_delayTimer)
            {
                [_delayTimer invalidate];
                [_delayTimer release];
                _delayTimer = nil;
            }
            break;
        
        default:
            break;
    }
    [super displayPage:pageData relativeTo:base];
}

- (void) userDidMoveWindow
{
    //NSLog(@"userDidMoveWindow");
    if (_delayTimer)
    {
        [_delayTimer invalidate];
        [_delayTimer release];
        _delayTimer = nil;
    }
    // The secret here is to grab the correct spot. What we want is:
    //  origin if it's in lower-left quadrant
    //  origin+height if it's in upper-left quadrant
    //  origin+height+width if it's in upper-right quad
    //  origin+width if it's in lower-right quad
    NSRect windowFrame = [[self window] frame];
    // find out which screen the point lies on, and get the frame for that screen
    NSRect screenFrame;
    NSArray *screenArray = [NSScreen screens];
    if ([screenArray count] > 1)
    {
        //NSPoint origin = NSMakePoint(0.0, 0.0);
        int i;
        for (i = 0; i < [screenArray count]; ++i)
        {
            if (NSPointInRect(windowFrame.origin, [[screenArray objectAtIndex:i] frame]))
            {
                screenFrame = [[screenArray objectAtIndex:i] frame];
                i = [screenArray count];
            }
        }
    } else
    {
        screenFrame = [[NSScreen mainScreen] frame];
    }
    if (windowFrame.origin.x > screenFrame.size.width/2)
    {
        windowFrame.origin.x += windowFrame.size.width;
    }
    if (windowFrame.origin.y > screenFrame.size.height/2)
    {
        windowFrame.origin.y += windowFrame.size.height;
    }
    [[PrefsController sharedController] setPref:NSStringFromPoint(windowFrame.origin) forKey:PREFKEY_INFO_ORIGIN];
    _delayTimer = [[NSTimer scheduledTimerWithTimeInterval:[[[PrefsController sharedController] prefForKey:PREFKEY_INFO_DELAY_TIME] floatValue] target:self selector:@selector(closeWindow) userInfo:nil repeats:NO] retain];

}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    WebScriptObject *script = [_webView windowScriptObject];
    NSNumber *height = [script evaluateWebScript:@"document.getElementById('body').scrollHeight"];
    NSNumber *width = [script evaluateWebScript:@"document.getElementById('body').scrollWidth"];
    //NSLog(@"    h: %i, w: %i", [height intValue], [width intValue]);
    NSPoint origin = NSPointFromString([[PrefsController sharedController] prefForKey:PREFKEY_INFO_ORIGIN]);
    // find out which screen the point lies on, and get the frame for that screen
    NSRect screenFrame;
    NSArray *screenArray = [NSScreen screens];
    if ([screenArray count] > 1)
    {
        //NSPoint origin = NSMakePoint(0.0, 0.0);
        int i;
        for (i = 0; i < [screenArray count]; ++i)
        {
            if (NSPointInRect(origin, [[screenArray objectAtIndex:i] frame]))
            {
                screenFrame = [[screenArray objectAtIndex:i] frame];
                i = [screenArray count];
            }
        }
    } else
    {
        screenFrame = [[NSScreen mainScreen] frame];
    }
    if (origin.x > screenFrame.size.width/2)
    {
        origin.x -= [width floatValue];
    }
    if (origin.y > screenFrame.size.height/2)
    {
        origin.y += [height floatValue];
    }
    [[self window] setFrame:NSMakeRect(origin.x, origin.y, [width floatValue], [height floatValue]) display:YES];
    [[self window] orderFrontRegardless];
    [_tabView transitionIn];
    switch ([[[PrefsController sharedController] prefForKey:PREFKEY_INFO_SHOW_ON] intValue])
    {
        // always
        case 0:
            break;
            
        // song change
        case 1:
            _delayTimer = [[NSTimer scheduledTimerWithTimeInterval:[[[PrefsController sharedController] prefForKey:PREFKEY_INFO_DELAY_TIME] floatValue] target:self selector:@selector(closeWindow) userInfo:nil repeats:NO] retain];
            break;
            
        // hot key only
        case 2:
            _delayTimer = [[NSTimer scheduledTimerWithTimeInterval:[[[PrefsController sharedController] prefForKey:PREFKEY_INFO_DELAY_TIME] floatValue] target:self selector:@selector(closeWindow) userInfo:nil repeats:NO] retain];
            break;
            
        default:
            break;
    }
}

@end

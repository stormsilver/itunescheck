//
//  TransparentWindow.m
//  RoundedFloatingPanel
//
//  Created by Matt Gemmell on Thu Jan 08 2004.
//  <http://iratescotsman.com/>
//


#import "TransparentWindow.h"
//#import "Controller.h"


@implementation TransparentWindow


- (id)initWithContentRect:(NSRect)contentRect styleMask:(unsigned int)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
    NSWindow* result = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    
    [result setBackgroundColor: [NSColor clearColor]];
    [result setLevel: NSFloatingWindowLevel];
    //[result setAlphaValue:1.0];
    [result setOpaque:NO];
    [result setHasShadow:NO];
    
    return result;
}

- (BOOL) canBecomeKeyWindow
{
    return YES;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint currentLocation;
    NSPoint newOrigin;
    //NSRect  screenFrame = [[self screen] visibleFrame];
    //NSRect  windowFrame = [self frame];
    
    currentLocation = [self convertBaseToScreen:[self mouseLocationOutsideOfEventStream]];
    newOrigin.x = currentLocation.x - initialLocation.x;
    newOrigin.y = currentLocation.y - initialLocation.y;
    /*
    if( (newOrigin.y + windowFrame.size.height) > (NSMaxY(screenFrame) - [NSMenuView menuBarHeight]) ){
        // Prevent dragging into the menu bar area
        newOrigin.y = NSMaxY(screenFrame) - windowFrame.size.height - [NSMenuView menuBarHeight];
    }
    
     if (newOrigin.y < NSMinY(screenFrame)) {
         // Prevent dragging off bottom of screen
         newOrigin.y = NSMinY(screenFrame);
     }
     if (newOrigin.x < NSMinX(screenFrame)) {
         // Prevent dragging off left of screen
         newOrigin.x = NSMinX(screenFrame);
     }
     if (newOrigin.x > NSMaxX(screenFrame) - windowFrame.size.width) {
         // Prevent dragging off right of screen
         newOrigin.x = NSMaxX(screenFrame) - windowFrame.size.width;
     }
     */
    
    [self setFrameOrigin:newOrigin];
}


- (void)mouseDown:(NSEvent *)theEvent
{    
    NSRect windowFrame = [self frame];
    
    // Get mouse location in global coordinates
    initialLocation = [self convertBaseToScreen:[theEvent locationInWindow]];
    initialLocation.x -= windowFrame.origin.x;
    initialLocation.y -= windowFrame.origin.y;
}

@end

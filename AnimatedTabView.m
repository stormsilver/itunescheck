//
//  AnimatingTab.m
//  WindowBlurTest
//
//  Created by StormSilver on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AnimatedTabView.h"
#import "PrefsController.h"

@interface TabViewAnimation : NSAnimation
@end

// Convenience function to clear an NSBitmapImageRep's bits to zero.
static void ClearBitmapImageRep(NSBitmapImageRep *bitmap) {
    unsigned char *bitmapData = [bitmap bitmapData];
    if (bitmapData != NULL) {
        // A fast alternative to filling with [NSColor clearColor].
        bzero(bitmapData, [bitmap bytesPerRow] * [bitmap pixelsHigh]);
    }
}


@implementation AnimatedTabView
- (id) init
{
    self = [super init];
    if (self)
    {
        [self setTabViewType:NSNoTabsNoBorder];
        [self setDrawsBackground:NO];
    }
    
    return self;
}
/* Over-ride the drawrect method. */
- (void)drawRect:(NSRect)rect {
    // First, draw the normal TabView content.  If we're animating, we will have hidden the TabView's content view, so invoking [super drawRect:rect] will just draw the tabs, border, and inset background.
    // If we're in the middle of animating, composite the animation result atop the base TabView content.
    if (animation != nil) {
        // Get outputCIImage for the current phase of the animation.  (This doesn't actually cause the image to be rendered just yet.)
        [transitionFilter setValue:[NSNumber numberWithFloat:[animation currentValue]] forKey:@"inputTime"];
        CIImage *outputCIImage = [transitionFilter valueForKey:@"outputImage"];
        // Composite the outputImage into the view (which triggers on-demand rendering of the result).
        [outputCIImage drawInRect:rect fromRect:NSMakeRect(0, rect.size.height, rect.size.width, -rect.size.height) operation:NSCompositeSourceOver fraction:1.0];
    }
    else
    {
        [super drawRect:rect];
    }
}

- (void)_createTransitionFilterStyle:(TransitionStyle)style forRect:(NSRect)rect initialCIImage:(CIImage *)initialCIImage finalCIImage:(CIImage *)finalCIImage
{
    //CIFilter *maskScalingFilter = nil;
    //CGRect maskExtent;
    /*
     switch (transitionStyle) {
         case CICopyMachine:
             transitionFilter = [[CIFilter filterWithName:@"CICopyMachineTransition"] retain];
             [transitionFilter setDefaults];
             [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
             break;
             
         case CIDisintegrate:
             transitionFilter = [[CIFilter filterWithName:@"CIDisintegrateWithMaskTransition"] retain];
             [transitionFilter setDefaults];
             
             // Scale our mask image to match the transition area size, and set the scaled result as the "inputMaskImage" to the transitionFilter.
             maskScalingFilter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
             [maskScalingFilter setDefaults];
             maskExtent = [inputMaskImage extent];
             float xScale = rect.size.width / maskExtent.size.width;
             float yScale = rect.size.height / maskExtent.size.height;
             [maskScalingFilter setValue:[NSNumber numberWithFloat:yScale] forKey:@"inputScale"];
             [maskScalingFilter setValue:[NSNumber numberWithFloat:xScale / yScale] forKey:@"inputAspectRatio"];
             [maskScalingFilter setValue:inputMaskImage forKey:@"inputImage"];
             
             [transitionFilter setValue:[maskScalingFilter valueForKey:@"outputImage"] forKey:@"inputMaskImage"];
             break;
             
         case CIDissolve:
             transitionFilter = [[CIFilter filterWithName:@"CIDissolveTransition"] retain];
             [transitionFilter setDefaults];
             break;
             
         case CIFlash:
             transitionFilter = [[CIFilter filterWithName:@"CIFlashTransition"] retain];
             [transitionFilter setDefaults];
             [transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
             [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
             break;
             
         case CIMod:
             transitionFilter = [[CIFilter filterWithName:@"CIModTransition"] retain];
             [transitionFilter setDefaults];
             [transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
             break;
             
         case CIPageCurl:
             transitionFilter = [[CIFilter filterWithName:@"CIPageCurlTransition"] retain];
             [transitionFilter setDefaults];
             [transitionFilter setValue:[NSNumber numberWithFloat:-M_PI_4] forKey:@"inputAngle"];
             [transitionFilter setValue:initialCIImage forKey:@"inputBacksideImage"];
             [transitionFilter setValue:inputShadingImage forKey:@"inputShadingImage"];
             [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
             break;
             
         case CISwipe:
             transitionFilter = [[CIFilter filterWithName:@"CISwipeTransition"] retain];
             [transitionFilter setDefaults];
             break;
             
         case CIRipple:
         default:
             transitionFilter = [[CIFilter filterWithName:@"CIRippleTransition"] retain];
             [transitionFilter setDefaults];
             [transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
             [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
             [transitionFilter setValue:inputShadingImage forKey:@"inputShadingImage"];
             break;
     }
     */
    
    switch (style)
    {
        case CICopyMachine:
            transitionFilter = [[CIFilter filterWithName:@"CICopyMachineTransition"] retain];
            [transitionFilter setDefaults];
            [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
            break;
            
        case CIDissolve:
            transitionFilter = [[CIFilter filterWithName:@"CIDissolveTransition"] retain];
            [transitionFilter setDefaults];
            break;
            
        case CIFlash:
            transitionFilter = [[CIFilter filterWithName:@"CIFlashTransition"] retain];
            [transitionFilter setDefaults];
            [transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
            [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
            break;
            
        case CIMod:
            transitionFilter = [[CIFilter filterWithName:@"CIModTransition"] retain];
            [transitionFilter setDefaults];
            [transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
            break;
            
        case CISwipe:
            transitionFilter = [[CIFilter filterWithName:@"CISwipeTransition"] retain];
            [transitionFilter setDefaults];
            break;
    }
    
    [transitionFilter setValue:initialCIImage forKey:@"inputImage"];
    [transitionFilter setValue:finalCIImage forKey:@"inputTargetImage"];
}


- (void) _transitionFrom:(int)from to:(int)to withTransition:(TransitionStyle)style time:(float)time hideTo:(BOOL)hideTo
{
    if (style < TransitionStyleDelimiter)
    {
        int option = CGSLeft; 
        int handle = -1;
        CGSTransitionSpec spec;
        
        // specify our specifications
        spec.unknown1=0;
        spec.type= style; // cube, swap, etc.
        spec.option=option | (1<<7); // "(1<<7)" is the transparent mask
        spec.backColour=NULL; // doesn't matter anyway since we're transparent
        spec.wid=[[self window] windowNumber]; // windowNumber. 0 for whole desktop ;)
        
        // LetÕs get a connection
        CGSConnection cgs= _CGSDefaultConnection();
        
        // Create a transition
        CGSNewTransition(cgs, &spec, &handle);
        
        // Redraw the window
        // !important otherwise you get the tab changing only after the transition.
        [self selectTabViewItemAtIndex:to];
        [[self window] display];
        
        /* Pass the connection, handle,
            * and duration to apply the animation
            */
        CGSInvokeTransition(cgs, handle, time);
        /* We need to wait for the transition to finish
            * before we get rid of it, otherwise weÕll get
            * all sorts of nasty errors... or maybe not.
            */
        usleep((useconds_t)(time*1000000));
        
        
        /* Finally, release all our variables */
        CGSReleaseTransition(cgs, handle);
        handle=0;
    }
    else
    {
        // Make a note of the content view of the NSTabViewItem we're switching from, and the content view of the one we're switching to.
        NSView *initialContentView = [[self tabViewItemAtIndex:from] view];
        NSView *finalContentView = [[self tabViewItemAtIndex:to] view];
        
        // Compute bounds and frame rectangles big enough to encompass both views.  (We'll use imageRect later, to composite the animation frames into the right place within the AnimatingTabView.)
        NSRect rect = NSUnionRect([initialContentView bounds], [finalContentView bounds]);
        imageRect = NSUnionRect([initialContentView frame], [finalContentView frame]);
        
        // Render the initialContentView to a bitmap.  When using the -cacheDisplayInRect:toBitmapImageRep: and -displayRectIgnoringOpacity:inContext: methods, remember to first initialize the destination to clear if the content to be drawn won't cover it with full opacity.
        NSBitmapImageRep *initialContentBitmap = [initialContentView bitmapImageRepForCachingDisplayInRect:rect];
        ClearBitmapImageRep(initialContentBitmap);
        [initialContentView cacheDisplayInRect:rect toBitmapImageRep:initialContentBitmap];
        
        // Invoke super's implementation of -selectTabViewItem: to switch to the requested tabViewItem.
        // The NSTabView will mark itself as needing display, but the window will not have redrawn yet, so this is our chance to animate the transition!
        //[self selectNextTabViewItem:nil];
        
        // Render the finalContentView to a bitmap.
        NSBitmapImageRep *finalContentBitmap = [finalContentView bitmapImageRepForCachingDisplayInRect:rect];
        ClearBitmapImageRep(finalContentBitmap);
        [finalContentView cacheDisplayInRect:rect toBitmapImageRep:finalContentBitmap];
        
        // Build a Core Image filter that will morph the initialContentBitmap into the finalContentBitmap.  
        CIImage *initialCIImage = [[CIImage alloc] initWithBitmapImageRep:initialContentBitmap];
        CIImage *finalCIImage = [[CIImage alloc] initWithBitmapImageRep:finalContentBitmap];
        [self _createTransitionFilterStyle:style forRect:rect initialCIImage:initialCIImage finalCIImage:finalCIImage];
        [initialCIImage release];
        [finalCIImage release];
        
        // Create an instance of TabViewAnimation to drive the transition over time.  Set the AnimatingTabView to be the TabViewAnimation's delegate, so the TabViewAnimation will know which view to redisplay as the animation progresses.
        animation = [[TabViewAnimation alloc] initWithDuration:time animationCurve:NSAnimationEaseInOut];
        [animation setDelegate:self];
        
        // Hide the TabView's new content view for the duration of the animation.
        if (hideTo)
        {
            [finalContentView setHidden:YES];
        }
        else
        {
            [initialContentView setHidden:YES];
        }
        
        // Run the animation synchronously.
        [animation startAnimation];
        
        // Clean up after the animation has finished.
        [animation release];
        animation = nil;
        [transitionFilter release];
        transitionFilter = nil;
        //[self selectNextTabViewItem:nil];
        if (hideTo)
        {
            [finalContentView setHidden:NO];
        }
        else
        {
            [initialContentView setHidden:NO];
        }
    }
}

- (void) transitionIn
{
    // equalize the frame sizes... this makes the animate draw in the correct spot
    [[[self tabViewItemAtIndex:0] view] setFrame:[self frame]];
    [[[self tabViewItemAtIndex:1] view] setFrame:[self frame]];
    // ensure the first tab item is selected... you never know
    [self selectTabViewItemAtIndex:0];
    [self _transitionFrom:0 to:1
           withTransition:[[[PrefsController sharedController] prefForKey:PREFKEY_WINDOW_TRANSITION_OUT_STYLE] intValue]
           time:[[[PrefsController sharedController] prefForKey:PREFKEY_WINDOW_TRANSITION_IN_TIME] floatValue]
           hideTo:YES];
    // switch to the second tab item once the animation has been completed
    [self selectTabViewItemAtIndex:1];
}

- (void) transitionOut
{
    [self selectTabViewItemAtIndex:1];
    [self _transitionFrom:1 to:0
    withTransition:[[[PrefsController sharedController] prefForKey:PREFKEY_WINDOW_TRANSITION_OUT_STYLE] intValue]
    time:[[[PrefsController sharedController] prefForKey:PREFKEY_WINDOW_TRANSITION_OUT_TIME] floatValue]
    hideTo:NO];
    [self selectTabViewItemAtIndex:0];
}



@end

@implementation TabViewAnimation

// Override NSAnimation's -setCurrentProgress: method, and use it as our point to hook in and advance our Core Image transition effect to the next time slice.
- (void)setCurrentProgress:(NSAnimationProgress)progress {
    // First, invoke super's implementation, so that the NSAnimation will remember the proposed progress value and hand it back to us when we ask for it in AnimatingTabView's -drawRect: method.
    [super setCurrentProgress:progress];
    
    // Now ask the AnimatingTabView (which set itself as our delegate) to display.  Sending a -display message differs from sending -setNeedsDisplay: or -setNeedsDisplayInRect: in that it demands an immediate, synchronous redraw of the view.  Most of the time, it's preferable to send a -setNeedsDisplay... message, which gives AppKit the opportunity to coalesce potentially numerous display requests and update the window efficiently when it's convenient.  But for a synchronously executing animation, it's appropriate to use -display.
    [[self delegate] display];
}

@end
//
//  RoundedView.h
//  RoundedFloatingPanel
//
//  Created by Matt Gemmell on Thu Jan 08 2004.
//  <http://iratescotsman.com/>
//


#import <Cocoa/Cocoa.h>

@interface RoundedView : NSView
{
    NSColor *bgColor;
    float mRadius;
    BOOL clickDismisses;
    BOOL shouldDrawStroke;
}

- (void) setBackgroundColor:(NSColor*)color;
- (NSColor *)backgroundColor;

- (void) setDrawStroke:(BOOL)ena;
- (BOOL) drawStroke;

- (void) setRadius:(float)rad;
- (float) radius;

- (void) setClickDismisses:(BOOL)click;
- (BOOL) clickDismisses;

@end

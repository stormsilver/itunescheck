//
//  RoundedView.m
//  RoundedFloatingPanel
//
//  Created by Matt Gemmell on Thu Jan 08 2004.
//  <http://iratescotsman.com/>
//


#import "RoundedView.h"
#import "NSBezierPath+StrokeExtensions.h"
#import "InfoController.h"

@implementation RoundedView
+ (void) initialize
{
    [self exposeBinding:@"backgroundColor"];
    [self exposeBinding:@"clickDismisses"];
    [self exposeBinding:@"drawStroke"];
}

- (void) dealloc
{
    [[NSUserDefaultsController sharedUserDefaultsController] removeObserver:self forKeyPath:@"values.backgroundColor"];
    [[NSUserDefaultsController sharedUserDefaultsController] removeObserver:self forKeyPath:@"values.drawWindowBorder"];
    [[NSUserDefaultsController sharedUserDefaultsController] removeObserver:self forKeyPath:@"values.clickDismisses"];
    
    [bgColor release];
}

- (void) awakeFromNib
{
    mRadius = 25.0;
    clickDismisses = NO;
    shouldDrawStroke = YES;
    
    [self bind:@"drawStroke" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.drawWindowBorder" options:nil];
}

- (void)drawRect:(NSRect)rect
{
    int minX = NSMinX(rect);
    int midX = NSMidX(rect);
    int maxX = NSMaxX(rect);
    int minY = NSMinY(rect);
    int midY = NSMidY(rect);
    int maxY = NSMaxY(rect);
    
    float radius = mRadius;
    BOOL stroke = shouldDrawStroke;
    id thing;
    NSEnumerator *thingEnumerator = [[self subviews] objectEnumerator];
    while (thing = [thingEnumerator nextObject])
    {
        if (!NSIntersectsRect([thing bounds], rect) && [thing isKindOfClass:[NSControl class]])
        {
            radius = 0.0;
            stroke = NO;
        }
    }
    
    NSBezierPath *bgPath = [NSBezierPath bezierPath];
    
    // Bottom edge and bottom-right curve
    [bgPath moveToPoint:NSMakePoint(midX, minY)];
    [bgPath appendBezierPathWithArcFromPoint:NSMakePoint(maxX, minY) 
                                     toPoint:NSMakePoint(maxX, midY) 
                                      radius:radius];
    
    // Right edge and top-right curve
    [bgPath appendBezierPathWithArcFromPoint:NSMakePoint(maxX, maxY) 
                                     toPoint:NSMakePoint(midX, maxY) 
                                      radius:radius];
    
    // Top edge and top-left curve
    [bgPath appendBezierPathWithArcFromPoint:NSMakePoint(minX, maxY) 
                                     toPoint:NSMakePoint(minX, midY) 
                                      radius:radius];
    
    // Left edge and bottom-left curve
    [bgPath appendBezierPathWithArcFromPoint:rect.origin 
                                     toPoint:NSMakePoint(midX, minY) 
                                      radius:radius];
    [bgPath closePath];

    [bgColor set];

    [bgPath fill];
    
    if (shouldDrawStroke && stroke)
    {
        [bgPath setLineWidth:2.0];
        [[bgColor colorWithAlphaComponent:1.0] set];
        [bgPath strokeInside];
    }
}

- (NSColor *) backgroundColor
{
    return bgColor;
}
- (void) setBackgroundColor:(NSColor*)color
{
    if (bgColor != color)
    {
        [color retain];
        [bgColor release];
        bgColor = color;
        [self display];
    }
}

- (BOOL) drawStroke
{
    return shouldDrawStroke;
}
- (void) setDrawStroke:(BOOL)ena
{
    shouldDrawStroke = ena;
    [self display];
}

- (void) setRadius:(float)radius
{
    mRadius = radius;
}
- (float) radius
{
    return mRadius;
}

- (void) setClickDismisses:(BOOL)click
{
    clickDismisses = click;
}
- (BOOL) clickDismisses
{
    return clickDismisses;
}

- (BOOL) isOpaque
{
    return NO;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (clickDismisses)
    {
        [[InfoController sharedController] close];
    } else {
        [[self window] mouseDown:theEvent];
    }
}

- (NSView *)hitTest:(NSPoint)aPoint
{
    if (clickDismisses)
    {
        return self;
    } else {
        return [super hitTest:aPoint];
    }
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
    if (clickDismisses)
        return YES;
    else
        return NO;
}

@end

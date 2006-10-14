//
//  RoundedView.m
//  WindowTest
//
//  Created by StormSilver on 2/19/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "RoundedView.h"


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
    
    [_bgColor release];
    
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        _mRadius = 25.0;
        _clickDismisses = NO;
        _shouldDrawStroke = YES;
        
        [self bind:@"drawStroke" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.drawWindowBorder" options:nil];
    }
    return self;
}

- (void)drawRect:(NSRect)rect
{
    NSRect bounds = [self bounds];
	NSBezierPath *bezelPath = [NSBezierPath bezierPath];
	NSPoint topLeft = NSMakePoint(bounds.origin.x, bounds.origin.y);
	NSPoint topRight = NSMakePoint(bounds.origin.x + bounds.size.width, bounds.origin.y);
	NSPoint bottomLeft = NSMakePoint(bounds.origin.x, bounds.origin.y + bounds.size.height);
	NSPoint bottomRight = NSMakePoint(bounds.origin.x + bounds.size.width, bounds.origin.y + bounds.size.height);
    
	[bezelPath appendBezierPathWithArcWithCenter:NSMakePoint(topLeft.x + _mRadius, topLeft.y + _mRadius)
                                          radius:_mRadius
                                      startAngle:180
                                        endAngle:270
                                       clockwise:NO];
	[bezelPath lineToPoint:NSMakePoint(topRight.x - _mRadius, topRight.y)];
	
	[bezelPath appendBezierPathWithArcWithCenter:NSMakePoint(topRight.x - _mRadius, topRight.y + _mRadius)
                                          radius:_mRadius
                                      startAngle:270
                                        endAngle:0
                                       clockwise:NO];
	[bezelPath lineToPoint:NSMakePoint(bottomRight.x, bottomRight.y - _mRadius)];
	
	[bezelPath appendBezierPathWithArcWithCenter:NSMakePoint(bottomRight.x - _mRadius, bottomRight.y - _mRadius)
                                          radius:_mRadius
                                      startAngle:0
                                        endAngle:90
                                       clockwise:NO];
	[bezelPath lineToPoint:NSMakePoint(bottomLeft.x + _mRadius, bottomLeft.y)];
	
	[bezelPath appendBezierPathWithArcWithCenter:NSMakePoint(bottomLeft.x + _mRadius, bottomLeft.y - _mRadius)
                                          radius:_mRadius
                                      startAngle:90
                                        endAngle:180
                                       clockwise:NO];
	[bezelPath lineToPoint:NSMakePoint(topLeft.x, topLeft.y + _mRadius)];
	
	[_bgColor set];
	[bezelPath fill];
    
    if (_shouldDrawStroke)
    {
        [bezelPath setLineWidth:4.0];
        [[_bgColor colorWithAlphaComponent:1.0] set];
        [bezelPath setClip];
        [NSBezierPath clipRect:rect];
        [bezelPath stroke];
    }
}

- (NSColor *) backgroundColor
{
    return _bgColor;
}
- (void) setBackgroundColor:(NSColor*)color
{
    if (_bgColor != color)
    {
        [color retain];
        [_bgColor release];
        _bgColor = color;
        [self display];
    }
}

- (BOOL) drawStroke
{
    return _shouldDrawStroke;
}
- (void) setDrawStroke:(BOOL)ena
{
    _shouldDrawStroke = ena;
    [self display];
}

- (void) setRadius:(float)radius
{
    _mRadius = radius;
}
- (float) radius
{
    return _mRadius;
}

- (void) setClickDismisses:(BOOL)click
{
    _clickDismisses = click;
}
- (BOOL) clickDismisses
{
    return _clickDismisses;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (_clickDismisses)
    {
        [[[NSApp delegate] infoController] goAway];
    }
    else
    {
        [[self window] mouseDown:theEvent];
    }
}

- (NSView *)hitTest:(NSPoint)aPoint
{
   if (_clickDismisses)
    {
        return self;
    }
    else
    {
        return [super hitTest:aPoint];
    }
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
    if (_clickDismisses)
        return YES;
    else
        return NO;
}

@end

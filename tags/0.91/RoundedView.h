//
//  RoundedView.h
//  WindowTest
//
//  Created by StormSilver on 2/19/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RoundedView : NSView
{
    NSColor     *_bgColor;
    float       _mRadius;
    BOOL        _clickDismisses;
    BOOL        _shouldDrawStroke;
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

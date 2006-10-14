//
//  WindowView.m
//  WindowTest
//
//  Created by StormSilver on 2/19/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "InfoView.h"
#import "ScriptController.h"


@implementation InfoView

#define BORDER_RADIUS 20.0
#define DBORDER_RADIUS 2*BORDER_RADIUS

- (id)initWithFrame:(NSRect)frame
{
	if (self = [super initWithFrame:frame])
    {
		_target = nil;
		_action = nil;
        _imageView = nil;
        _textView = nil;
        
        _streamingField = [[NSTextField alloc] init];
        [_streamingField setFont:[[NSFontManager sharedFontManager] convertFont:[NSFont systemFontOfSize:10.0] toHaveTrait:NSBoldFontMask]];
        [_streamingField bind:@"textColor" 
                     toObject:[NSUserDefaultsController sharedUserDefaultsController] 
                  withKeyPath:@"values.textColor" 
                      options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
        [_streamingField setStringValue:@"Streaming"];
        [_streamingField setSelectable:NO];
        [_streamingField sizeToFit];
        [_streamingField setDrawsBackground:NO];
        [_streamingField setBezeled:NO];
        _streamingFieldHeight = [_streamingField frame].size.height;
        
        _launchButton = [[NSButton alloc] init];
        [[_launchButton cell] setControlSize:NSSmallControlSize];
        [_launchButton setButtonType:NSMomentaryPushButton];
        [_launchButton setTitle:@"Launch"];
        [_launchButton setBezelStyle:NSTexturedSquareBezelStyle];
        [_launchButton setFont:[NSFont controlContentFontOfSize:11.0]];
        //58x18 is the same size as the buttons in Find.nib
        [_launchButton setFrame:NSMakeRect(BORDER_RADIUS + 150, BORDER_RADIUS - 15, 58, 18)];
        [_launchButton setTarget:self];
        [_launchButton setAction:@selector(launchButtonClicked:)];
	}
	return self;
}

- (void)dealloc {
	_target = nil;
	
	[super dealloc];
}

- (NSRect) positionSubviewsAtPoint:(NSPoint)oPoint
{
    NSRect rval;
    NSSize textSize = [[_textView textStorage] size];
    NSLayoutManager *layoutManager = [_textView layoutManager];
    NSTextContainer *textContainer = [_textView textContainer];
    [textContainer setWidthTracksTextView:YES];
    //[textContainer setHeightTracksTextView:YES];
    [textContainer setLineFragmentPadding:0.0];
    
    
    //Get the height of the text. Make sure it's not less than the size of the image!
    float textHeight = textSize.height;
    float imageHeight = [_imageView frame].size.height;
    float imageWidth = [_imageView frame].size.width;
    if (textHeight < imageHeight)
    {
        textHeight = imageHeight;
    }
    //Get the width of the text
    float textWidth = textSize.width + (imageWidth > 0 ? imageWidth + 8.0 : 0.0);
    
    //Set up two rectangles, one with the area we just determined, and one with the size of the screen
    //Add the area for the bezel
    NSRect drawArea = NSMakeRect(oPoint.x, oPoint.y, textWidth+(DBORDER_RADIUS), textHeight+(DBORDER_RADIUS));
    //NSLog(@"initial drawArea: %@", NSStringFromRect(drawArea));
    NSRect visibleArea;
    NSArray *screenArray = [NSScreen screens];
    if ([screenArray count] > 1)
    {
        NSPoint origin = NSMakePoint(0.0, 0.0);
        int i = 0;
        for (i = 0; i < [screenArray count]; ++i)
        {
            if (NSPointInRect(origin, [[screenArray objectAtIndex:i] frame]))
            {
                visibleArea = [[screenArray objectAtIndex:i] visibleFrame];
                i = [screenArray count];
            }
        }
    } else
    {
        visibleArea = [[NSScreen mainScreen] visibleFrame];
    }
    
    
    //If the area we're trying to draw to exceeds the area of the screen, we need to do some creative reconstruction
    //so that our window doesn't go off the screen
    //The first thing we'll try to do is just move the window so that it's onscreen.
    if (!NSContainsRect(visibleArea, drawArea))
    {
        //NSLog(@"offscreen");
        if ((drawArea.origin.x + drawArea.size.width/2) >= (visibleArea.origin.x + visibleArea.size.width/2))
        {
            //Okay, it's to the right.
            while ((drawArea.origin.x + drawArea.size.width) > (visibleArea.origin.x + visibleArea.size.width))
            {
                drawArea.origin.x -= 5.0;
            }
        } else
        {
            //It's to the left
            while (drawArea.origin.x < visibleArea.origin.x)
            {
                drawArea.origin.x += 5.0;
            }
        }
        
        //Now we'll do y.
        if ((drawArea.origin.y + drawArea.size.height/2) >= (visibleArea.origin.y + visibleArea.size.height/2))
        {
            //Okay, it's top.
            while ((drawArea.origin.y + drawArea.size.height) > (visibleArea.origin.y + visibleArea.size.height))
            {
                drawArea.origin.y -= 5.0;
            }
        } else
        {
            //It's to the bottom
            while (drawArea.origin.y < visibleArea.origin.y)
            {
                drawArea.origin.y += 5.0;
            }
        }
        
        //Then we'll test again to see if just moving it made the info window fit within the visible screen area
        if (!NSContainsRect(visibleArea, drawArea))
        {
            //NSLog(@"STILL offscreen");
            //Well, it didn't. Now we'll resize the window.
            drawArea = NSIntersectionRect(visibleArea, drawArea);
            [textContainer setContainerSize:NSMakeSize(drawArea.size.width, 2400.0)];
            //And get the new height of the text
            (void) [layoutManager glyphRangeForTextContainer:textContainer];
            float textHeight = [layoutManager usedRectForTextContainer:textContainer].size.height + (DBORDER_RADIUS);
            if (textHeight < imageHeight)
            {
                textHeight = imageHeight + DBORDER_RADIUS;
            }
            drawArea.size.height = textHeight;
            drawArea.size.width = [layoutManager usedRectForTextContainer:textContainer].size.width + (DBORDER_RADIUS);
            float adjustment = (drawArea.origin.y + drawArea.size.height) - (visibleArea.origin.y + visibleArea.size.height);
            if (adjustment > 0)
            {
                drawArea.origin.y -= adjustment;
            }
        }
    }
    
    //Make sure the thing is at least the minimum size
    if (drawArea.size.width < (DBORDER_RADIUS))
    {
        drawArea.size.width = DBORDER_RADIUS;
    }
    if (drawArea.size.height < (DBORDER_RADIUS))
    {
        drawArea.size.height = DBORDER_RADIUS;
    }
    
    //Right now drawArea contains the exact size of our overall window, including the area for the bezel. This is what needs to get returned
    rval = drawArea;
    drawArea.origin = NSMakePoint(0.0, 0.0);
    
    [self setFrame:drawArea];
    //NSLog(@"window: %@", NSStringFromRect(drawArea));
    //Now we can begin positioning everything, beginning with the textView
    [_textView setFrame:NSMakeRect(BORDER_RADIUS + (imageWidth > 0 ? imageWidth + 8.0 : 0.0), 
                                   BORDER_RADIUS, 
                                   drawArea.size.width - DBORDER_RADIUS - imageWidth, 
                                   drawArea.size.height - DBORDER_RADIUS)];
    //NSLog(@"textView: %@", NSStringFromRect([_textView frame]));
    //Next the imageView
    if (_imageView)
    {
        [_imageView setFrameOrigin:NSMakePoint(BORDER_RADIUS, 
                                               BORDER_RADIUS + ((drawArea.size.height - DBORDER_RADIUS)/2 - [_imageView frame].size.height/2))];
        //NSLog(@"imageView: %@", NSStringFromRect([_imageView frame]));
    }
    //finally, the streamingField
    [_streamingField setFrameOrigin:NSMakePoint(BORDER_RADIUS/1.5, 
                                                drawArea.origin.y + drawArea.size.height - _streamingFieldHeight - BORDER_RADIUS/2)];
    //NSLog(@"streamingField: %@", NSStringFromRect([_streamingField frame]));
    
    return rval;
}

- (NSRect) positionSubviews
{
    return [self positionSubviewsAtPoint:NSMakePoint(0., 0.)];
}

- (void) setGraphic:(NSImage *)image
{
    [_imageView removeFromSuperview];
    [_imageView release];
    
    NSImageView *imageView = [[[NSImageView alloc] initWithFrame:NSMakeRect(0., 0., [image size].width, [image size].height)] autorelease];
    [imageView setImage:image];
    
    _imageView = imageView;
    [self addSubview:_imageView];
}

- (void) setText:(NSMutableAttributedString *)text
{
    [_textView removeFromSuperview];
    [_textView release];
    [text retain];
    
    NSTextView *textView = [[NSTextView allocWithZone:[self zone]] initWithFrame:NSMakeRect(0., 0., 0., 0.)];
    NSTextStorage *textStorage = [textView textStorage];
    [textStorage beginEditing];
    [textStorage setAttributedString:text];
    [textStorage endEditing];
    [textView setDrawsBackground:NO];
    [textView setHorizontallyResizable:NO];
    [textView setVerticallyResizable:NO];
    [textView setAutoresizingMask:(NSViewMaxXMargin | NSViewHeightSizable)];
    [textView setSelectable:NO];
    [textView setRichText:YES];
    [textView setImportsGraphics:YES];
    [textView setTextContainerInset:NSMakeSize(0., 0.)];
    
    [text release];
    _textView = textView;
    [self addSubview:_textView];
}

- (void) setStreaming:(BOOL)enable
{
    if (enable)
    {
        [self addSubview:_streamingField];
        [_streamingField release];
    }
    else
    {
        [_streamingField retain];
        [_streamingField removeFromSuperview];
    }
}

- (void) setLaunchButton:(BOOL)enable
{
    if (enable)
    {
        [self addSubview:_launchButton];
        [_launchButton release];
    }
    else
    {
        [_launchButton retain];
        [_launchButton removeFromSuperview];
    }
}

- (id) target {
	return _target;
}

- (void) setTarget:(id) object {
	_target = object;
}

#pragma mark -

- (SEL) action {
	return _action;
}

- (void) setAction:(SEL) selector {
	_action = selector;
}

#pragma mark -

- (void) launchButtonClicked:(id)sender
{
    [NSThread detachNewThreadSelector:@selector(launchiTunes:) toTarget:[ScriptController sharedController] withObject:nil];
}
/*
 - (void) mouseUp:(NSEvent *) event {
	if( _target && _action && [_target respondsToSelector:_action] )
		[_target performSelector:_action withObject:self];
}
*/



@end

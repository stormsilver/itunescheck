//
//  WindowView.h
//  WindowTest
//
//  Created by StormSilver on 2/19/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface InfoView : NSView
{
    NSImageView         *_imageView;
    NSTextView          *_textView;
    NSTextField         *_streamingField;
    NSButton            *_launchButton;
    SEL					_action;
	id					_target;
    
    float               _streamingFieldHeight;
}


- (void) setText:(NSMutableAttributedString *)text;
- (void) setGraphic:(NSImage *)image;
- (void) setStreaming:(BOOL)enable;
- (void) setLaunchButton:(BOOL)enable;

- (NSRect) positionSubviews;
- (NSRect) positionSubviewsAtPoint:(NSPoint)oPoint;


- (id)target;
- (void)setTarget:(id)object;

- (SEL)action;
- (void)setAction:(SEL)selector;

- (void) launchButtonClicked:(id)sender;

@end

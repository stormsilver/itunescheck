//
//  ShortcutRecorderTextView.m
//  iTunesCheck
//
//  Created by Eric Hankins on 12/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ShortcutRecorderTextView.h"


@implementation ShortcutRecorderTextView
// We need keyboard access
- (BOOL)acceptsFirstResponder
{
    return YES;
}

// Allow the control to be activated with the first click on it even if it's window isn't the key window
- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
	return YES;
}

- (BOOL) becomeFirstResponder 
{
    BOOL okToChange = [recorderCell becomeFirstResponder];
    return okToChange;
}

- (BOOL) resignFirstResponder 
{
    BOOL okToChange = [recorderCell resignFirstResponder];
    return okToChange;
}

// Like most NSControls, pass things on to the cell
- (BOOL)performKeyEquivalent:(NSEvent *)theEvent
{
	// Only if we're key, please. Otherwise hitting Space after having
	// tabbed past SRRecorderControl will put you into recording mode.
	if (([[[self window] firstResponder] isEqualTo:self])) { 
		if ([recorderCell performKeyEquivalent:theEvent]) return YES;
	}
    
	return [super performKeyEquivalent: theEvent];
}

- (void)flagsChanged:(NSEvent *)theEvent
{
	[recorderCell flagsChanged:theEvent];
}

- (void)keyDown:(NSEvent *)theEvent
{
	if ( [recorderCell performKeyEquivalent: theEvent] )
        return;
    
    [super keyDown:theEvent];
}

- (void) setShortcutRecorderCell:(ShortcutRecorderCell *)srCell
{
    recorderCell = srCell;
}
@end

//
//  ShortcutRecorderCell.m
//  iTunesCheck
//
//  Created by Eric Hankins on 12/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ShortcutRecorderCell.h"
#import "ShortcutRecorderTextView.h"
#import "PTKeyCombo.h"

//
//@interface ShortcutRecorderCell (Private)
//- (unsigned int) filteredCocoaFlags:(unsigned int)flags;
//@end


@implementation ShortcutRecorderCell
- (id) init
{
    self = [super init];
    if (self != nil)
    {
        allowedFlags = ShortcutRecorderAllFlags;
        requiredFlags = ShortcutRecorderEmptyFlags;
        recordingFlags = ShortcutRecorderEmptyFlags;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ShortcutRecorderCell *ret = (ShortcutRecorderCell *)[super copyWithZone:zone];
    [ret setRepresentedObject:[self representedObject]];
    ret->fieldEditor = fieldEditor;
    return ret;
}

- (BOOL) performKeyEquivalent:(NSEvent *)theEvent
{
    unsigned int flags = [theEvent modifierFlags];
    signed short code = [theEvent keyCode];
    keyCombo = [[PTKeyCombo alloc] initWithKeyCode:code andCocoaModifiers:flags];
    if ([self target] && [[self target] respondsToSelector:[self action]])
    {
        // send the action
        [[self target] performSelector:[self action] withObject:self];
    }
    if (fieldEditor)
    {
        // stop editing
        [self endEditing:fieldEditor];
        if ([[self controlView] isKindOfClass:[NSTableView class]])
        {
            [(NSTableView *)[self controlView] reloadData];
        }
        [[[self controlView] window] makeFirstResponder:[self controlView]];
    }
    return YES;
}

// We need keyboard access
- (BOOL)acceptsFirstResponder
{
    return YES;
}
- (BOOL) becomeFirstResponder;
{
    return YES;
}

- (BOOL)resignFirstResponder;
{
    return YES;
}

- (void)flagsChanged:(NSEvent *)theEvent
{
	//NSLog(@"flags changed!");
    //[[self controlView] flagsChanged:theEvent];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength
{
    //NSLog(@"%@ selectWithFrame: inView:%@ editor:%@ delegate:%@", self, controlView, textObj, anObject);
    //if (!srTextView)
    //{
    //    srTextView = [[ShortcutRecorderTextView alloc] initWithFrame:[textObj frame]];
    //}
    //[textObj removeFromSuperviewWithoutNeedingDisplay];
    //[controlView addSubview:srTextView];
    //NSLog(@"editor: %@ (%@)", textObj, [self objectValue]);
    fieldEditor = textObj;
    if ([textObj isKindOfClass:[ShortcutRecorderTextView class]])
    {
        [(ShortcutRecorderTextView *)textObj setShortcutRecorderCell:self];
    }
    //int row = [controlView selectedRow];
    //NSLog(@"datasource: %@", [controlView dataSource]);
    ////[srTextView becomeFirstResponder];
    ////[[controlView window] makeFirstResponder:srTextView];
    //[super selectWithFrame:aRect inView:controlView editor:srTextView delegate:anObject start:selStart length:selLength];
    
    [super selectWithFrame:aRect inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

- (void)setObjectValue:(id < NSCopying >)object
{
    [self setRepresentedObject:object];
    [super setObjectValue:object];
}

- (PTKeyCombo *) keyCombo
{
    return keyCombo;
}

@end


//@implementation ShortcutRecorderCell (Private)
//- (unsigned int) filteredCocoaFlags:(unsigned int)flags
//{
//	unsigned int filteredFlags = ShortcutRecorderEmptyFlags;
//	unsigned int a = allowedFlags;
//	unsigned int m = requiredFlags;
//    
//	if (m & NSCommandKeyMask) filteredFlags |= NSCommandKeyMask;
//	else if ((flags & NSCommandKeyMask) && (a & NSCommandKeyMask)) filteredFlags |= NSCommandKeyMask;
//	
//	if (m & NSAlternateKeyMask) filteredFlags |= NSAlternateKeyMask;
//	else if ((flags & NSAlternateKeyMask) && (a & NSAlternateKeyMask)) filteredFlags |= NSAlternateKeyMask;
//	
//	if ((m & NSControlKeyMask)) filteredFlags |= NSControlKeyMask;
//	else if ((flags & NSControlKeyMask) && (a & NSControlKeyMask)) filteredFlags |= NSControlKeyMask;
//	
//	if ((m & NSShiftKeyMask)) filteredFlags |= NSShiftKeyMask;
//	else if ((flags & NSShiftKeyMask) && (a & NSShiftKeyMask)) filteredFlags |= NSShiftKeyMask;
//	
//	if ((m & NSFunctionKeyMask)) filteredFlags |= NSFunctionKeyMask;
//	else if ((flags & NSFunctionKeyMask) && (a & NSFunctionKeyMask)) filteredFlags |= NSFunctionKeyMask;
//	
//	return filteredFlags;
//}
//@end

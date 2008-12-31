//
//  PTKeyCombo.h
//  Protein
//
//  Created by Quentin Carnicelli on Sat Aug 02 2003.
//  Copyright (c) 2003 Quentin D. Carnicelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>


// Some default values
#define ShortcutRecorderEmptyFlags 0
#define ShortcutRecorderAllFlags ShortcutRecorderEmptyFlags | (NSCommandKeyMask | NSAlternateKeyMask | NSControlKeyMask | NSShiftKeyMask | NSFunctionKeyMask)
#define ShortcutRecorderEmptyCode -1

// These keys will cancel the recoding mode if not pressed with any modifier
#define ShortcutRecorderEscapeKey 53
#define ShortcutRecorderBackspaceKey 51
#define ShortcutRecorderDeleteKey 117

unsigned int SRCocoaToCarbonFlags( unsigned int cocoaFlags );

@interface PTKeyCombo : NSObject <NSCopying>
{
	int	mKeyCode;
	int	mModifiers;
}

+ (id)clearKeyCombo;
+ (id)keyComboWithKeyCode: (int)keyCode modifiers: (int)modifiers;
- (id)initWithKeyCode: (int)keyCode modifiers: (int)modifiers;
- (id)initWithKeyCode: (int)keyCode andCocoaModifiers: (unsigned int)modifiers;

- (id)initWithPlistRepresentation: (id)plist;
- (id)plistRepresentation;

- (BOOL)isEqual: (PTKeyCombo*)combo;

- (int)keyCode;
- (int)modifiers;

- (BOOL)isClearCombo;
- (BOOL)isValidHotKeyCombo;

@end

@interface PTKeyCombo (UserDisplayAdditions)

- (NSString*)description;

@end
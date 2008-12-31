//
//  ShortcutRecorderCell.h
//  iTunesCheck
//
//  Created by Eric Hankins on 12/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PTKeyCombo;

@interface ShortcutRecorderCell : NSTextFieldCell
{
    unsigned int        allowedFlags;
	unsigned int        requiredFlags;
	unsigned int        recordingFlags;
    
    PTKeyCombo          *keyCombo;
    NSText              *fieldEditor;
}

- (PTKeyCombo *) keyCombo;

@end

//
//  ShortcutRecorderTextView.h
//  iTunesCheck
//
//  Created by Eric Hankins on 12/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ShortcutRecorderCell;

@interface ShortcutRecorderTextView : NSTextView
{
    ShortcutRecorderCell    *recorderCell;
}

- (void) setShortcutRecorderCell:(ShortcutRecorderCell *)srCell;

@end

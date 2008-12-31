//
//  PTHotKey.h
//  Protein
//
//  Created by Quentin Carnicelli on Sat Aug 02 2003.
//  Copyright (c) 2003 Quentin D. Carnicelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import "PTKeyCombo.h"

@interface PTHotKey : NSObject <NSCopying>
{
	NSString*		mName;
	PTKeyCombo*		mKeyCombo;
	id				mTarget;
	SEL				mAction;
    EventHotKeyRef  carbonHotKey;
    //NSTimer         *invocationTimer;
}

- (id)init;

- (void) setCarbonHotKey:(EventHotKeyRef)hotKey;
- (EventHotKeyRef)carbonHotKey;

- (void)setName: (NSString*)name;
- (NSString*)name;

- (void)setKeyCombo: (PTKeyCombo*)combo;
- (PTKeyCombo*)keyCombo;

- (void)setTarget: (id)target;
- (id)target;
- (void)setAction: (SEL)action;
- (SEL)action;

- (void) invoke;
//- (void) invokeTimer:(NSTimer *)timer;
//- (void) uninvoke;

@end

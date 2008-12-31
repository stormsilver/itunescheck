//
//  PTHotKey.m
//  Protein
//
//  Created by Quentin Carnicelli on Sat Aug 02 2003.
//  Copyright (c) 2003 Quentin D. Carnicelli. All rights reserved.
//

#import "PTHotKey.h"

#import "PTHotKeyCenter.h"
#import "PTKeyCombo.h"

@implementation PTHotKey

- (id)init
{
	self = [super init];
	
	if( self )
	{
		[self setKeyCombo: [PTKeyCombo clearKeyCombo]];
	}
	
	return self;
}

- (id)copyWithZone:(NSZone*)zone;
{
	return [self retain];
}

- (void)dealloc
{
	[mName release];
	[mKeyCombo release];
	
	[super dealloc];
}

- (NSString*)description
{
	//return [NSString stringWithFormat: @"<%@: %@>", NSStringFromClass( [self class] ), [self keyCombo]];
    return [mKeyCombo description];
}

#pragma mark -

- (void)setKeyCombo: (PTKeyCombo*)combo
{
	[combo retain];
	[mKeyCombo release];
	mKeyCombo = combo;
}

- (PTKeyCombo*)keyCombo
{
	return mKeyCombo;
}

- (void)setName: (NSString*)name
{
	[name retain];
	[mName release];
	mName = name;
}

- (NSString*)name
{
	return mName;
}

- (void)setTarget: (id)target
{
	mTarget = target;
}

- (EventHotKeyRef)carbonHotKey
{
	return carbonHotKey;
}

- (void)setCarbonHotKey:(EventHotKeyRef)hotKey
{
	carbonHotKey = hotKey;
}

- (id)target
{
	return mTarget;
}

- (void)setAction: (SEL)action
{
	mAction = action;
}

- (SEL)action
{
	return mAction;
}

- (void)invoke
{
    [mTarget performSelector: mAction withObject: self];
	//invocationTimer = [[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(invokeTimer:) userInfo:nil repeats:YES] retain];
}
/*
- (void) invokeTimer:(NSTimer *)timer
{
    [mTarget performSelector: mAction withObject: self];
}

- (void) uninvoke
{
    [invocationTimer invalidate];
    [invocationTimer release];
}
*/
@end

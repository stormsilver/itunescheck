//
//  PTHotKeyCenter.m
//  Protein
//
//  Created by Quentin Carnicelli on Sat Aug 02 2003.
//  Copyright (c) 2003 Quentin D. Carnicelli. All rights reserved.
//

#import "PTHotKeyCenter.h"
#import "PTHotKey.h"
#import "PTKeyCombo.h"
#import <Carbon/Carbon.h>

@interface PTHotKeyCenter (Private)
- (void)_updateEventHandler;
- (void)_hotKeyDown: (PTHotKey*)hotKey;
- (void)_hotKeyUp: (PTHotKey*)hotKey;
static OSStatus hotKeyEventHandler(EventHandlerCallRef inHandlerRef, EventRef inEvent, void* refCon );
@end

@implementation PTHotKeyCenter

static id _sharedHotKeyCenter = nil;

+ (id)sharedCenter
{
	if( _sharedHotKeyCenter == nil )
	{
		_sharedHotKeyCenter = [[self alloc] init];
	}
	
	return _sharedHotKeyCenter;
}

- (id)init
{
	self = [super init];
	
	if( self )
	{
		mHotKeys = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (void)dealloc
{
	[mHotKeys release];
	[super dealloc];
}

#pragma mark -

- (BOOL)registerHotKey: (PTHotKey*)hotKey
{
    //NSLog(@"registerHotKey: %@", hotKey);
	OSStatus err;
	EventHotKeyID hotKeyID;
	EventHotKeyRef carbonHotKey;
    PTHotKey *currentHotKey = [mHotKeys objectForKey:[hotKey name]];
    
    if (hotKey == currentHotKey)
    {
        //return YES;
    }
	if (currentHotKey)
    {
        //NSLog(@"key already registered, deregistering first");
    	[self unregisterHotKey: hotKey];
    }
	if ([[hotKey keyCombo] isValidHotKeyCombo] == NO)
    {
        //NSLog(@"not valid keycombo:");
        return YES;
    }
		
	
	hotKeyID.signature = 'PTHk';
	hotKeyID.id = (long)hotKey;
	//NSLog(@"registering...");
	err = RegisterEventHotKey(  [[hotKey keyCombo] keyCode],
								[[hotKey keyCombo] modifiers],
								hotKeyID,
								GetEventDispatcherTarget(),
								0,
								&carbonHotKey );

	if( err )
    {
        //NSLog(@"error --");
        return NO;
    }
		

    [hotKey setCarbonHotKey:carbonHotKey];
	[mHotKeys setObject: hotKey forKey: [hotKey name]];

	[self _updateEventHandler];
	//NSLog(@"Eo registerHotKey:");
	return YES;
}

- (void)unregisterHotKey: (PTHotKey*)hotKey
{
    //NSLog(@"unregisterHotKey: %@", hotKey);
	OSStatus err;
	EventHotKeyRef carbonHotKey;
    PTHotKey *oldHotKey = [mHotKeys objectForKey:[hotKey name]];

	if(!oldHotKey)
    {
		return;
    }
	
	carbonHotKey = [oldHotKey carbonHotKey];
	NSAssert( carbonHotKey != nil, @"" );

	err = UnregisterEventHotKey( carbonHotKey );
	//Watch as we ignore 'err':

	[mHotKeys removeObjectForKey:[oldHotKey name]];
	
	[self _updateEventHandler];
    //NSLog(@"Eo unregisterHotKey:");
	//See that? Completely ignored
}

- (void) unregisterHotKeyForName:(NSString *)name
{
    [self unregisterHotKey:[mHotKeys objectForKey:name]];
}

- (void) unregisterAllHotKeys;
{
    NSEnumerator *enumerator = [mHotKeys objectEnumerator];
    id thing;
    while (thing = [enumerator nextObject])
    {
        [self unregisterHotKey:thing];
    }
}

- (void) setHotKeyRegistrationForName:(NSString *)name enable:(BOOL)ena
{
    if (ena)
    {
        [self registerHotKey:[mHotKeys objectForKey:name]];
    } else
    {
        [self unregisterHotKey:[mHotKeys objectForKey:name]];
    }
}

- (void) updateHotKey:(PTHotKey *)hk
{
    [hk retain];
    //NSLog(@"updateHotKey: %@", hk);
    [self unregisterHotKey:[mHotKeys objectForKey:[hk name]]];
    //NSLog(@"unreg'd: %@", hk);
    [self registerHotKey:hk];
    //NSLog(@"Eo updateHotKey:");
}

- (PTHotKey *) hotKeyForName:(NSString *)name
{
    return [mHotKeys objectForKey:name];
}

- (NSArray*)allHotKeys
{
	return [mHotKeys allValues];
}

#pragma mark -
- (void)_updateEventHandler
{
	if( [mHotKeys count] && mEventHandlerInstalled == NO )
	{
		EventTypeSpec eventSpec[2] = {
			{ kEventClassKeyboard, kEventHotKeyPressed },
			{ kEventClassKeyboard, kEventHotKeyReleased }
		};    

		InstallEventHandler( GetEventDispatcherTarget(),
							 (EventHandlerProcPtr)hotKeyEventHandler, 
							 2, eventSpec, nil, nil);
	
		mEventHandlerInstalled = YES;
	}
}

- (void)_hotKeyDown: (PTHotKey*)hotKey
{
	[hotKey invoke];
}

- (void)_hotKeyUp: (PTHotKey*)hotKey
{
    //[hotKey uninvoke];
}

- (OSStatus)sendCarbonEvent: (EventRef)event
{
	OSStatus err;
	EventHotKeyID hotKeyID;
	PTHotKey* hotKey;

	NSAssert( GetEventClass( event ) == kEventClassKeyboard, @"Unknown event class" );

	err = GetEventParameter(	event,
								kEventParamDirectObject, 
								typeEventHotKeyID,
								nil,
								sizeof(EventHotKeyID),
								nil,
								&hotKeyID );
	if( err )
		return err;
	

	NSAssert( hotKeyID.signature == 'PTHk', @"Invalid hot key id" );
	NSAssert( (PTHotKey*)hotKeyID.id != nil, @"Invalid hot key id" );

	hotKey = (PTHotKey*)hotKeyID.id;

	switch( GetEventKind( event ) )
	{
		case kEventHotKeyPressed:
            [self _hotKeyDown: hotKey];
            break;

		case kEventHotKeyReleased:
            [self _hotKeyUp: hotKey];
            break;

		default:
			NSAssert( 0, @"Unknown event kind" );
	}
	
	return noErr;
}

static OSStatus hotKeyEventHandler(EventHandlerCallRef inHandlerRef, EventRef inEvent, void* refCon )
{
	return [[PTHotKeyCenter sharedCenter] sendCarbonEvent: inEvent];
}

@end

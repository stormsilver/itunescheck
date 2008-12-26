//
//  PrefsWindowController.m
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/27/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PrefsWindowController.h"
#import "PrefsController.h"
#import "PTKeyComboPanel.h"
#import "BooleanColorTransformer.h"
#import "RoundedNumberTransformer.h"


@implementation PrefsWindowController
+ (id) sharedController
{
    static id sharedController;
    
    if (!sharedController)
    {
        sharedController = [[self alloc] init];
    }
    
    return sharedController;
}

+ (void) initialize
{
    [NSValueTransformer setValueTransformer:[[[BooleanColorTransformer alloc] init] autorelease] forName:@"BooleanColorTransformer"];
    [NSValueTransformer setValueTransformer:[[[RoundedNumberTransformer alloc] init] autorelease] forName:@"RoundedNumberTransformer"];
}

- (id) init
{
    static BOOL initing = NO;
    self = [super init];
    
    if (self && !initing)
    {
        initing = YES;
        
        [NSBundle loadNibNamed:@"Preferences" owner:self];
    }
    
    initing = NO;
    
    return self;
}

- (void) awakeFromNib
{
    //show transparency in the color panel
    [[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
    
    [[self window] center];
    [[self window] setLevel:NSFloatingWindowLevel];
}

- (void) show
{
    if ([[self window] isKeyWindow])
    {
        [[self window] performClose:nil];
    }
    else
    {
        [NSApp activateIgnoringOtherApps:YES];
        [[self window] makeKeyAndOrderFront:nil];
    }
}

- (IBAction) changeHotKey:(id)sender
{
    [NSApp beginSheet:[[PTKeyComboPanel sharedPanel] window] modalForWindow:[self window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
    [[PTKeyComboPanel sharedPanel] runModalForHotKey:[[PrefsController sharedController] hotKeyAtIndex:[_arrayController selectionIndex]]];
    [NSApp endSheet:[[PTKeyComboPanel sharedPanel] window]];
}

- (IBAction) quitProgram:(id)sender
{
    [NSApp terminate:sender];
}
- (IBAction) visitWebsite:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[sender title]]];
}


- (void) windowShouldClose:(NSNotification *)note
{
    [[PrefsController sharedController] save];
}
@end

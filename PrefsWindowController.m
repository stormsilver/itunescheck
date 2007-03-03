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
    BooleanColorTransformer *enabler = [[[BooleanColorTransformer alloc] init] autorelease];
    [NSValueTransformer setValueTransformer:enabler forName:@"BooleanColorTransformer"];
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
    
    //select the first tab item
    //[[[[prefsWindow contentView] subviews] lastObject] selectFirstTabViewItem:nil];
    
    [[self window] center];
    //NSLog(@"%@", self);
    //[positioner bind:@"backgroundColor" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.backgroundColor" options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
    //[_roundedView bind:@"backgroundColor" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.backgroundColor" options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
    
    // set the sort descriptors for the hot key plugins list
    //NSSortDescriptor *nameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
    //[_arrayController setSortDescriptors:[NSArray arrayWithObject:nameDescriptor]];
}

- (void) show
{
    [self showWindow:nil];
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
@end

//
//  PrefsWindowController.m
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/27/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PrefsWindowController.h"


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
    
    //set the delegate of the prefsWindow to us, so that we can receive windowShouldClose messages
    //[prefsWindow setDelegate:self];
    
    //select the first tab item
    //[[[[prefsWindow contentView] subviews] lastObject] selectFirstTabViewItem:nil];
    
    [[self window] center];
    //NSLog(@"%@", self);
    //[positioner bind:@"backgroundColor" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.backgroundColor" options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
    //[_roundedView bind:@"backgroundColor" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.backgroundColor" options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
}

- (void) show
{
    [self showWindow:nil];
    //NSLog(@"%@", self);
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

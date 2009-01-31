//
//  ApplicationController.m
//  iTunesCheck
//
//  Created by Eric Hankins on 12/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ApplicationController.h"
#import "BundleController.h"
#import "PreferencesWindowController.h"
#import <iTCBundle/iTC.h>


@implementation ApplicationController

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        bundleController = [BundleController sharedController];
        preferencesWindowController = [[PreferencesWindowController alloc] init];
    }
    return self;
}

- (void) awakeFromNib
{
    // for each bundle, add a button for it to the debug window
    NSEnumerator *bundleEnum = [[bundleController bundleInstances] objectEnumerator];
    AbstractBundle *bundle;
    NSRect frame = NSMakeRect(10, 0, 125, 32);
    while (bundle = [bundleEnum nextObject])
    {
        if ([bundle isHotKeyBundle])
        {
            //        NSLog(@"got a bundle of %@", [thing class]);
            frame.origin.y += 32;
            NSButton *button = [[NSButton alloc] initWithFrame:frame];
            [button setButtonType:NSMomentaryPushInButton];
            [button setBezelStyle:NSRoundedBezelStyle];
            //        [button setBordered:YES];
            [button setTitle:[bundle shortName]];
            [button setTarget:bundle];
            [button setAction:@selector(defaultAction)];
            [[[self window] contentView] addSubview:button];
        }
    }
    
    
    // show the debug window
    [self showWindow:nil];
}

@end

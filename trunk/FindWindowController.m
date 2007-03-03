//
//  FindController.m
//  iTunesCheck
//
//  Created by StormSilver on 3/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "FindWindowController.h"


@implementation FindWindowController

static id sharedController;

+ (id) sharedController
{
    if (!sharedController)
    {
        [[self alloc] init];
    }
    
    return sharedController;
}

- (id) init
{
    if (!sharedController)
    {
        self = [super init];
        
        if (self)
        {
            [NSBundle loadNibNamed:@"Find" owner:self];
        }
        
        sharedController = self;
    }
    
    return sharedController;
}

- (void) awakeFromNib
{
    [[self window] center];
}

- (void) show
{
    [self showWindow:nil];
}

@end

//
//  FindController.m
//  iTunesCheck
//
//  Created by StormSilver on 3/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "FindWindowController.h"
#import "QuickPlayWindow.h"


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
            //[NSBundle loadNibNamed:@"Find" owner:self];
            _findWindow = [[QuickPlayWindow alloc] init];
        }
        
        sharedController = self;
    }
    
    return sharedController;
}

- (void) dealloc
{
    [_findWindow release];
    [super dealloc];
}
/*
- (void) awakeFromNib
{
    [[self window] center];
}
*/
- (void) show
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] 
                                stringByAppendingPathComponent:[NSString stringWithFormat:@"Views/%@/find.html", @"classic"]];
    //NSString *path = @"/Users/ssilver/Documents/Programs/iTCWebRenderTest/Views/classic/index.html";
    NSURL *url = [NSURL fileURLWithPath:path];
    NSMutableString *page = [NSMutableString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
    [_findWindow displayPage:page relativeTo:url];
}

@end

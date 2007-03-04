//
//  FindController.h
//  iTunesCheck
//
//  Created by StormSilver on 3/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class QuickPlayWindow;

@interface FindWindowController : NSObject
{
    QuickPlayWindow          *_findWindow;
}

+ (id) sharedController;

- (void) show;

@end

//
//  ApplicationController.h
//  iTunesCheck
//
//  Created by Eric Hankins on 12/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BundleController, PreferencesWindowController;

@interface ApplicationController : NSWindowController 
{
    BundleController *bundleController;
    PreferencesWindowController *preferencesWindowController;
}

@end

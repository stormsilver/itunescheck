//
//  HotKeyPreferencesController.h
//  iTunesCheck
//
//  Created by Eric Hankins on 12/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <iTCBundle/SS_PreferencePaneProtocol.h>

@interface HotKeyPreferencesController : NSObject <SS_PreferencePaneProtocol>
{
    IBOutlet NSView     *prefsView;
}

@end

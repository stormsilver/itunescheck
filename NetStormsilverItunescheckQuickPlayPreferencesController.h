//
//  NetStormsilverItunescheckQuickPlayPreferencesController.h
//  iTunesCheck
//
//  Created by Eric Hankins on 1/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <iTCBundle/SS_PreferencePaneProtocol.h>
#import "defines.h"


@interface QuickPlayPreferencesController : NSObject <SS_PreferencePaneProtocol>
{
    IBOutlet NSView     *prefsView;
}

@end

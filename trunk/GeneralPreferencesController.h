//
//  GeneralPreferencesController.h
//  iTunesCheck
//
//  Created by Eric Hankins on 12/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <iTCBundle/SS_PreferencePaneProtocol.h>

@interface GeneralPreferencesController : NSObject <SS_PreferencePaneProtocol>
{
    IBOutlet NSView     *prefsView;
    IBOutlet NSView     *aboutView;
    IBOutlet NSWindow   *window;
    IBOutlet NSTextField    *versionLabel;
    
    BOOL                aboutVisible;
}

- (IBAction) quitProgram:(id)sender;
- (IBAction) visitWebsite:(id)sender;
- (IBAction) about:(id)sender;

@end

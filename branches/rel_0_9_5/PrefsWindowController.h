//
//  PrefsWindowController.h
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/27/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PrefsWindowController : NSWindowController
{
    IBOutlet NSArrayController *_arrayController;
}

+ (id) sharedController;
- (void) show;

- (IBAction) quitProgram:(id)sender;
- (IBAction) visitWebsite:(id)sender;
- (IBAction) changeHotKey:(id)sender;
@end

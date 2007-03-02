//
//  ScriptController.h
//  iTCWebRenderTest
//
//  Created by StormSilver on 8/20/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ScriptController : NSObject
{
}

+ (id) sharedController;

- (NSString *) infoForTag:(NSString *)tag;
- (void) runHotKey:(id)sender;
- (NSAppleEventDescriptor *) runAppleScript:(NSString *)script;
@end

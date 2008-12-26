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

- (NSAppleEventDescriptor *) searchFor:(NSString *)search inPlaylist:(NSString *)playlist;
- (void) playSongWithID:(NSString *)songID;

- (NSAppleEventDescriptor *) runAppleScriptFromString:(NSString *)script;
- (NSAppleEventDescriptor *) runAppleScript:(NSString *)script;
@end

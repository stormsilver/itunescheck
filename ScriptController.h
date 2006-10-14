//
//  ScriptController.h
//  iTunesCheck
//
//  Created by StormSilver on 9/1/04.
//  Copyright 2004 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ScriptController : NSObject
{
    NSAppleScript *ps;
    NSAppleScript *playing;
}

+ (id) sharedController;

- (BOOL) iTunesRunning;
- (BOOL) iTunesPlaying;
- (int) iTunesState;

- (void) launchiTunes:(id)sender;

- (NSAppleEventDescriptor *) doAppleScript:(NSString *)script;
- (NSAppleEventDescriptor *) search:(NSString *)search inPlaylist:(NSString *)playlist;

@end

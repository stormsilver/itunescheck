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
    QuickPlayWindow         *_findWindow;
    NSMutableDictionary     *_playlists;
}

+ (id) sharedController;

- (void) show;
- (void) close;

- (NSArray *) resultsForSearch:(NSString *)search inPlaylist:(NSString *)playlist;
- (NSArray *) playlists;
- (void) resize;
- (void) playSong:(NSString *)path;

@end
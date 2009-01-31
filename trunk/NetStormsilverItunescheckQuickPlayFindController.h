//
//  NetStormsilverItunescheckQuickPlayFindController.h
//  iTunesCheck
//
//  Created by Eric Hankins on 1/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <iTCBundle/iTC.h>
#include "defines.h"

@interface FindController : AbstractBundle
{
    WebViewWindowController     *windowController;
    NSMutableDictionary         *playlists;
    NSMutableDictionary         *lastSearchResults;
}

- (void) displayBundle:(NSBundle *)bundle view:(NSString *)view;

- (NSArray *) resultsForSearch:(NSString *)search inPlaylist:(NSString *)playlistName;
- (NSArray *) playlists;
- (void) resize;
- (void) playSong:(NSString *)idString;
- (void) close;

@end

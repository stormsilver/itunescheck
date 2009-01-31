//
//  NetStormsilverItunescheckBasichotkeysBasicController.m
//  iTunesCheck
//
//  Created by Eric Hankins on 1/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NetStormsilverItunescheckBasichotkeysBasicController.h"

@implementation BasicController
- (id) init
{
    self = [super init];
    if (self != nil)
    {
    }
    return self;
}

- (void) finishLoading
{
    NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithIdentifier:bundleIdentifier] pathForResource:@"InfoWindowDefaults" ofType:@"plist"]];
    if (defaultPrefs)
    {
        [preferencesController setPreferences:defaultPrefs forBundle:bundleIdentifier];
    }
    
    [preferencesController setTarget:self forHotKeyNamed:@"Increment Play Count" withKeyCode:37 andModifiers:2304];
    [preferencesController setTarget:self forHotKeyNamed:@"Next Song" withKeyCode:124 andModifiers:2304];
    [preferencesController setTarget:self forHotKeyNamed:@"Previous Song" withKeyCode:123 andModifiers:2304];
    [preferencesController setTarget:self forHotKeyNamed:@"Play / Pause" withKeyCode:49 andModifiers:2304];
    [preferencesController setTarget:self forHotKeyNamed:@"Rate Song 0 ()" withKeyCode:29 andModifiers:2304];
    [preferencesController setTarget:self forHotKeyNamed:@"Rate Song 1 (★)" withKeyCode:18 andModifiers:2304];
    [preferencesController setTarget:self forHotKeyNamed:@"Rate Song 2 (★★)" withKeyCode:19 andModifiers:2304];
    [preferencesController setTarget:self forHotKeyNamed:@"Rate Song 3 (★★★)" withKeyCode:20 andModifiers:2304];
    [preferencesController setTarget:self forHotKeyNamed:@"Rate Song 4 (★★★★)" withKeyCode:21 andModifiers:2304];
    [preferencesController setTarget:self forHotKeyNamed:@"Rate Song 5 (★★★★★)" withKeyCode:23 andModifiers:2304];
    [preferencesController setTarget:self forHotKeyNamed:@"Show Current Song" withKeyCode:37 andModifiers:2304];
}

- (NSString *) shortName
{
    return @"Basic Hot Keys";
}

- (BOOL) isHotKeyBundle
{
    return YES;
}

- (BOOL) defaultAction
{
    return NO;
}

- (void) incrementPlayCountHotKey
{
    int currentCount = [[iTunes currentTrack] playedCount];
    [[iTunes currentTrack] setPlayedCount:currentCount + 1];
}

- (void) nextSongHotKey
{
    [iTunes nextTrack];
}
- (void) previousSongHotKey
{
    [iTunes backTrack];
}

- (void) playPauseHotKey
{
    [iTunes playpause];
}

- (void) rateSong0HotKey
{
    [[iTunes currentTrack] setRating:0];
}
- (void) rateSong1HotKey
{
    [[iTunes currentTrack] setRating:20];
}
- (void) rateSong2HotKey
{
    [[iTunes currentTrack] setRating:40];
}
- (void) rateSong3HotKey
{
    [[iTunes currentTrack] setRating:60];
}
- (void) rateSong4HotKey
{
    [[iTunes currentTrack] setRating:80];
}
- (void) rateSong5HotKey
{
    [[iTunes currentTrack] setRating:100];
}

- (void) showCurrentSongHotKey
{
    [[iTunes currentTrack] reveal];
    [iTunes activate];
}


@end

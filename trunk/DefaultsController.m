//
//  DefaultsController.m
//  iTunesCheck
//
//  Created by Eric Hankins on 1/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DefaultsController.h"


@implementation DefaultsController

- (id)valueForKey:(NSString *)key
{
    NSLog(@"value forkey: %@", key);
    return [super valueForKey:key];
}

- (id)valueForKeyPath:(NSString *)keyPath
{
    NSLog(@"value for key path: %@", keyPath);
//    return [super valueForKeyPath:keyPath];
    id rval = [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKeyPath:keyPath];
    NSLog(@"returning: %@", rval);
    return rval;
}

- (id) preferences
{
    NSLog(@"preferences");
    return [[NSUserDefaultsController sharedUserDefaultsController] values];
}

@end

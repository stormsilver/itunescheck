//
//  BooleanColorTransformer.m
//  iTunesCheck
//
//  Created by StormSilver on Fri Aug 06 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import "BooleanColorTransformer.h"


@implementation BooleanColorTransformer

+ (Class) transformedValueClass
{
    return [NSColor class];
}

+ (BOOL) allowsReverseTransformation
{
    return NO;
}

- (id) transformedValue:(id)value
{
    if ([value boolValue])
    {
        return [NSColor blackColor];
    } else
    {
        return [NSColor grayColor];
    }
}

@end

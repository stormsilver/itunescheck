//
//  NotThreeTransformer.m
//  iTunesCheck
//
//  Created by Eric Hankins on 1/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NotThreeTransformer.h"


@implementation NotThreeTransformer

+ (Class) transformedValueClass
{
    return [NSNumber class];
}

+ (BOOL) allowsReverseTransformation
{
    return NO;
}

- (id) transformedValue:(id)value
{
    if ([value intValue] != 2)
    {
        return [NSNumber numberWithBool:NO];
    }
    else
    {
        return [NSNumber numberWithBool:YES];
    }
}

@end

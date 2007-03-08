//
//  RoundedNumberTransformer.m
//  iTunesCheck
//
//  Created by StormSilver on Thu Jul 29 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import "RoundedNumberTransformer.h"


@implementation RoundedNumberTransformer

+ (Class) transformedValueClass
{
    return [NSString class];
}

+ (BOOL) allowsReverseTransformation
{
    return NO;
}

- (id) transformedValue:(id)value
{
    if (value == nil)
    {
        return nil;
    }
    
    NSString *ret;
    float unRoundedValue = 0.0;
    if ([value respondsToSelector:@selector(floatValue)])
    {
        unRoundedValue = [value floatValue];
    } else {
        [NSException raise:NSInternalInconsistencyException format:@"Value (%@) does not respond to -floatValue", [value class]];
        return nil;
    }

    ret = [NSString stringWithFormat:@"%i second%@", (int)round(unRoundedValue), ((int)round(unRoundedValue) == 1 ? @"" : @"s")];\
    
    return ret;
}

@end

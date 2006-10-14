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
    }
    
    switch (type)
    {
        case 0:
            if (unRoundedValue < 0.125)
            {
                ret = @"Molasses";
            } else if ((unRoundedValue >= 0.125) && (unRoundedValue < 0.25))
            {
                ret = @"Very Slow";
            } else if ((unRoundedValue >= 0.25) && (unRoundedValue < 0.375))
            {
                ret = @"Pretty Slow";
            } else if ((unRoundedValue >= 0.375) && (unRoundedValue < 0.5))
            {
                ret = @"Slowish";
            } else if ((unRoundedValue >= 0.5) && (unRoundedValue < 0.625))
            {
                ret = @"Fastish";
            } else if ((unRoundedValue >= 0.625) && (unRoundedValue < 0.750))
            {
                ret = @"Pretty Fast";
            } else if ((unRoundedValue >= 0.750) && (unRoundedValue < 0.875))
            {
                ret = @"Very Fast";
            } else 
            {
                ret = @"Speedy Gonzales";
            }
            break;
        
        case 1:
            /*
            if ((unRoundedValue < 0) || ((unRoundedValue > 0) && (unRoundedValue < 0.125)))
            {
                ret = @"Extremely Short";
            } else if ((unRoundedValue > 0.125) && (unRoundedValue < 0.25))
            {
                ret = @"";
            } else if ((unRoundedValue > 0.25) && (unRoundedValue < 0.375))
            {
                ret = @"";
            } else if ((unRoundedValue > 0.375) && (unRoundedValue < 0.5))
            {
                ret = @"";
            } else if ((unRoundedValue > 0.5) && (unRoundedValue < 0.625))
            {
                ret = @"";
            } else if ((unRoundedValue > 0.625) && (unRoundedValue < 0.750))
            {
                ret = @"";
            } else if ((unRoundedValue > 0.750) && (unRoundedValue < 0.875))
            {
                ret = @"";
            } else 
            {
                ret = @"Forever";
            }
            break;
             */
            
        case 2:
            /*
            if ((unRoundedValue < 0) || ((unRoundedValue > 0) && (unRoundedValue < 5)))
            {
                ret = @"Constantly";
            } else if ((unRoundedValue > 5) && (unRoundedValue < 10))
            {
                ret = @"Often";
            } else if ((unRoundedValue > 10) && (unRoundedValue < 15))
            {
                ret = @"Seldom";
            } else 
            {
                ret = @"Almost Never";
            }
             */
            //ret = [NSString stringWithFormat:@"%i.%i seconds", ((int)(unRoundedValue))%10, ((int)(unRoundedValue*10.0))%10];
            //int rounded = (int)round(unRoundedValue);
            ret = [NSString stringWithFormat:@"%i second%@", (int)round(unRoundedValue), ((int)round(unRoundedValue) == 1 ? @"" : @"s")];
            break;
        
        default:
            ret = [[NSNumber numberWithFloat:((int)(unRoundedValue*10.0)/10.0)] stringValue];
    }
    
    return ret;
}

- (void) setType:(int)newType
{
    type = newType;
}

@end

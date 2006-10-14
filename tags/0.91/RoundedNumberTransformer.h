//
//  RoundedNumberTransformer.h
//  iTunesCheck
//
//  Created by StormSilver on Thu Jul 29 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RoundedNumberTransformer : NSValueTransformer
{
    int type;
}

- (void) setType:(int)newType;

@end

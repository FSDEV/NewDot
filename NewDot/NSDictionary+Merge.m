//
//  NSDictionary+Merge.m
//  NewDot
//
//  Created by Christopher Miller on 9/27/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NSDictionary+Merge.h"

@implementation NSDictionary (Merge)

- (NSDictionary *)fs_dictionaryByMergingDictionary:(NSDictionary *)aDict
{
    NSMutableDictionary * mutableSelf = [self mutableCopy];
    
    for (id key in aDict)
        [mutableSelf setObject:[aDict objectForKey:key] forKey:key];
    
    return [NSDictionary dictionaryWithDictionary:mutableSelf];
}

@end

//
//  NDService+Implementation.m
//  NewDot
//
//  Created by Christopher Miller on 10/31/11.
//  Copyright (c) 2011 FSDEV. All rights reserved.
//

#import "NDService+Implementation.h"

@implementation NDService (Implementation)

- (NSMutableDictionary*)copyOfDefaultURLParametersWithSessionId
{
    NSMutableDictionary* toReturn = [self.defaultURLParameters mutableCopy];
    if (self.sessionId) [toReturn setObject:self.sessionId forKey:@"sessionId"];
    return toReturn;
}

- (NSMutableURLRequest*)standardRequestForURL:(NSURL*)url HTTPMethod:(NSString*)method
{
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] initWithURL:url];
    [req setHTTPMethod:method];
    [req addValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    return req;
}

- (NSJSONWritingOptions)jsonWritingOptions
{
#ifdef DEBUG
    return NSJSONWritingPrettyPrinted;
#else
    return 0;
#endif
}

@end

NSArray * NDCoalesceUnknownToArray(id unknown) {
    if (unknown==nil) return [NSArray array];
    else if ([unknown isKindOfClass:[NSArray class]]) return unknown;
    else if ([unknown isKindOfClass:[NSSet class]]||[unknown isKindOfClass:[NSOrderedSet class]]) return [unknown allObjects];
    else return [NSArray arrayWithObject:unknown];
}

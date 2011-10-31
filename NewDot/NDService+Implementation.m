//
//  NDService+Implementation.m
//  NewDot
//
//  Created by Christopher Miller on 10/31/11.
//  Copyright (c) 2011 FSDEV. All rights reserved.
//

#import "NDService+Implementation.h"

@implementation NDService (Implementation)

- (NSMutableURLRequest*)standardRequestForURL:(NSURL*)url HTTPMethod:(NSString*)method
{
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] initWithURL:url];
    [req setHTTPMethod:method];
    [req addValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
    return [req autorelease];
}

@end
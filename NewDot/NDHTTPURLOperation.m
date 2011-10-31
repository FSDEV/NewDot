//
//  NDHTTPURLOperation.m
//  NewDot
//
//  Created by Christopher Miller on 10/31/11.
//  Copyright (c) 2011 FSDEV. All rights reserved.
//

#import "NDHTTPURLOperation.h"

@implementation NDHTTPURLOperation

@synthesize request;
@synthesize response;

- (id)initWithRequest:(NSURLRequest *)_request
{
    self = [super init];
    if (self) {
        request = [_request retain];
    }
    return self;
}

- (void)dealloc
{
    [request release];
    [response release];
    
    [super dealloc];
}

@end

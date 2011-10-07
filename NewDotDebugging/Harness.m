//
//  Harness.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "Harness.h"

@implementation Harness

@synthesize username;
@synthesize password;
@synthesize serverLocation;
@synthesize apiKey;


- (void)testWithUsername:(NSString *)u password:(NSString *)p serverLocation:(NSString *)s apiKey:(NSString *)a
{
    self.username = u;
    self.password = p;
    self.serverLocation = s;
    self.apiKey = a;
}

- (void)test
{
    [NSException raise:@"Virtual Function Called" format:@"I'M PURE VIRTUAL, CAN'T YOU SEEE!!! NO CODE HERE!!!"];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    if (self) {
    
    }
    
    return self;
}

- (void)dealloc
{
    self.username = nil;
    self.password = nil;
    self.serverLocation = nil;
    self.apiKey = nil;
    
    [super dealloc];
}

@end

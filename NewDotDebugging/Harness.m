//
//  Harness.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "Harness.h"

@implementation Harness

@synthesize properties;
@synthesize testCredentials;

- (void)test
{
    [NSException raise:@"Virtual Function Called" format:@"I'M PURE VIRTUAL, CAN'T YOU SEEE!!! NO CODE HERE!!!"];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    if (self) {
        NSString * error;
        self.properties = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DeveloperKeys"
                                                                                                                                           ofType:@"PLIST"]]
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:&error];
        
        self.testCredentials = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TestCredentials" ofType:@"PLIST"]]
                                                                mutabilityOption:NSPropertyListImmutable
                                                                          format:NULL
                                                                errorDescription:&error];
    }
    
    return self;
}

- (void)dealloc
{
    self.properties = nil;
    self.testCredentials = nil;
    
    [super dealloc];
}

@end

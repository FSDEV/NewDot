//
//  NDService.m
//  NewDot
//
//  Created by Christopher Miller on 9/23/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService.h"

@implementation NDService

@synthesize serverUrl;
@synthesize sessionId;
@synthesize userAgent;
@synthesize defaultURLParameters;
@synthesize operationQueue;

- (id)initWithBaseURL:(NSURL*)newServerUrl
            userAgent:(NSString*)newUserAgent
{
    self = [self init];
    if (self) {
        serverUrl = newServerUrl;
        
        if ([newServerUrl class] != [NSURL class]) {
            NSLog(@"[NewDot] WARNING! Your Base URL is NOT of class NSURL! This can cause some annoying bugs!");
        }
        
        self.userAgent = newUserAgent;
    }
    
    return self;
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    if (self) {
        self.defaultURLParameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"application/json", @"dataFormat", nil];
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 4;
    }
    
    return self;
}

@end

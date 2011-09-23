//
//  NDService.m
//  NewDot
//
//  Created by Christopher Miller on 9/23/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService.h"

#import "AFHTTPClient.h"

@implementation NDService

- (NSURL *)serverUrl
{
    return self.client.baseURL;
}

- (NSString *)userAgent
{
    return [self.client defaultValueForHeader:@"User-Agent"];
}

- (void)setUserAgent:(NSString *)userAgent
{
    [self.client setDefaultHeader:@"User-Agent" value:userAgent];
}

@synthesize apiKey;
@synthesize sessionId;
@synthesize client;

- (id)initWithBaseURL:(NSURL *)newServerUrl
               apiKey:(NSString *)newApiKey
            userAgent:(NSString *)newUserAgent
{
    self = [self init];
    if (self) {
        self->client = [[AFHTTPClient alloc] initWithBaseURL:newServerUrl];
        self.apiKey = newApiKey;
        self.userAgent = newUserAgent;
        
        [self.client setDefaultHeader:@"User-Agent" value:self.userAgent];
    }
    
    return self;
}

- (id)initWithBaseURL:(NSURL *)newServerUrl
{
    return [self initWithBaseURL:newServerUrl apiKey:nil userAgent:@"NewDot/0.1"];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    self.apiKey = nil;
    self.sessionId = nil;
    self.userAgent = nil;
    self.client = nil;
    
    [super dealloc];
}

@end

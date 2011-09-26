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

//- (NSString *)sessionId
//{
//    return [self.client defaultValueForHeader:@"sessionId"];
//}
//
//- (void)setSessionId:(NSString *)sessionId
//{
//    [self.client setDefaultHeader:@"sessionId" value:sessionId];
//}

@synthesize apiKey;
@synthesize client;
@synthesize sessionId;
@synthesize defaultURLParameters;

- (id)initWithBaseURL:(NSURL *)newServerUrl
               apiKey:(NSString *)newApiKey
            userAgent:(NSString *)newUserAgent
{
    self = [self init];
    if (self) {
        self->client = [[AFHTTPClient alloc] initWithBaseURL:newServerUrl];
        self.apiKey = newApiKey;
        self.userAgent = newUserAgent;
    }
    
    return self;
}

- (NSMutableDictionary *)copyOfDefaultURLParametersWithSessionId
{
    NSMutableDictionary * toReturn = [self.defaultURLParameters mutableCopy];
    [toReturn setObject:self.sessionId forKey:@"sessionId"];
    return toReturn;
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    if (self) {
        self.defaultURLParameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"application/json", @"dataFormat", nil];
    }
    
    return self;
}

- (void)dealloc
{
    self.apiKey = nil;
    self.sessionId = nil;
    self.client = nil;
    self.defaultURLParameters = nil;
    
    [super dealloc];
}

@end

//
//  NDService.m
//  NewDot
//
//  Created by Christopher Miller on 9/23/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService.h"

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@implementation NDService

- (NSURL*)serverUrl
{
    return self.client.baseURL;
}

- (NSString*)userAgent
{
    return [self.client defaultValueForHeader:@"User-Agent"];
}

- (void)setUserAgent:(NSString*)userAgent
{
    [self.client setDefaultHeader:@"User-Agent" value:(userAgent)?:@"NewDot/0.1"];
}

@synthesize client;
@synthesize sessionId;
@synthesize defaultURLParameters;

- (id)initWithBaseURL:(NSURL*)newServerUrl
            userAgent:(NSString*)newUserAgent
{
    self = [self init];
    if (self) {
        self.client = [[[AFHTTPClient alloc] initWithBaseURL:newServerUrl] autorelease];
        [self.client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        self.userAgent = newUserAgent;
    }
    
    return self;
}

- (NSMutableDictionary*)copyOfDefaultURLParametersWithSessionId
{
    NSMutableDictionary* toReturn = [self.defaultURLParameters mutableCopy];
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
    self.sessionId = nil;
    self.client = nil;
    self.defaultURLParameters = nil;
    
    [super dealloc];
}

@end

//
//  NDService.h
//  NewDot
//
//  Created by Christopher Miller on 9/23/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPClient;

typedef void(^NDGenericSuccessBlock)(id response);
typedef void(^NDGenericFailureBlock)(NSError * error);

/**
 * Service-layer interface for dealing with New(DOT)FamilySearch.
 */
@interface NDService : NSObject

@property (readonly) NSURL * serverUrl;
@property (readwrite, retain) NSString * apiKey;
@property (readwrite, retain) NSString * sessionId;
@property (readwrite, retain) NSString * userAgent;
@property (readwrite, retain) AFHTTPClient * client;
@property (readwrite, retain) NSMutableDictionary * defaultURLParameters;

- (id)initWithBaseURL:(NSURL *)newServerUrl
               apiKey:(NSString *)newApiKey
            userAgent:(NSString *)newUserAgent;

- (NSMutableDictionary *)copyOfDefaultURLParametersWithSessionId;

@end

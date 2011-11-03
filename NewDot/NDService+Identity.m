//
//  NDService+Identity.m
//  NewDot
//
//  Created by Christopher Miller on 9/23/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService+Identity.h"
#import "NDService+Implementation.h"

#import "NDHTTPURLOperation.h"

#import "JSONKit.h"

#import "NSString+LastWord.h"
#import "NSURL+QueryStringConstructor.h"
#import "NSString+Base64.h"

@implementation NDService (Identity)

#pragma mark Session Create

- (NDHTTPURLOperation*)identityOperationCreateSessionForUser:(NSString*)username
                                                withPassword:(NSString*)password
                                                      apiKey:(NSString*)apiKey
                                                   onSuccess:(NDSuccessBlock)success
                                                   onFailure:(NDFailureBlock)failure
{
    NSMutableDictionary* urlParameters = [self.defaultURLParameters mutableCopy];
    [urlParameters setObject:apiKey forKey:@"key"];
    NSURL* url = [NSURL URLWithString:@"/identity/v2/login" relativeToURL:self.serverUrl queryParameters:[urlParameters autorelease]];
    
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [req addValue:[NSString stringWithFormat:@"Basic %@", [NSString fs_encodeBase64WithString:[NSString stringWithFormat:@"%@:%@", username, password]]] forHTTPHeaderField:@"Authorization"];
    //    [req addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NDHTTPURLOperation* oper = 
    [NDHTTPURLOperation HTTPURLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else {
            id parsed_payload = [[JSONDecoder decoder] objectWithData:payload];
            self.sessionId = [parsed_payload valueForKeyPath:@"session.id"];
            if (success) success(resp, parsed_payload, payload);
        }
    }];
    
    return oper;
}

- (void)identityCreateSessionForUser:(NSString*)username
                        withPassword:(NSString*)password
                              apiKey:(NSString*)apiKey
                           onSuccess:(NDSuccessBlock)success
                           onFailure:(NDFailureBlock)failure
{
    [[self operationQueue] addOperation:[self identityOperationCreateSessionForUser:username
                                                                       withPassword:password
                                                                             apiKey:apiKey
                                                                          onSuccess:success
                                                                          onFailure:failure]];
}

#pragma mark Session Read

- (NDHTTPURLOperation*)identityOperationSessionOnSuccess:(NDSuccessBlock)success
                                               onFailure:(NDFailureBlock)failure
{
    NSDictionary* params = [self copyOfDefaultURLParametersWithSessionId];
    NSURL* url = [NSURL URLWithString:@"/identity/v2/session/" relativeToURL:self.serverUrl queryParameters:[params autorelease]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    NDHTTPURLOperation* oper =
    [NDHTTPURLOperation HTTPURLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success) success(resp, [[JSONDecoder decoder] objectWithData:payload], payload);
    }];
    
    return oper;
}

- (void)identitySessionOnSuccess:(NDSuccessBlock)success
                       onFailure:(NDFailureBlock)failure
{
    [[self operationQueue] addOperation:[self identityOperationSessionOnSuccess:success
                                                                      onFailure:failure]];
}

#pragma mark User Profile

- (NDHTTPURLOperation*)identityOperationUserProfileOnSuccess:(NDSuccessBlock)success
                                                   onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL URLWithString:@"/identity/v2/user" relativeToURL:self.serverUrl queryParameters:[[self copyOfDefaultURLParametersWithSessionId] autorelease]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    NDHTTPURLOperation* oper =
    [NDHTTPURLOperation HTTPURLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success) success(resp, [[JSONDecoder decoder] objectWithData:payload], payload);
    }];
    
    return oper;
}

- (void)identityUserProfileOnSuccess:(NDSuccessBlock)success
                           onFailure:(NDFailureBlock)failure
{
    [[self operationQueue] addOperation:[self identityOperationUserProfileOnSuccess:success
                                                                          onFailure:failure]];
}

#pragma mark User Permissions

- (NDHTTPURLOperation*)identityOperationUserPermissionsOnSuccess:(NDSuccessBlock)success
                                                       onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL URLWithString:@"/identity/v2/permission" relativeToURL:self.serverUrl queryParameters:[[self copyOfDefaultURLParametersWithSessionId] autorelease]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    NDHTTPURLOperation* oper =
    [NDHTTPURLOperation HTTPURLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success) success(resp, [[JSONDecoder decoder] objectWithData:payload], payload);
    }];
    
    return oper;
}

- (void)identityUserPermissionsOnSuccess:(NDSuccessBlock)success
                               onFailure:(NDFailureBlock)failure
{
    [[self operationQueue] addOperation:[self identityOperationUserPermissionsOnSuccess:success
                                                                              onFailure:failure]];
}

#pragma mark Destroy Session

- (NDHTTPURLOperation*)identityOperationDestroySessionOnSuccess:(NDSuccessBlock)success
                                                      onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL URLWithString:@"/identity/v2/logout" relativeToURL:self.serverUrl queryParameters:[[self copyOfDefaultURLParametersWithSessionId] autorelease]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    NDHTTPURLOperation* oper =
    [NDHTTPURLOperation HTTPURLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else {
            self.sessionId = nil;
            if (success) success(resp, [[JSONDecoder decoder] objectWithData:payload], payload);
        }
    }];
    
    return oper;
}

- (void)identityDestroySessionOnSuccess:(NDSuccessBlock)success
                              onFailure:(NDFailureBlock)failure
{
    [[self operationQueue] addOperation:[self identityOperationDestroySessionOnSuccess:success
                                                                             onFailure:failure]];
}

@end

//
//  NDService+Identity.m
//  NewDot
//
//  Created by Christopher Miller on 9/23/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService+Identity.h"
#import "NDService+Implementation.h"

#import "FSURLOperation.h"

#import "NSString+LastWord.h"
#import "NSURL+QueryStringConstructor.h"
#import "NSString+Base64.h"

@implementation NDService (Identity)

#pragma mark Session Create

- (NSURLRequest*)identityRequestCreateSessionForUser:(NSString*)username
                                        withPassword:(NSString*)password
                                              apiKey:(NSString*)apiKey
{
    NSMutableDictionary* urlParameters = [self.defaultURLParameters mutableCopy];
    [urlParameters setObject:apiKey forKey:@"key"];
    NSURL* url = [NSURL URLWithString:@"/identity/v2/login" relativeToURL:self.serverUrl queryParameters:urlParameters];
    
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [req addValue:[NSString stringWithFormat:@"Basic %@", [NSString fs_encodeBase64WithString:[NSString stringWithFormat:@"%@:%@", username, password]]] forHTTPHeaderField:@"Authorization"];
    //    [req addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    return req;
}

- (FSURLOperation*)identityOperationCreateSessionForUser:(NSString*)username
                                            withPassword:(NSString*)password
                                                  apiKey:(NSString*)apiKey
                                               onSuccess:(NDSuccessBlock)success
                                               onFailure:(NDFailureBlock)failure
                                        withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self identityRequestCreateSessionForUser:username withPassword:password apiKey:apiKey];
    
    FSURLOperation* oper = 
    [FSURLOperation URLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else {
            NSError* err=nil;
            id _payload = [NSJSONSerialization JSONObjectWithData:payload options:kNilOptions error:&err];
            if (err&&failure) failure(resp, payload, err);
            self.sessionId = [_payload valueForKeyPath:@"session.id"];
            if (success) success(resp, _payload, payload);
        }
    } onThread:thread];
    
    return oper;
}

- (FSURLOperation*)identityOperationCreateSessionForUser:(NSString*)username
                                            withPassword:(NSString*)password
                                                  apiKey:(NSString*)apiKey
                                               onSuccess:(NDSuccessBlock)success
                                               onFailure:(NDFailureBlock)failure
{
    return [self identityOperationCreateSessionForUser:username withPassword:password apiKey:apiKey onSuccess:success onFailure:failure withTargetThread:nil];
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
                                                                          onFailure:failure
                                                                   withTargetThread:nil]];
}

#pragma mark Session Read

- (NSURLRequest*)identityRequestSession
{
    NSDictionary* params = [self copyOfDefaultURLParametersWithSessionId];
    NSURL* url = [NSURL URLWithString:@"/identity/v2/session/" relativeToURL:self.serverUrl queryParameters:params];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    return req;
}

- (FSURLOperation*)identityOperationSessionOnSuccess:(NDSuccessBlock)success
                                           onFailure:(NDFailureBlock)failure
                                    withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self identityRequestSession];
    
    FSURLOperation* oper =
    [FSURLOperation URLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success) {
            NSError* err=nil;
            id _payload = [NSJSONSerialization JSONObjectWithData:payload options:kNilOptions error:&err];
            if (!err) success(resp, _payload, payload);
            else if (failure) failure(resp, payload, err);
        }
    } onThread:thread];
    
    return oper;
}

- (FSURLOperation*)identityOperationSessionOnSuccess:(NDSuccessBlock)success
                                           onFailure:(NDFailureBlock)failure
{
    return [self identityOperationSessionOnSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)identitySessionOnSuccess:(NDSuccessBlock)success
                       onFailure:(NDFailureBlock)failure
{
    [[self operationQueue] addOperation:[self identityOperationSessionOnSuccess:success
                                                                      onFailure:failure
                                                               withTargetThread:nil]];
}

#pragma mark User Profile

- (NSURLRequest*)identityRequestUserProfile
{
    NSURL* url = [NSURL URLWithString:@"/identity/v2/user" relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    return req;
}

- (FSURLOperation*)identityOperationUserProfileOnSuccess:(NDSuccessBlock)success
                                               onFailure:(NDFailureBlock)failure
                                        withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self identityRequestUserProfile];
    
    FSURLOperation* oper =
    [FSURLOperation URLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success) {
            NSError* err=nil;
            id _payload = [NSJSONSerialization JSONObjectWithData:payload options:kNilOptions error:&err];
            if (!err) success(resp, _payload, payload);
            else if (failure) failure(resp, payload, err);
        }
    } onThread:thread];
    
    return oper;
}

- (FSURLOperation*)identityOperationUserProfileOnSuccess:(NDSuccessBlock)success
                                               onFailure:(NDFailureBlock)failure
{
    return [self identityOperationUserProfileOnSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)identityUserProfileOnSuccess:(NDSuccessBlock)success
                           onFailure:(NDFailureBlock)failure
{
    [[self operationQueue] addOperation:[self identityOperationUserProfileOnSuccess:success
                                                                          onFailure:failure]];
}

#pragma mark User Permissions

- (NSURLRequest*)identityRequestUserPermissions
{
    NSURL* url = [NSURL URLWithString:@"/identity/v2/permission" relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    return req;
}

- (FSURLOperation*)identityOperationUserPermissionsOnSuccess:(NDSuccessBlock)success
                                                   onFailure:(NDFailureBlock)failure
                                            withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self identityRequestUserPermissions];
    
    FSURLOperation* oper =
    [FSURLOperation URLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success) {
            NSError* err=nil;
            id _payload = [NSJSONSerialization JSONObjectWithData:payload options:kNilOptions error:&err];
            if (!err) success(resp, _payload, payload);
            else if (failure) failure(resp, payload, err);
        }
    } onThread:thread];
    
    return oper;
}

- (FSURLOperation*)identityOperationUserPermissionsOnSuccess:(NDSuccessBlock)success
                                                   onFailure:(NDFailureBlock)failure
{
    return [self identityOperationUserProfileOnSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)identityUserPermissionsOnSuccess:(NDSuccessBlock)success
                               onFailure:(NDFailureBlock)failure
{
    [[self operationQueue] addOperation:[self identityOperationUserPermissionsOnSuccess:success
                                                                              onFailure:failure]];
}

#pragma mark Destroy Session

- (NSURLRequest*)identityRequestDestroySession
{
    NSURL* url = [NSURL URLWithString:@"/identity/v2/logout" relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    return req;
}

- (FSURLOperation*)identityOperationDestroySessionOnSuccess:(NDSuccessBlock)success
                                                  onFailure:(NDFailureBlock)failure
                                           withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self identityRequestDestroySession];
    
    FSURLOperation* oper =
    [FSURLOperation URLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success) {
            self.sessionId = nil;
            NSError* err=nil;
            id _payload = [NSJSONSerialization JSONObjectWithData:payload options:kNilOptions error:&err];
            if (!err) success(resp, _payload, payload);
            else if (failure) failure(resp, payload, err);
        }
    } onThread:thread];
    
    return oper;
}

- (FSURLOperation*)identityOperationDestroySessionOnSuccess:(NDSuccessBlock)success
                                                  onFailure:(NDFailureBlock)failure
{
    return [self identityOperationDestroySessionOnSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)identityDestroySessionOnSuccess:(NDSuccessBlock)success
                              onFailure:(NDFailureBlock)failure
{
    [[self operationQueue] addOperation:[self identityOperationDestroySessionOnSuccess:success
                                                                             onFailure:failure
                                                                      withTargetThread:nil]];
}

@end

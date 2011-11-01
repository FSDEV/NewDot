//
//  NDService+Identity.m
//  NewDot
//
//  Created by Christopher Miller on 9/23/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService+Identity.h"
#import "NDService+Implementation.h"

#import "JSONKit.h"

#import "NSString+LastWord.h"
#import "NSURL+QueryStringConstructor.h"
#import "NSString+Base64.h"

@implementation NDService (Identity)

- (void)identityCreateSessionForUser:(NSString*)username
                        withPassword:(NSString*)password
                              apiKey:(NSString*)apiKey
                           onSuccess:(NDSuccessBlock)success
                           onFailure:(NDFailureBlock)failure
{
    NSMutableDictionary* urlParameters = [self.defaultURLParameters mutableCopy];
    [urlParameters setObject:apiKey forKey:@"key"];
    NSURL* url = [NSURL fs_URLWithString:@"/identity/v2/login" relativeToURL:self.serverUrl queryParameters:[urlParameters autorelease]];
    
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [req addValue:[NSString stringWithFormat:@"Basic %@", [NSString fs_encodeBase64WithString:[NSString stringWithFormat:@"%@:%@", username, password]]] forHTTPHeaderField:@"Authorization"];
//    [req addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
                               NSHTTPURLResponse* _resp = (NSHTTPURLResponse*)resp;
                               if (asplosion||[_resp statusCode]!=200) {
                                   if (failure) failure(_resp, payload, asplosion);
                               } else {
                                   id parsed_payload = [[JSONDecoder decoder] objectWithData:payload];
                                   self.sessionId = [parsed_payload valueForKeyPath:@"session.id"];
                                   if (success) success(_resp, parsed_payload, payload);
                               }
                           }];
}

- (void)identitySessionOnSuccess:(NDSuccessBlock)success
                       onFailure:(NDFailureBlock)failure
{
    NSDictionary* params = [self copyOfDefaultURLParametersWithSessionId];
    NSURL* url = [NSURL fs_URLWithString:@"/identity/v2/session/" relativeToURL:self.serverUrl queryParameters:params];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
                               NSHTTPURLResponse* _resp = (NSHTTPURLResponse*)resp;
                               if (asplosion||[_resp statusCode]!=200) {
                                   if (failure) failure(_resp, payload, asplosion);
                               } else if (success) success(_resp, [[JSONDecoder decoder] objectWithData:payload], payload);
                           }];
}

- (void)identityUserProfileOnSuccess:(NDSuccessBlock)success
                           onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL fs_URLWithString:@"/identity/v2/user" relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
        NSHTTPURLResponse* _resp = (NSHTTPURLResponse*)resp;
        if (asplosion||[_resp statusCode]!=200) {
            if (failure) failure(_resp, payload, asplosion);
        } else if (success) success(_resp, [[JSONDecoder decoder] objectWithData:payload], payload);
    }];
}

- (void)identityUserPermissionsOnSuccess:(NDSuccessBlock)success
                               onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL fs_URLWithString:@"/identity/v2/permission" relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
        NSHTTPURLResponse* _resp = (NSHTTPURLResponse*)resp;
        if (asplosion||[_resp statusCode]!=200) {
            if (failure) failure(_resp, payload, asplosion);
        } else if (success) success(_resp, [[JSONDecoder decoder] objectWithData:payload], payload);
    }];
}

- (void)identityDestroySessionOnSuccess:(NDSuccessBlock)success
                              onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL fs_URLWithString:@"/identity/v2/logout" relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
        NSHTTPURLResponse* _resp = (NSHTTPURLResponse*)resp;
        if (asplosion||[_resp statusCode]!=200) {
            if (failure) failure(_resp, payload, asplosion);
        } else {
            self.sessionId = nil;
            if (success) success(_resp, [[JSONDecoder decoder] objectWithData:payload], payload);
        }
    }];
}

@end

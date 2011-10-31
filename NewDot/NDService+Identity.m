//
//  NDService+Identity.m
//  NewDot
//
//  Created by Christopher Miller on 9/23/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService+Identity.h"
#import "NDService+Implementation.h"

#import "AFHTTPClient.h"
#import "JSONKit.h"

#import "NSString+LastWord.h"
#import "NSURL+QueryStringConstructor.h"
#import "NSString+Base64.h"

@implementation NDService (Identity)

- (void)identityCreateSessionForUser:(NSString*)username
                        withPassword:(NSString*)password
                              apiKey:(NSString*)apiKey
                             onSuccess:(NDGenericSuccessBlock)success
                             onFailure:(NDIdentitySessionCreateFailureBlock)failure
{
    NSMutableDictionary* urlParameters = [self.defaultURLParameters mutableCopy];
    [urlParameters setObject:apiKey forKey:@"key"];
    NSURL* url = [NSURL fs_URLWithString:@"/identity/v2/login" relativeToURL:self.serverUrl queryParameters:urlParameters];
    
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [req addValue:[NSString stringWithFormat:@"Basic %@", [NSString fs_encodeBase64WithString:[NSString stringWithFormat:@"%@:%@", username, password]]] forHTTPHeaderField:@"Authorization"];
//    [req addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
                               if (asplosion||[((NSHTTPURLResponse*)resp) statusCode]!=200) {
                                   // something very bad hath happened
                                   if (failure) {
                                       enum NDIdentitySessionCreateResult code = [((NSHTTPURLResponse*)resp) statusCode];
                                       failure(code, (NSHTTPURLResponse*)resp, asplosion);
                                   }
                               } else {
                                   id parsed_payload = [[JSONDecoder decoder] objectWithData:payload];
                                   self.sessionId = [parsed_payload valueForKeyPath:@"session.id"];
                                   if (success)
                                       success(parsed_payload);
                               }
                           }];
}

- (void)identitySessionOnSuccess:(NDGenericSuccessBlock)success
                       onFailure:(NDGenericFailureBlock)failure
{
    NSDictionary* params = [self copyOfDefaultURLParametersWithSessionId];
    NSURL* url = [NSURL fs_URLWithString:@"/identity/v2/session/" relativeToURL:self.serverUrl queryParameters:params];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
                               if (asplosion||[((NSHTTPURLResponse*)resp) statusCode]!=200) {
                                   if (failure)
                                       failure((NSHTTPURLResponse*)resp, asplosion);
                               } else {
                                   if (success)
                                       success([[JSONDecoder decoder] objectWithData:payload]);
                               }
                           }];
}

- (void)identityUserProfileOnSuccess:(NDGenericSuccessBlock)success
                           onFailure:(NDGenericFailureBlock)failure
{
    NSURL* url = [NSURL fs_URLWithString:@"/identity/v2/user" relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[((NSHTTPURLResponse*)resp) statusCode]!=200) {
            if (failure)
                failure((NSHTTPURLResponse*)resp, asplosion);
        } else {
            if (success)
                success([[JSONDecoder decoder] objectWithData:payload]);
        }
    }];
}

- (void)identityUserPermissionsOnSuccess:(NDGenericSuccessBlock)success
                               onFailure:(NDGenericFailureBlock)failure
{
    NSURL* url = [NSURL fs_URLWithString:@"/identity/v2/permission" relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[((NSHTTPURLResponse*)resp) statusCode]!=200) {
            if (failure)
                failure((NSHTTPURLResponse*)resp, asplosion);
        } else {
            if (success)
                success([[JSONDecoder decoder] objectWithData:payload]);
        }
    }];
}

- (void)identityDestroySessionOnSuccess:(NDGenericSuccessBlock)success
                              onFailure:(NDGenericFailureBlock)failure
{
    NSURL* url = [NSURL fs_URLWithString:@"/identity/v2/logout" relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[((NSHTTPURLResponse*)resp) statusCode]!=200) {
            if (failure)
                failure((NSHTTPURLResponse*)resp, asplosion);
        } else {
            self.sessionId = nil;
            if (success)
                success([[JSONDecoder decoder] objectWithData:payload]);
        }
    }];
}

@end

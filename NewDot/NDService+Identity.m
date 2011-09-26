//
//  NDService+Identity.m
//  NewDot
//
//  Created by Christopher Miller on 9/23/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService+Identity.h"

#import "AFHTTPClient.h"

@implementation NDService (Identity)

- (void)identityCreateSessionForUser:(NSString *)username
                        withPassword:(NSString *)password
                              apiKey:(NSString *)apiKey
                             onSuccess:(NDGenericSuccessBlock)success
                             onFailure:(NDIdentitySessionCreateFailureBlock)failure
{
    NSMutableDictionary * urlParameters = [self.defaultURLParameters mutableCopy];
    [urlParameters setObject:apiKey forKey:@"key"];
    [self.client setAuthorizationHeaderWithUsername:username password:password];
    [self.client getPath:@"/identity/v2/login"
              parameters:urlParameters
                 success:^(id response) {
                     // set the session ID
                     self.sessionId = [response valueForKeyPath:@"session.id"];
                     if (success)
                         success(response);
                 } failure:^(NSError * error) {
                     enum NDIdentitySessionCreateResult response = [[[[[error userInfo] objectForKey:NSLocalizedDescriptionKey] componentsSeparatedByString:@" "] lastObject] integerValue];
                     if (failure)
                         failure(response, error);
                 }];
    [self.client clearAuthorizationHeader];
}

- (void)identitySessionOnSuccess:(NDGenericSuccessBlock)success
                       onFailure:(NDGenericFailureBlock)failure
{
    [self.client getPath:@"/identity/v2/session/"
              parameters:[self copyOfDefaultURLParametersWithSessionId]
                 success:^(id response) {
                     if (success)
                         success(response);
                 }
                 failure:^(NSError * error) {
                     if (failure)
                         failure(error);
                 }];
}

- (void)identityUserProfileOnSuccess:(NDGenericSuccessBlock)success
                           onFailure:(NDGenericFailureBlock)failure
{
    [self.client getPath:@"/identity/v2/user"
              parameters:[self copyOfDefaultURLParametersWithSessionId]
                 success:^(id response) {
                     if (success)
                         success(response);
                 }
                 failure:^(NSError * error) {
                     if (failure)
                         failure(error);
                 }];
}

- (void)identityUserPermissionsOnSuccess:(NDGenericSuccessBlock)success
                               onFailure:(NDGenericFailureBlock)failure
{
    [self.client getPath:@"/identity/v2/permission"
              parameters:[self copyOfDefaultURLParametersWithSessionId]
                 success:^(id response) {
                     if (success)
                         success(response);
                 }
                 failure:^(NSError * error) {
                     if (failure)
                         failure(error);
                 }];
}

- (void)identityDestroySessionOnSuccess:(NDGenericSuccessBlock)success
                              onFailure:(NDGenericFailureBlock)failure
{
    [self.client getPath:@"/identity/v2/logout"
              parameters:[self copyOfDefaultURLParametersWithSessionId]
                 success:^(id response) {
                     self.sessionId = nil;
                     if (success)
                         success(response);
                 }
                 failure:^(NSError * error) {
                     if (failure)
                         failure(error);
                 }];
}

@end

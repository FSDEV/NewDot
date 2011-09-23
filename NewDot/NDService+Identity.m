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

- (void)createSessionForUser:(NSString *)username
                withPassword:(NSString *)password
                     success:(void (^)(id response))success
                     failure:(void (^)(enum NDIdentitySessionCreateResult result, NSError * error))failure
{
    [self.client setAuthorizationHeaderWithUsername:username password:password];
    [self.client getPath:@"/identity/v2/login"
              parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"dataFormat", self.apiKey, @"key", nil]
                 success:^(id response) {
                     // set the session ID
                     self.sessionId = [response valueForKeyPath:@"session.id"];
                     if (success)
                         success(response);
                 } failure:^(NSError * error) {
        
                     if (failure)
                         failure(OK, error);
                 }];
}

@end

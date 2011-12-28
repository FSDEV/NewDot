//
//  NDService+Identity.h
//  NewDot
//
//  Created by Christopher Miller on 9/23/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService.h"

@class FSURLOperation;

/**
 * The Identity module to New(DOT)FamilySearch. Use these requests to log in, keep a session alive, read user profile and permissions information, and to log out.
 */
@interface NDService (Identity)

/**
 * Operation to create a new session. The session ID for the NewDot object is automatically set, except when you're not using an NDHTTPURLRequest method, in which case the finer points of session handling are your own darn responsibility!
 */
- (NSURLRequest*)identityRequestCreateSessionForUser:(NSString*)username withPassword:(NSString*)password apiKey:(NSString*)apiKey;
- (FSURLOperation*)identityOperationCreateSessionForUser:(NSString*)username withPassword:(NSString*)password apiKey:(NSString*)apiKey onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (FSURLOperation*)identityOperationCreateSessionForUser:(NSString*)username withPassword:(NSString*)password apiKey:(NSString*)apiKey onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)identityCreateSessionForUser:(NSString*)username withPassword:(NSString*)password apiKey:(NSString*)apiKey onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

/**
 * Read a session; keeps the session alive with a request that doesn't require any processing time. If this request fails, then the session ID is automatically cleared.
 */
- (NSURLRequest*)identityRequestSession;
- (FSURLOperation*)identityOperationSessionOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (FSURLOperation*)identityOperationSessionOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)identitySessionOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

- (NSURLRequest*)identityRequestUserProfile;
- (FSURLOperation*)identityOperationUserProfileOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (FSURLOperation*)identityOperationUserProfileOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)identityUserProfileOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

- (NSURLRequest*)identityRequestUserPermissions;
- (FSURLOperation*)identityOperationUserPermissionsOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (FSURLOperation*)identityOperationUserPermissionsOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)identityUserPermissionsOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

/**
 * Destroy a session (log out). The session ID is automatically cleared following this request, except if you're not using an NDHTTPURLRequest method, in which case the finer points of session handling is your own darn responsibility!
 */
- (NSURLRequest*)identityRequestDestroySession;
- (FSURLOperation*)identityOperationDestroySessionOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (FSURLOperation*)identityOperationDestroySessionOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)identityDestroySessionOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

@end

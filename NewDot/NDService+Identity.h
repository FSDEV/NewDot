//
//  NDService+Identity.h
//  NewDot
//
//  Created by Christopher Miller on 9/23/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService.h"

@class NDHTTPURLOperation;

/**
 * The Identity module to New(DOT)FamilySearch. Use these requests to log in, keep a session alive, read user profile and permissions information, and to log out.
 */
@interface NDService (Identity)

/**
 * Operation to create a new session.
 *
 * @param success This block will be called on success; the sessionID will automatically be set by internal implementation, so you don't have to do anything here if you don't want to.
 * @param failure This block will be called on failure. If the NSError object isn't nil, this usually means that there was a problem opening the network connection. Otherwise you'll get an error code in the NSHTTPURLResponse. You may additionally inspect the error payload, which is generally a big fat J2EE error page.
 */
- (NDHTTPURLOperation*)identityOperationCreateSessionForUser:(NSString*)username
                                                withPassword:(NSString*)password
                                                      apiKey:(NSString*)apiKey
                                                   onSuccess:(NDSuccessBlock)success
                                                   onFailure:(NDFailureBlock)failure;

/**
 * Create a new session and run it.
 * 
 * @see identityOperationCreateSessionForUser:withPassword:apiKey:onSuccess:onFailure:
 */
- (void)identityCreateSessionForUser:(NSString*)username
                        withPassword:(NSString*)password
                              apiKey:(NSString*)apiKey
                           onSuccess:(NDSuccessBlock)success
                           onFailure:(NDFailureBlock)failure;

/**
 * Operation to read a session; keeps the session alive with a request that doesn't require (much) processing time. If this request fails, then the session ID is automatically cleared.
 */
- (NDHTTPURLOperation*)identityOperationSessionOnSuccess:(NDSuccessBlock)success
                                               onFailure:(NDFailureBlock)failure;

/**
 * Read a session; keeps the session alive with a request that doesn't require any processing time. If this request fails, then the session ID is automatically cleared.
 */
- (void)identitySessionOnSuccess:(NDSuccessBlock)success
                       onFailure:(NDFailureBlock)failure;

/**
 * Operation to read a user profile.
 */
- (NDHTTPURLOperation*)identityOperationUserProfileOnSuccess:(NDSuccessBlock)success
                                                   onFailure:(NDFailureBlock)failure;

/**
 * Read a user profile. Generally speaking you shouldn't need this information.
 */
- (void)identityUserProfileOnSuccess:(NDSuccessBlock)success
                           onFailure:(NDFailureBlock)failure;

/**
 * Operation to read a user's permissions.
 */
- (NDHTTPURLOperation*)identityOperationUserPermissionsOnSuccess:(NDSuccessBlock)success
                                                       onFailure:(NDFailureBlock)failure;

/**
 * Read a user's permissions. There is some useful information here that you can use to determine what kind of interface to present.
 */
- (void)identityUserPermissionsOnSuccess:(NDSuccessBlock)success
                               onFailure:(NDFailureBlock)failure;

/**
 * Operation to destroy a session (log out).
 */
- (NDHTTPURLOperation*)identityOperationDestroySessionOnSuccess:(NDSuccessBlock)success
                                                      onFailure:(NDFailureBlock)failure;

/**
 * Destroy a session (log out). The session ID is automatically cleared following this request.
 */
- (void)identityDestroySessionOnSuccess:(NDSuccessBlock)success
                              onFailure:(NDFailureBlock)failure;

@end

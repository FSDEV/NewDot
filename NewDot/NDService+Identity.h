//
//  NDService+Identity.h
//  NewDot
//
//  Created by Christopher Miller on 9/23/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService.h"

/**
 * The Identity module to New(DOT)FamilySearch. Use these requests to log in, keep a session alive, read user profile and permissions information, and to log out.
 */
@interface NDService (Identity)

/**
 * Create a new session.
 *
 * @param success This method will automatically set the sessionId; you do not need to do anything here if you don't want to.
 * @param failure In addition to the default NSError object, you will also receive a pre-parsed integer corresponding to an enumeration of all possible errors.
 */
- (void)identityCreateSessionForUser:(NSString*)username
                        withPassword:(NSString*)password
                              apiKey:(NSString*)apiKey
                           onSuccess:(NDSuccessBlock)success
                           onFailure:(NDFailureBlock)failure;

/**
 * Read a session; keeps the session alive with a request that doesn't require any processing time. If this request fails, then the session ID is automatically cleared.
 */
- (void)identitySessionOnSuccess:(NDSuccessBlock)success
                       onFailure:(NDFailureBlock)failure;

/**
 * Read a user profile. Generally speaking you shouldn't need this information.
 */
- (void)identityUserProfileOnSuccess:(NDSuccessBlock)success
                           onFailure:(NDFailureBlock)failure;

/**
 * Read a user's permissions. There is some useful information here that you can use to determine what kind of interface to present.
 */
- (void)identityUserPermissionsOnSuccess:(NDSuccessBlock)success
                               onFailure:(NDFailureBlock)failure;

/**
 * Destroy a session (log out). The session ID is automatically cleared following this request.
 */
- (void)identityDestroySessionOnSuccess:(NDSuccessBlock)success
                              onFailure:(NDFailureBlock)failure;

@end

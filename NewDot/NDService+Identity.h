//
//  NDService+Identity.h
//  NewDot
//
//  Created by Christopher Miller on 9/23/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService.h"

/**
 * All the possible (documented) responses that the login (session create) request can get you.
 */
enum NDIdentitySessionCreateResult {
    FurtherActionRequired                           = 310,      // Terms of Service Change; the user needs to log in using new.FamilySearch.org
    BadRequest                                      = 400,
    BadRequestInsufficientQueryInformation          = 40001,
    BadRequestUnableToDetermineLocation             = 40002,
    BadRequestInvalidVersion                        = 40005,
    Unauthorised                                    = 401,
    UnauthorisedUnathenticated                      = 40100,
    UnauthorisedInvalidUserCredentials              = 40101,
    UnauthorisedInvalidSession                      = 40102,
    UnauthorisedInvalidKey                          = 40103,
    UnauthorisedInvalidUserAgent                    = 40104,
    UnauthorisedRegistrationRequired                = 40105,
    UnauthorisedPasswordChangeRequired              = 40107,
    UnauthorisedResolutionRequired                  = 40108,
    UnauthorisedDisabledUserAccount                 = 40109,
    UnauthorisedAccountNotActivated                 = 40110,
    UnauthorisedUnauthorised                        = 40111,
    UnauthorisedUnauthorisedInArea                  = 40112,
    UnauthorisedUnauthorisedInTempleDistrict        = 40113,
    UnauthorisedKeyRequired                         = 40120,
    UnauthorizedUsernameRequired                    = 40121,
    UnauthorizedPasswordRequired                    = 40122,
    UnauthorizedNoSessionFound                      = 40123,
    UnauthorizedNoUserAgentFound                    = 40124,
    UnauthorizedNoOriginatingIPAddressFound         = 40125,
    UnauthorizedCredentialsNotAllowedOnURL          = 40126,
    UnauthorizedAuthenticationServiceUnavailable    = 40150,
    UnsupportedMediaType                            = 415,
    InvalidDeveloperKey                             = 431,
    ServerError                                     = 500,      // FamilySearch goof; though really badly formed requests have been known to do this
    ServiceUnavailable                              = 503       // Probable throttling
} NDIdentitySessionCreateResult;

typedef void(^NDIdentitySessionCreateFailureBlock)(enum NDIdentitySessionCreateResult result, NSError * error);

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
- (void)createSessionForUser:(NSString *)username
                withPassword:(NSString *)password
                      apiKey:(NSString *)apiKey
                     success:(NDGenericSuccessBlock)success
                     failure:(NDIdentitySessionCreateFailureBlock)failure;

/**
 * Read a session; keeps the session alive with a request that doesn't require any processing time. If this request fails, then the session ID is automatically cleared.
 */
- (void)readSessionWithSuccess:(NDGenericSuccessBlock)success
                       failure:(NDGenericFailureBlock)failure;

/**
 * Read a user profile. Generally speaking you shouldn't need this information.
 */
- (void)readUserProfileWithSuccess:(NDGenericSuccessBlock)success
                           failure:(NDGenericFailureBlock)failure;

/**
 * Read a user's permissions. There is some useful information here that you can use to determine what kind of interface to present.
 */
- (void)readUserPermissionsWithSuccess:(NDGenericSuccessBlock)success
                               failure:(NDGenericFailureBlock)failure;

/**
 * Destroy a session (log out). The session ID is automatically cleared following this request.
 */
- (void)destroySessionWithSuccess:(NDGenericSuccessBlock)success
                          failure:(NDGenericFailureBlock)failure;

@end

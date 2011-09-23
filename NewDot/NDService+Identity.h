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
    OK                                              = 200,      // We have clearance, Clarence.
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

/**
 * The Identity module to New(DOT)FamilySearch.
 */
@interface NDService (Identity)

- (void)createSessionForUser:(NSString *)username
                withPassword:(NSString *)password
                     success:(void (^)(id response))success
                     failure:(void (^)(enum NDIdentitySessionCreateResult result, NSError * error))failure;

@end

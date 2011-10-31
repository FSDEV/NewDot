//
//  LoginTests.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "TestIdentity.h"

#import "NewDotDebuggingAppDelegate.h"

#import "NDService.h"
#import "NDService+Identity.h"

@interface TestIdentity ()

- (void)testLoginFailure;
- (void)testLogin;
- (void)testSessionRead;
- (void)testUserRead;
- (void)testPermissionsRead;
- (void)destroySession;

@end

@implementation TestIdentity

@synthesize winTest;
@synthesize failTest;

- (void)testLoginFailure
{
    [self.failTest identityCreateSessionForUser:@"Fail"
                                   withPassword:@"Fail"
                                         apiKey:self.apiKey
                                      onSuccess:^(id response) {
                                          LOG_IDENTITY(5,@"Created session with bogus login credentials. This really shouldn't happen. Results are %@", response);
                                      }
                                      onFailure:^(enum NDIdentitySessionCreateResult result, NSHTTPURLResponse* xhr, NSError* error) {
                                          LOG_IDENTITY(0,@"Session creation failed when it was supposed to with result:%d and error %@", result, error);
                                      }];
}

- (void)testLogin
{
    [self.winTest identityCreateSessionForUser:self.username
                                  withPassword:self.password
                                        apiKey:self.apiKey
                                     onSuccess:^(id response) {
                                         LOG_IDENTITY(0,@"Session created");
                                         [self testSessionRead];
                                     }
                                     onFailure:^(enum NDIdentitySessionCreateResult result, NSHTTPURLResponse* xhr, NSError* error) {
                                         LOG_IDENTITY(5,@"Session creation failed when it should have with error code %d and error %@", result, error);
                                     }];
}

- (void)testSessionRead
{
    [self.winTest identitySessionOnSuccess:^(id response) {
        LOG_IDENTITY(0,@"Session read");
        [self testUserRead];
    }
                                 onFailure:^(NSHTTPURLResponse* xhr, NSError* error) {
                                     LOG_IDENTITY(5,@"Failed to read session with error %@", error);
                                     [self destroySession];
                                 }];
}

- (void)testUserRead
{
    [self.winTest identityUserProfileOnSuccess:^(id response) {
        LOG_IDENTITY(0,@"User profile read");
        [self testPermissionsRead];
    }
                                     onFailure:^(NSHTTPURLResponse* xhr, NSError* error) {
                                         LOG_IDENTITY(5,@"Failed to read user profile with error %@", error);
                                         [self destroySession];
                                     }];
}

- (void)testPermissionsRead
{
    [self.winTest identityUserPermissionsOnSuccess:^(id response) {
        LOG_IDENTITY(0,@"Read the user's permissions");
        [self destroySession];
    }
                                         onFailure:^(NSHTTPURLResponse* xhr, NSError* error) {
                                             LOG_IDENTITY(5,@"Failed to read the user's permissions (maybe he or she doesn't have permission?) with error %@", error);
                                             [self destroySession];
                                         }];
}

- (void)destroySession
{
    [self.winTest identityDestroySessionOnSuccess:^(id response) {
        LOG_IDENTITY(0,@"Destroyed session");
    }
                                        onFailure:^(NSHTTPURLResponse* xhr, NSError* error) {
                                            LOG_IDENTITY(5,@"Failed to destroy session with error %@", error);
                                        }];
}

#pragma mark Harness

- (void)testWithUsername:(NSString*)u password:(NSString*)p serverLocation:(NSString*)s apiKey:(NSString*)a
{
    [super testWithUsername:u password:p serverLocation:s apiKey:a];
    
    NSURL* baseURL = [NSURL URLWithString:s];
    self.winTest = [[[NDService alloc] initWithBaseURL:baseURL userAgent:@"NewDot/0.2"] autorelease];
    self.failTest = [[[NDService alloc] initWithBaseURL:baseURL userAgent:@"NewDot/0.2"] autorelease];
    
    LOG_IDENTITY(0,@"Testing the Identity Module");
    [self testLoginFailure];
    [self testLogin];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    if (self) {

    }
    
    return self;
}

- (void)dealloc
{
    self.winTest = nil;
    self.failTest = nil;
    
    [super dealloc];
}

@end

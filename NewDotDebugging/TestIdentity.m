//
//  LoginTests.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "TestIdentity.h"

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
    [self.failTest identityCreateSessionForUser:[self.testCredentials valueForKeyPath:@"fail.username"]
                                   withPassword:[self.testCredentials valueForKeyPath:@"fail.password"]
                                         apiKey:[self.properties valueForKeyPath:@"reference.api-key"]
                                      onSuccess:^(id response) {
                                          [NSException raise:@"Session created with bogus login!" format:@"This really shouldn't happen! Results  are: %@", response];
                                      }
                                      onFailure:^(enum NDIdentitySessionCreateResult result, NSError * error) {
                                          printf("[[ WIN ]] Session create failed when it was supposed to!\n");
                                      }];
}

- (void)testLogin
{
    [self.winTest identityCreateSessionForUser:[self.testCredentials valueForKeyPath:@"success.username"]
                                  withPassword:[self.testCredentials valueForKeyPath:@"success.password"]
                                        apiKey:[self.properties valueForKeyPath:@"reference.api-key"]
                                     onSuccess:^(id response) {
                                         printf("[[ WIN ]] Session create\n");
                                         [self testSessionRead];
                                     }
                                     onFailure:^(enum NDIdentitySessionCreateResult result, NSError * error) {
                                         [NSException raise:@"Session Create Failure!" format:@"Should have been able to create this session, bro! Error code is: %d; Error is: %@", result, error];
                                     }];
}

- (void)testSessionRead
{
    [self.winTest identitySessionOnSuccess:^(id response) {
        printf("[[ WIN ]] Session read\n");
        [self testUserRead];
    }
                                 onFailure:^(NSError * error) {
                                     [NSException raise:@"Session Read Failure!" format:@"Failed to read session when it shouldn't have; error %@", error];
                                 }];
}

- (void)testUserRead
{
    [self.winTest identityUserProfileOnSuccess:^(id response) {
        printf("[[ WIN ]] User profile read\n");
        [self testPermissionsRead];
    }
                                     onFailure:^(NSError * error) {
                                         [NSException raise:@"User read failure!" format:@"Should have been able to read this user! Failed with error %@", error];
                                     }];
}

- (void)testPermissionsRead
{
    [self.winTest identityUserPermissionsOnSuccess:^(id response) {
        printf("[[ WIN ]] User permissions read\n");
        [self destroySession];
    }
                                         onFailure:^(NSError * error) {
                                             [NSException raise:@"User Permissions read failure!" format:@"Should have been able to read this user's permissions. Failed with error %@", error];
                                         }];
}

- (void)destroySession
{
    [self.winTest identityDestroySessionOnSuccess:^(id response) {
        printf("[[ WIN ]] Session destroy\n");
        printf("         ---- IDENTITY TESTS SUCCESSFUL ----\n");
    }
                                        onFailure:^(NSError * error) {
                                            [NSException raise:@"Session Destruction Failure!" format:@"Should have been able to destroy this session; failed with error %@", error];
                                        }];
}

#pragma mark Harness

- (void)test
{
    printf("\n\nTESTING IDENTITY\n\n");
    [self testLoginFailure];
    [self testLogin];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    if (self) {
        NSURL * baseURL = [NSURL URLWithString:[self.properties valueForKeyPath:@"reference.server"]];
        self.winTest = [[NDService alloc] initWithBaseURL:baseURL userAgent:nil];
        self.failTest = [[NDService alloc] initWithBaseURL:baseURL userAgent:nil];
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

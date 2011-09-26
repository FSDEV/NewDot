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

@synthesize properties;
@synthesize testCredentials;
@synthesize winTest;
@synthesize failTest;

- (void)test
{
    NSString * error;
    self.properties = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DeveloperKeys"
                                                                                                                                ofType:@"PLIST"]]
                                                mutabilityOption:NSPropertyListImmutable
                                                          format:NULL
                                                errorDescription:&error];
    NSURL * baseURL = [NSURL URLWithString:[self.properties valueForKeyPath:@"reference.server"]];
    self.winTest = [[NDService alloc] initWithBaseURL:baseURL userAgent:nil];
    self.failTest = [[NDService alloc] initWithBaseURL:baseURL userAgent:nil];
    
    self.testCredentials = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TestCredentials" ofType:@"PLIST"]]
                                                            mutabilityOption:NSPropertyListImmutable
                                                                      format:NULL
                                                            errorDescription:&error];
    
    [self testLoginFailure];
    [self testLogin];
}

- (void)testLoginFailure
{
    [self.failTest createSessionForUser:[self.testCredentials valueForKeyPath:@"fail.username"]
                           withPassword:[self.testCredentials valueForKeyPath:@"fail.password"]
                                 apiKey:[self.properties valueForKeyPath:@"reference.api-key"]
                                success:^(id response) {
                                    [NSException raise:@"Session created with bogus login!" format:@"This really shouldn't happen! Results are: %@", response];
                                }
                                failure:^(enum NDIdentitySessionCreateResult result, NSError * error) {
                                    NSLog(@"[[ WIN ]] Test failed when it was supposed to!");
                                }];
}

- (void)testLogin
{
    [self.winTest createSessionForUser:[self.testCredentials valueForKeyPath:@"success.username"]
                          withPassword:[self.testCredentials valueForKeyPath:@"success.password"]
                                apiKey:[self.properties valueForKeyPath:@"reference.api-key"]
                               success:^(id response) {
                                   NSLog(@"[[ WIN ]] Session Create");
                                   [self testSessionRead];
                               }
                               failure:^(enum NDIdentitySessionCreateResult result, NSError * error) {
                                   [NSException raise:@"Session Create Failure!" format:@"Should have been able to create this session, bro! Error code is: %d; Error is: %@", result, error];
                               }];
}

- (void)testSessionRead
{
    [self.winTest readSessionWithSuccess:^(id response) {
        NSLog(@"[[ WIN ]] Session Read");
        [self testUserRead];
    }
                                 failure:^(NSError * error) {
                                     [NSException raise:@"Session Read Failure!" format:@"Failed to read session when it shouldn't have; error %@", error];
                                 }];
}

- (void)testUserRead
{
    [self.winTest readUserProfileWithSuccess:^(id response) {
        [self testPermissionsRead];
    }
                                     failure:^(NSError * error) {
                                         [NSException raise:@"User read failure!" format:@"Should have been able to read this user! Failed with error %@", error];
                                     }];
}

- (void)testPermissionsRead
{
    [self.winTest readUserPermissionsWithSuccess:^(id response) {
        [self destroySession];
    }
                                         failure:^(NSError * error) {
                                             [NSException raise:@"User Permissions read failure!" format:@"Should have been able to read this user's permissions. Failed with error %@", error];
                                         }];
}

- (void)destroySession
{
    [self.winTest destroySessionWithSuccess:^(id response) {
        NSLog(@"[[ WIN ]] Session Destroy");
    }
                                    failure:^(NSError * error) {
                                        [NSException raise:@"Session Destruction Failure!" format:@"Should have been able to destroy this session; failed with error %@", error];
                                    }];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    self.properties = nil;
    self.testCredentials = nil;
    self.winTest = nil;
    self.failTest = nil;
    
    [super dealloc];
}

@end

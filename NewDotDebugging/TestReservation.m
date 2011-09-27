//
//  TestReservation.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "TestReservation.h"

#import "NDService.h"
#import "NDService+Identity.h"
#import "NDService+FamilyTree.h"
#import "NDService+Reservation.h"

@interface TestReservation ()

- (void)login;

- (void)logout;

@end

@implementation TestReservation

@synthesize service;

- (void)login
{
    [self.service identityCreateSessionForUser:[self.testCredentials valueForKeyPath:@"success.username"]
                                  withPassword:[self.testCredentials valueForKeyPath:@"success.password"]
                                        apiKey:[self.properties valueForKeyPath:@"reference.api-key"]
                                     onSuccess:^(id response) {
                                         printf("[[ WIN ]] Logged in successfully!\n");
                                     }
                                     onFailure:^(enum NDIdentitySessionCreateResult result, NSError * error) {
                                         [NSException raise:@"Failed to log in!" format:@"Error code is %d and error description is %@", result, error];
                                     }];
}

- (void)logout
{
    [self.service identityDestroySessionOnSuccess:^(id result) {
        printf("[[ WIN ]] Destroyed session\n");
        printf("         ---- RESERVATION TESTS SUCCESSFUL ----\n");
    }
                                        onFailure:^(NSError * error) {
                                            [NSException raise:@"Failed to log out" format:@"Error is %@", error];
                                        }];
}

#pragma mark Harness

- (void)test
{
    printf("\n\nTESTING RESERVATION\n\n");
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    if (self) {
        self.service = [[NDService alloc] initWithBaseURL:[NSURL URLWithString:[self.properties valueForKeyPath:@"reference.server"]]
                                                userAgent:nil];
    }
    
    return self;
}

- (void)dealloc
{
    self.service = nil;
    
    [super dealloc];
}

@end

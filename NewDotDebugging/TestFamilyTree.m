//
//  TestFamilyTree.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "TestFamilyTree.h"

#import "NDService.h"
#import "NDService+Identity.h"
#import "NDService+FamilyTree.h"

@interface TestFamilyTree ()

- (void)login;
- (void)readProperties;
- (void)readUserProfile;
- (void)readUserRecord;
- (void)logout;

@end

@implementation TestFamilyTree

@synthesize service;

- (void)login
{
    [self.service identityCreateSessionForUser:[self.testCredentials valueForKeyPath:@"success.username"]
                                  withPassword:[self.testCredentials valueForKeyPath:@"success.password"]
                                        apiKey:[self.properties valueForKeyPath:@"reference.api-key"]
                                     onSuccess:^(id response) {
                                         printf("[[ WIN ]] Session create\n");
                                         [self readProperties];
                                     }
                                     onFailure:^(enum NDIdentitySessionCreateResult result, NSError * error) {
                                         [NSException raise:@"Failed to log in" format:@"Cannot test the rest of the system without a valid session; failed with error %d and description %@", result, error];
                                     }];
}

- (void)readProperties
{
    [self.service familyTreePropertiesOnSuccess:^(id response) {
        printf("[[ WIN ]] Read the properties successfully!\n");
        [self readUserProfile];
    }
                                      onFailure:^(NSError * error) {
                                          [NSException raise:@"Failed to read properties!" format:@"Dude, seriously, what gives? You don't even need to be authenticated to do this! Error is %@", error];
                                      }];
}

- (void)readUserProfile
{
    [self.service familyTreeUserProfileOnSuccess:^(id response) {
        printf("[[ WIN ]] Read the user profile successfully!\n");
        NSString * userId = [[response valueForKeyPath:@"users.id"] lastObject];
        [self readUserRecord];
    }
                                       onFailure:^(NSError * error) {
                                           [NSException raise:@"Failed to read user profile!" format:@"Error is %@", error];
                                       }];
}

- (void)readUserRecord
{
    [self.service familyTreeReadPersons:nil
                         withParameters:[NSDictionary dictionary]
                              onSuccess:^(id response) {
                                  printf("[[ WIN ]] Read the user record successfully!\n");
                                  [self logout];
                              }
                              onFailure:^(NSError * error) {
                                  [NSException raise:@"Failed to read user record!" format:@"Well, you should be able to read your own living record! Error is %@", error];
                              }];
}

- (void)logout
{
    [self.service identityDestroySessionOnSuccess:^(id response) {
        printf("[[ WIN ]] Destroyed session\n");
        printf("         ---- FAMILYTREE TESTS SUCCESSFUL ----\n");
    }
                                        onFailure:^(NSError * error) {
                                            [NSException raise:@"Failed to destroy session" format:@"Cannot destroy the session; this isn't fatal, but really not expected and probably evidence of a larger problem. Error is %@", error];
                                        }];
}

#pragma mark Harness

- (void)test
{
    printf("\n\nTESTING FAMILYTREE\n\n");
    [self login];
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

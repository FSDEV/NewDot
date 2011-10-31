//
//  TestFamilyTree.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "TestFamilyTree.h"

#import "NewDotDebuggingAppDelegate.h"

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
    [self.service identityCreateSessionForUser:self.username
                                  withPassword:self.password
                                        apiKey:self.apiKey
                                     onSuccess:^(id response) {
                                         LOG_FAMILYTREE(0,@"Session created");
                                         [self readProperties];
                                     }
                                     onFailure:^(enum NDIdentitySessionCreateResult result, NSHTTPURLResponse* xhr, NSError* error) {
                                         LOG_FAMILYTREE(5,@"Failed to create session with result:%d and error %@", result, error);
                                     }];
}

- (void)readProperties
{
    [self.service familyTreePropertiesOnSuccess:^(id response) {
        LOG_FAMILYTREE(0,@"Read the properties succussfully");
        [self readUserProfile];
    }
                                      onFailure:^(NSHTTPURLResponse* xhr, NSError* error) {
                                          LOG_FAMILYTREE(5,@"Failed to read properties with error %@", error);
                                          [self logout];
                                      }];
}

- (void)readUserProfile
{
    [self.service familyTreeUserProfileOnSuccess:^(id response) {
        LOG_FAMILYTREE(0,@"Read the user's profile");
        NSString* userId = [[response valueForKeyPath:@"users.id"] lastObject];
        [self readUserRecord];
    }
                                       onFailure:^(NSHTTPURLResponse* xhr, NSError* error) {
                                           LOG_FAMILYTREE(5,@"Failed to read the user's profile with error %@", error);
                                           [self logout];
                                       }];
}

- (void)readUserRecord
{
    [self.service familyTreeReadPersons:nil
                         withParameters:[NSDictionary dictionary]
                              onSuccess:^(id response) {
                                  LOG_FAMILYTREE(0,@"Read the user record successfully");
                                  [self logout];
                              }
                              onFailure:^(NSHTTPURLResponse* xhr, NSError* error) {
                                  LOG_FAMILYTREE(5,@"Failed to read the user record with error %@", error);
                                  [self logout];
                              }];
}

- (void)logout
{
    [self.service identityDestroySessionOnSuccess:^(id response) {
        LOG_FAMILYTREE(0,@"Destroyed session");
    }
                                        onFailure:^(NSHTTPURLResponse* xhr, NSError* error) {
                                            LOG_FAMILYTREE(5,@"Failed to destroy session with error %@", error);
                                        }];
}

#pragma mark Harness

- (void)testWithUsername:(NSString*)u password:(NSString*)p serverLocation:(NSString*)s apiKey:(NSString*)a
{
    [super testWithUsername:u password:p serverLocation:s apiKey:a];
    
    self.service = [[[NDService alloc] initWithBaseURL:[NSURL URLWithString:self.serverLocation] userAgent:nil] autorelease];
    LOG_FAMILYTREE(0, @"Testing the FamilyTree Module");
    [self login];
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
    self.service = nil;
    
    [super dealloc];
}

@end

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
                                     onSuccess:^(NSHTTPURLResponse* resp, id parsed_payload, NSData* payload) {
                                         LOG_FAMILYTREE(0,@"Session created");
                                         LOG_FAMILYTREE(0,@"Session ID: %@", self.service.sessionId);
                                         [self readProperties];
                                     }
                                     onFailure:^(NSHTTPURLResponse* resp, NSData* payload, NSError* error) {
                                         LOG_FAMILYTREE(5,@"Failed to create session with error: %d and payload: %@", [resp statusCode], [payload fs_stringValue]);
                                     }];
}

- (void)readProperties
{
    [self.service familyTreePropertiesOnSuccess:^(NSHTTPURLResponse* resp, id response, NSData* payload) {
        LOG_FAMILYTREE(0,@"Read the properties succussfully");
        LOG_FAMILYTREE(0, @"%@", response);
        [self readUserProfile];
    }
                                      onFailure:^(NSHTTPURLResponse* resp, NSData* payload, NSError* error) {
                                          LOG_FAMILYTREE(5,@"Failed to read properties with error %@", [resp statusCode]);
                                          LOG_FAMILYTREE(5,@"Error payload: %@", [payload fs_stringValue]);
                                          [self logout];
                                      }];
}

- (void)readUserProfile
{
    [self.service familyTreeUserProfileOnSuccess:^(NSHTTPURLResponse* resp, id response, NSData* payload) {
        LOG_FAMILYTREE(0,@"Read the user's profile");
        LOG_FAMILYTREE(0, @"%@", response);
        NSString* userId = [[response valueForKeyPath:@"users.id"] lastObject];
        [self readUserRecord];
    }
                                       onFailure:^(NSHTTPURLResponse* resp, NSData* payload, NSError* error) {
                                           LOG_FAMILYTREE(5,@"Failed to read the user's profile with error %@", [resp statusCode]);
                                           LOG_FAMILYTREE(5,@"Error payload: %@", [payload fs_stringValue]);
                                           [self logout];
                                       }];
}

- (void)readUserRecord
{
    [self.service familyTreeReadPersons:nil
                         withParameters:[NSDictionary dictionary]
                              onSuccess:^(NSHTTPURLResponse* resp, id response, NSData* payload) {
                                  LOG_FAMILYTREE(0,@"Read the user record successfully");
                                  LOG_FAMILYTREE(0,@"User Record: %@", response);
                                  [self logout];
                              }
                              onFailure:^(NSHTTPURLResponse* resp, NSData* payload, NSError* error) {
                                  LOG_FAMILYTREE(5,@"Failed to read the user record with error %d and payload: %@", [resp statusCode], [payload fs_stringValue]);
                                  [self logout];
                              }];
}

- (void)logout
{
    [self.service identityDestroySessionOnSuccess:^(NSHTTPURLResponse* resp, id response, NSData* payload) {
        LOG_FAMILYTREE(0,@"Destroyed session");
    }
                                        onFailure:^(NSHTTPURLResponse* resp, NSData* payload, NSError* error) {
                                            LOG_FAMILYTREE(5,@"Failed to destroy session with error %d and payload %@", [resp statusCode], [payload fs_stringValue]);
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

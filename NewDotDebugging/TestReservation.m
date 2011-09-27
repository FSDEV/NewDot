//
//  TestReservation.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "TestReservation.h"

#import "NewDotDebuggingAppDelegate.h"

#import "NDService.h"
#import "NDService+Identity.h"
#import "NDService+FamilyTree.h"
#import "NDService+Reservation.h"

@interface TestReservation ()

- (void)login;
- (void)readProperties;
- (void)readUserProfile;
- (void)reservationList;
- (void)readPeople:(NSArray *)people;
- (void)logout;

@end

@implementation TestReservation

@synthesize service;
@synthesize personmaxids;

- (void)login
{
    [self.service identityCreateSessionForUser:[self.testCredentials valueForKeyPath:@"success.username"]
                                  withPassword:[self.testCredentials valueForKeyPath:@"success.password"]
                                        apiKey:[self.properties valueForKeyPath:@"reference.api-key"]
                                     onSuccess:^(id response) {
                                         LOG_STUFF(@"[[ WIN ]] Logged in successfully!\n");
                                         [self readProperties];
                                     }
                                     onFailure:^(enum NDIdentitySessionCreateResult result, NSError * error) {
                                         [NSException raise:@"Failed to log in!" format:@"Error code is %d and error description is %@", result, error];
                                     }];
}

- (void)readProperties
{
    [self.service reservationPropertiesOnSuccess:^(id response) {
        LOG_STUFF(@"[[ WIN ]] Read reservation properties\n");
        self.personmaxids = [[response valueForKey:@"person.max.ids"] integerValue];
        [self readUserProfile];
    }
                                       onFailure:^(NSError * error) {
                                           [NSException raise:@"Failed to read properties!" format:@"Error description is %@", error];
                                       }];
}

- (void)readUserProfile
{
    NSString * str = [NSString stringWithFormat:@"[[ TODO ]] !!! IMPLEMENT %s !!!\n", __PRETTY_FUNCTION__];
    LOG_STUFF(str);
    [self reservationList];
}

- (void)reservationList
{
    NSString * str = [NSString stringWithFormat:@"[[ TODO ]] !!! IMPLEMENT %s !!!\n", __PRETTY_FUNCTION__];
    LOG_STUFF(str);
    [self readPeople:nil];
}

- (void)readPeople:(NSArray *)people
{
    NSString * str = [NSString stringWithFormat:@"[[ TODO ]] !!! IMPLEMENT %s !!!\n", __PRETTY_FUNCTION__];
    LOG_STUFF(str);
    [self logout];
}

- (void)logout
{
    [self.service identityDestroySessionOnSuccess:^(id result) {
        LOG_STUFF(@"[[ WIN ]] Destroyed session\n");
        LOG_STUFF(@"         ---- RESERVATION TESTS SUCCESSFUL ----\n");
    }
                                        onFailure:^(NSError * error) {
                                            [NSException raise:@"Failed to log out" format:@"Error is %@", error];
                                        }];
}

#pragma mark Harness

- (void)test
{
    LOG_STUFF(@"\n         ---- TESTING RESERVATION ----\n");
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

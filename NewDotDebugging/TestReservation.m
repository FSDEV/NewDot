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

#import "NSArray+Chunky.h"

@interface TestReservation ()

- (void)login;
- (void)readProperties;
- (void)readUserProfile;
- (void)reservationListForUser:(NSString *)userId;
- (void)readPeople:(NSArray *)people;
- (void)readChunkedPeople:(NSArray *)people;
- (void)logout;

- (NSArray *)collectPersonIds:(NSArray *)ordinances;

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
                                         LOG_RESERVATION(0,@"Session created");
                                         [self readProperties];
                                     }
                                     onFailure:^(enum NDIdentitySessionCreateResult result, NSError * error) {
                                         LOG_RESERVATION(5,@"Failed to create session with code:%d and error %@", result, error);
                                     }];
}

- (void)readProperties
{
    [self.service reservationPropertiesOnSuccess:^(id response) {
        LOG_RESERVATION(0,@"Read reservation module properties");
        self.personmaxids = [[response valueForKey:@"person.max.ids"] integerValue];
        [self readUserProfile];
    }
                                       onFailure:^(NSError * error) {
                                           LOG_RESERVATION(5,@"Failed to read properties with error %@", error);
                                           [self logout];
                                       }];
}

- (void)readUserProfile
{
    [self.service familyTreeUserProfileOnSuccess:^(id response) {
        LOG_RESERVATION(0,@"Read user profile");
        [self reservationListForUser:[[response valueForKeyPath:@"users.id"] lastObject]];
    }
                                       onFailure:^(NSError * error) {
                                           LOG_RESERVATION(5,@"Failed to read user profile with error %@", error);
                                           [self logout];
                                       }];
}

- (void)reservationListForUser:(NSString *)userId
{
    [self.service reservationListForUser:userId
                               onSuccess:^(id response) {
                                   LOG_RESERVATION(0,@"Read the reservation list");
                                   id collectedIds = [self collectPersonIds:response];
                                   LOG_RESERVATION(0,@"Read the following IDs: %@", collectedIds);
                                   [self readPeople:[self collectPersonIds:response]];
                               }
                               onFailure:^(NSError * error) {
                                   LOG_RESERVATION(5,@"Failed to read the reservation list with error %@", error);
                                   [self logout];
                               }];
}

- (void)readPeople:(NSArray *)people
{
    if ([people count]==0) {
        LOG_RESERVATION(1,@"There are no reserved ordinances to read");
        [self logout];
    } else {
        [self readChunkedPeople:[people fs_chunkifyWithMaxSize:self.personmaxids]];
    }
}

- (void)readChunkedPeople:(NSArray *)people
{
    NSArray * current = [people lastObject];
    NSArray * remaining = [people subarrayWithRange:NSMakeRange(0, [people count]-1)];
    [self.service reservationReadPersons:current
                               onSuccess:^(id response) {
                                   LOG_RESERVATION(0,@"Read reservation records for the following people: %@", [current componentsJoinedByString:@", "]);
                                   if ([remaining count] == 0)
                                       [self logout];
                                   else
                                       [self readChunkedPeople:remaining];
                               }
                               onFailure:^(NSError * error) {
                                   LOG_RESERVATION(5,@"Cannot read (%@) with error %@", [current componentsJoinedByString:@","], error);
                                   [self logout];
                               }];
}

- (void)logout
{
    [self.service identityDestroySessionOnSuccess:^(id result) {
        LOG_RESERVATION(0,@"Destroyed session");
    }
                                        onFailure:^(NSError * error) {
                                            LOG_RESERVATION(5,@"Failed to destroy session with error %@", error);
                                        }];
}

- (NSArray *)collectPersonIds:(NSArray *)ordinances
{
    NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];
    NSMutableArray * personIds = [NSMutableArray array];
    id personId;
    
    for (id ordinance in ordinances) {
        if ([[ordinance objectForKey:@"type"] isEqualToString:@"individualReservation"]) {
            personId = [ordinance valueForKeyPath:@"individual.personId"];
            if (![personIds containsObject:personId])
                [personIds addObject:personId];
        } else if ([[ordinance objectForKey:@"type"] isEqualToString:@"sealingToSpouseReservation"]) {
            personId = [ordinance valueForKeyPath:@"husband.personId"];
            if (![personIds containsObject:personId])
                [personIds addObject:personId];
            personId = [ordinance valueForKeyPath:@"wife.personId"];
            if (![personIds containsObject:personId])
                [personIds addObject:personId];
        } else if ([[ordinance objectForKey:@"type"] isEqualToString:@"sealingToParentsReservation"]) {
            personId = [ordinance valueForKeyPath:@"mother.personId"];
            if (![personIds containsObject:personId])
                [personIds addObject:personId];
            personId = [ordinance valueForKeyPath:@"father.personId"];
            if (![personIds containsObject:personId])
                [personIds addObject:personId];
            personId = [ordinance valueForKeyPath:@"child.personId"];
            if (![personIds containsObject:personId])
                [personIds addObject:personId];
        }
    }
    
    id collectedPersonIds = [personIds copy];
    [pool0 release];
    
    return [collectedPersonIds autorelease];
}

#pragma mark Harness

- (void)test
{
    LOG_RESERVATION(0,@"Testing the Reservation Module");
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

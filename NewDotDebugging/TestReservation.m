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
    [self.service familyTreeUserProfileOnSuccess:^(id response) {
        LOG_STUFF(@"[[ WIN ]] Read user profile\n");
        [self reservationListForUser:[[response valueForKeyPath:@"users.id"] lastObject]];
    }
                                       onFailure:^(NSError * error) {
                                           [NSException raise:@"Failed to read user profile!" format:@"Error is %@", error];
                                       }];
}

- (void)reservationListForUser:(NSString *)userId
{
    [self.service reservationListForUser:userId
                               onSuccess:^(id response) {
                                   LOG_STUFF(@"[[ WIN ]] Read the reservation list!\n");
                                   id collectedIds = [self collectPersonIds:response];
                                   [self readPeople:[self collectPersonIds:response]];
                               }
                               onFailure:^(NSError * error) {
                                   [NSException raise:@"Failed to read the reservation list!" format:@"Error is %@", error];
                               }];
}

- (void)readPeople:(NSArray *)people
{
    [self readChunkedPeople:[people fs_chunkifyWithMaxSize:self.personmaxids]];
}

- (void)readChunkedPeople:(NSArray *)people
{
    NSArray * current = [people lastObject];
    NSArray * remaining = [people subarrayWithRange:NSMakeRange(0, [people count]-1)];
    [self.service reservationReadPersons:current
                               onSuccess:^(id response) {
                                   NSString * str = [NSString stringWithFormat:@"[[ WIN ]] Read people: %@\n", [current componentsJoinedByString:@", "]];
                                   LOG_STUFF(str);
                                   if ([remaining count] == 0)
                                       [self logout];
                                   else
                                       [self readChunkedPeople:remaining];
                               }
                               onFailure:^(NSError * error) {
                                   [NSException raise:@"Cannot read people!" format:@"Error is %@", error];
                               }];
}

- (void)logout
{
    [self.service identityDestroySessionOnSuccess:^(id result) {
        LOG_STUFF(@"[[ WIN ]] Destroyed session\n");
        LOG_STUFF(@"---- RESERVATION TESTS SUCCESSFUL ----\n");
    }
                                        onFailure:^(NSError * error) {
                                            [NSException raise:@"Failed to log out" format:@"Error is %@", error];
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
    LOG_STUFF(@"\n---- TESTING RESERVATION ----\n");
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

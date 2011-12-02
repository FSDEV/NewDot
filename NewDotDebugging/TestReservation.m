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
- (void)reservationListForUser:(NSString*)userId;
- (void)readPeople:(NSArray*)people;
- (void)readChunkedPeople:(NSArray*)people;
- (void)logout;

- (NSArray*)collectPersonIds:(NSArray*)ordinances;

@end

@implementation TestReservation

@synthesize service;
@synthesize personmaxids;

- (void)login
{
    [self.service identityCreateSessionForUser:self.username
                                  withPassword:self.password
                                        apiKey:self.apiKey
                                     onSuccess:^(NSHTTPURLResponse* resp, id response, NSData* payload) {
                                         LOG_RESERVATION(0,@"Session %@ created", self.service.sessionId);
                                         [self readProperties];
                                     }
                                     onFailure:^(NSHTTPURLResponse* xhr, NSData* payload, NSError* error) {
                                         LOG_RESERVATION(5,@"Failed to create session with code: %d and payload %@", [xhr statusCode], [payload fs_stringValue]);
                                     }];
}

- (void)readProperties
{
    [self.service reservationPropertiesOnSuccess:^(NSHTTPURLResponse* resp, id response, NSData* payload) {
        LOG_RESERVATION(0,@"Read reservation module properties with payload:");
        LOG_RESERVATION(0,@"%@", response);
        self.personmaxids = [[response valueForKey:@"person.max.ids"] integerValue];
        [self readUserProfile];
    }
                                       onFailure:^(NSHTTPURLResponse* xhr, NSData* payload, NSError* error) {
                                           LOG_RESERVATION(5,@"Failed to read properties with error %d", [xhr statusCode]);
                                           LOG_RESERVATION(5, @"%@", [payload fs_stringValue]);
                                           [self logout];
                                       }];
}

- (void)readUserProfile
{
    [self.service familyTreeUserProfileOnSuccess:^(NSHTTPURLResponse* resp, id response, NSData* payload) {
        LOG_RESERVATION(0,@"Read user profile with payload:");
        LOG_RESERVATION(0,@"%@",response);
        [self reservationListForUser:[[response valueForKeyPath:@"users.id"] lastObject]];
    }
                                       onFailure:^(NSHTTPURLResponse* xhr, NSData* payload, NSError* error) {
                                           LOG_RESERVATION(5,@"Failed to read user profile with error %d", [xhr statusCode]);
                                           LOG_RESERVATION(5, @"%@", [payload fs_stringValue]);
                                           [self logout];
                                       }];
}

- (void)reservationListForUser:(NSString*)userId
{
    [self.service reservationListForUser:userId
                               onSuccess:^(NSHTTPURLResponse* resp, id response, NSData* payload) {
                                   LOG_RESERVATION(0,@"Read the reservation list");
                                   id collectedIds = [self collectPersonIds:response];
                                   LOG_RESERVATION(0,@"Read the following IDs: %@", collectedIds);
                                   [self readPeople:[self collectPersonIds:response]];
                               }
                               onFailure:^(NSHTTPURLResponse* xhr, NSData* payload, NSError* error) {
                                   LOG_RESERVATION(5,@"Failed to read the reservation list with error %d", [xhr statusCode]);
                                   LOG_RESERVATION(5, @"%@", [payload fs_stringValue]);
                                   [self logout];
                               }];
}

- (void)readPeople:(NSArray*)people
{
    if ([people count]==0) {
        LOG_RESERVATION(1,@"There are no reserved ordinances to read");
        [self logout];
    } else {
        [self readChunkedPeople:[people fs_chunkifyWithMaxSize:self.personmaxids]];
    }
}

- (void)readChunkedPeople:(NSArray*)people
{
    NSArray* current = [people lastObject];
    NSArray* remaining = [people subarrayWithRange:NSMakeRange(0, [people count]-1)];
    [self.service reservationReadPersons:current
                               onSuccess:^(NSHTTPURLResponse* resp, id response, NSData* payload) {
                                   LOG_RESERVATION(0,@"Read reservation records for the following people: %@", [current componentsJoinedByString:@", "]);
                                   if ([remaining count] == 0)
                                       [self logout];
                                   else
                                       [self readChunkedPeople:remaining];
                               }
                               onFailure:^(NSHTTPURLResponse* xhr, NSData* payload, NSError* error) {
                                   LOG_RESERVATION(5,@"Cannot read (%@) with error %d", [current componentsJoinedByString:@","], [xhr statusCode]);
                                   LOG_RESERVATION(5,@"%@", [payload fs_stringValue]);
                                   [self logout];
                               }];
}

- (void)logout
{
    [self.service identityDestroySessionOnSuccess:^(NSHTTPURLResponse* resp, id response, NSData* payload) {
        LOG_RESERVATION(0,@"Destroyed session");
    }
                                        onFailure:^(NSHTTPURLResponse* xhr, NSData* payload, NSError* error) {
                                            LOG_RESERVATION(5,@"Failed to destroy session with error %d", [xhr statusCode]);
                                        }];
}

- (NSArray*)collectPersonIds:(NSArray*)ordinances
{
    id collectedPersonIds = nil;
    @autoreleasepool {
        NSMutableArray* personIds = [NSMutableArray array];
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
        
        collectedPersonIds = [personIds copy];
    }
    
    return collectedPersonIds;
}

#pragma mark Harness

- (void)testWithUsername:(NSString*)u password:(NSString*)p serverLocation:(NSString*)s apiKey:(NSString*)a
{
    [super testWithUsername:u password:p serverLocation:s apiKey:a];
    
    self.service = [[NDService alloc] initWithBaseURL:[NSURL URLWithString:self.serverLocation] userAgent:nil];
    
    LOG_RESERVATION(0, @"Testing the Reservation Module");
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

@end

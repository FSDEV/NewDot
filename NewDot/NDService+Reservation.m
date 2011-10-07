//
//  NDService+Reservation.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService+Reservation.h"

#import "AFHTTPClient.h"

const struct NDReservationType NDReservationType = {
    .individual              = @"individualReservation",
    .sealingToParents        = @"sealingToParentsReservation",
    .sealingToSpouse         = @"sealingToSpouseReservation"
};

const struct NDOrdinanceStatus NDOrdinanceStatus = {
    .notNeeded              = @"Not Needed",
    .reserved               = @"Reserved",
    .ready                  = @"Ready",
    .notReady               = @"Not Ready",
    .completed              = @"Completed",
    .notAvailable           = @"Not Available",
    .needMoreInformation    = @"Need More Information",
    .inProgress             = @"In Progress",
    .onHold                 = @"On Hold",
    .cancelled              = @"Cancelled",
    .deleted                = @"Deleted",
    .invalid                = @"Invalid"
};

@implementation NDService (Reservation)

- (void)reservationPropertiesOnSuccess:(NDGenericSuccessBlock)success
                             onFailure:(NDGenericFailureBlock)failure
{
    [self.client getPath:@"/reservation/v1/properties"
              parameters:self.defaultURLParameters
                 success:^(id response) {
                     NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                     for (id kvpair in [response valueForKey:@"properties"])
                         [dict setObject:[kvpair valueForKey:@"value"] forKey:[kvpair valueForKey:@"name"]];
                     if (success)
                         success([dict autorelease]);
                 }
                 failure:failure];
}

- (void)reservationListForUser:(NSString *)userId
                     onSuccess:(NDGenericSuccessBlock)success
                     onFailure:(NDGenericFailureBlock)failure
{
    [self.client getPath:[NSString stringWithFormat:@"/reservation/v1/list/%@/", userId]
              parameters:[self copyOfDefaultURLParametersWithSessionId]
                 success:^(id response) {
                     NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
                     NSMutableArray * ordinances = [NSMutableArray array];
                     NSMutableDictionary * dict;
                     for (id reservation in [response valueForKeyPath:@"list.reservation"]) {
                         dict = [NSMutableDictionary dictionaryWithDictionary:[reservation objectForKey:[[reservation allKeys] lastObject]]];
                         [dict setObject:[[reservation allKeys] lastObject] forKey:@"type"];
                         [ordinances addObject:[NSDictionary dictionaryWithDictionary:dict]];
                     }
                     id fixedUpOrdinances = [[NSArray alloc] initWithArray:ordinances];
                     [pool release];
                     if (success)
                         success([fixedUpOrdinances autorelease]);
                 }
                 failure:failure];
}

- (void)reservationReadPersons:(NSArray *)people
                     onSuccess:(NDGenericSuccessBlock)success
                     onFailure:(NDGenericFailureBlock)failure
{
    [self.client getPath:[NSString stringWithFormat:@"/reservation/v1/person/%@", [people componentsJoinedByString:@","]]
              parameters:[self copyOfDefaultURLParametersWithSessionId]
                 success:success
                 failure:failure];
}

@end

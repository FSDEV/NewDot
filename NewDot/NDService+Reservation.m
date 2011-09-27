//
//  NDService+Reservation.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService+Reservation.h"

#import "AFHTTPClient.h"

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
                 success:success
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

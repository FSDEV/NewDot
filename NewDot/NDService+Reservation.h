//
//  NDService+Reservation.h
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService.h"

extern const struct NDReservationType {
    NSString* individual;
    NSString* sealingToParents;
    NSString* sealingToSpouse;
} NDReservationType;

extern const struct NDOrdinanceStatus {
    NSString* notNeeded;
    NSString* reserved;
    NSString* ready;
    NSString* notReady;
    NSString* completed;
    NSString* notAvailable;
    NSString* needMoreInformation;
    NSString* inProgress;
    NSString* onHold;
    NSString* cancelled;
    NSString* deleted;
    NSString* invalid;
} NDOrdinanceStatus;

@interface NDService (Reservation)

/**
 * Request to get the properties associated with the Ordinance Reservation Module.
 */
- (void)reservationPropertiesOnSuccess:(NDSuccessBlock)success
                             onFailure:(NDFailureBlock)failure;

/**
 * List of all reserved ordinances for a given user.
 */
- (void)reservationListForUser:(NSString*)userId
                     onSuccess:(NDSuccessBlock)success
                     onFailure:(NDFailureBlock)failure;

/**
 * Read detailed ordinance reservation information from the Reservation system about the given records.
 */
- (void)reservationReadPersons:(NSArray*)people
                     onSuccess:(NDSuccessBlock)success
                     onFailure:(NDFailureBlock)failure;

@end

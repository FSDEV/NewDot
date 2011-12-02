//
//  NDService+Reservation.h
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService.h"

@class NDHTTPURLOperation;

extern const struct NDReservationType {
    __unsafe_unretained NSString* individual;
    __unsafe_unretained NSString* sealingToParents;
    __unsafe_unretained NSString* sealingToSpouse;
} NDReservationType; // NSString literals do not need memory management

extern const struct NDOrdinanceStatus {
    __unsafe_unretained NSString* notNeeded;
    __unsafe_unretained NSString* reserved;
    __unsafe_unretained NSString* ready;
    __unsafe_unretained NSString* notReady;
    __unsafe_unretained NSString* completed;
    __unsafe_unretained NSString* notAvailable;
    __unsafe_unretained NSString* needMoreInformation;
    __unsafe_unretained NSString* inProgress;
    __unsafe_unretained NSString* onHold;
    __unsafe_unretained NSString* cancelled;
    __unsafe_unretained NSString* deleted;
    __unsafe_unretained NSString* invalid;
} NDOrdinanceStatus; // NSString literals do not need memory management

@interface NDService (Reservation)

- (NDHTTPURLOperation*)reservationOperationPropertiesOnSuccess:(NDSuccessBlock)success
                                                     onFailure:(NDFailureBlock)failure;

/**
 * Request to get the properties associated with the Ordinance Reservation Module.
 */
- (void)reservationPropertiesOnSuccess:(NDSuccessBlock)success
                             onFailure:(NDFailureBlock)failure;

- (NDHTTPURLOperation*)reservationOperationReservationListForUser:(NSString*)userId
                                                        onSuccess:(NDSuccessBlock)success
                                                        onFailure:(NDFailureBlock)failure;

/**
 * List of all reserved ordinances for a given user.
 */
- (void)reservationListForUser:(NSString*)userId
                     onSuccess:(NDSuccessBlock)success
                     onFailure:(NDFailureBlock)failure;

- (NDHTTPURLOperation*)reservationOperationReadPersons:(NSArray*)people
                                             onSuccess:(NDSuccessBlock)success
                                             onFailure:(NDFailureBlock)failure;

/**
 * Read detailed ordinance reservation information from the Reservation system about the given records.
 */
- (void)reservationReadPersons:(NSArray*)people
                     onSuccess:(NDSuccessBlock)success
                     onFailure:(NDFailureBlock)failure;

@end

//
//  NDService+Reservation.h
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService.h"

@class FSURLOperation;

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

/**
 * Request to get the properties associated with the Ordinance Reservation Module.
 */
- (NSURLRequest*)reservationRequestProperties;
- (FSURLOperation*)reservationOperationPropertiesOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (FSURLOperation*)reservationOperationPropertiesOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)reservationPropertiesOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

/**
 * List of all reserved ordinances for a given user.
 */
- (NSURLRequest*)reservationRequestReservationListForUser:(NSString*)userId;
- (FSURLOperation*)reservationOperationReservationListForUser:(NSString*)userId onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (FSURLOperation*)reservationOperationReservationListForUser:(NSString*)userId onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)reservationListForUser:(NSString*)userId onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

/**
 * Read detailed ordinance reservation information from the Reservation system about the given records.
 */
- (NSURLRequest*)reservationRequestReadPersons:(NSArray*)people;
- (FSURLOperation*)reservationOperationReadPersons:(NSArray*)people onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (FSURLOperation*)reservationOperationReadPersons:(NSArray*)people onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)reservationReadPersons:(NSArray*)people onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

@end

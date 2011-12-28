//
//  NDService+Reservation.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService+Reservation.h"
#import "NDService+Implementation.h"

#import "FSURLOperation.h"

#import "NSURL+QueryStringConstructor.h"

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

#pragma mark Properties

- (NSURLRequest*)reservationRequestProperties
{
    NSURL* url = [NSURL URLWithString:@"/reservation/v1/properties" relativeToURL:self.serverUrl queryParameters:self.defaultURLParameters];
    NSURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    return req;
}

- (FSURLOperation*)reservationOperationPropertiesOnSuccess:(NDSuccessBlock)success
                                                 onFailure:(NDFailureBlock)failure
                                          withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self reservationRequestProperties];
    
    FSURLOperation* oper =
    [FSURLOperation URLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success) {
            NSError* err=nil;
            id _payload = [NSJSONSerialization JSONObjectWithData:payload options:kNilOptions error:&err];
            if (err&&failure) failure(resp, payload, err);
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            for (id kvpair in [_payload valueForKey:@"properties"])
                [dict setObject:[kvpair objectForKey:@"value"] forKey:[kvpair objectForKey:@"name"]];
            success(resp, dict, payload);
        }
    } onThread:thread];
    
    return oper;
}

- (FSURLOperation*)reservationOperationPropertiesOnSuccess:(NDSuccessBlock)success
                                                 onFailure:(NDFailureBlock)failure
{
    return [self reservationOperationPropertiesOnSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)reservationPropertiesOnSuccess:(NDSuccessBlock)success
                             onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self reservationOperationPropertiesOnSuccess:success
                                                                          onFailure:failure
                                                                   withTargetThread:nil]];
}

#pragma mark Reservation List

- (NSURLRequest*)reservationRequestReservationListForUser:(NSString*)userId
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"/reservation/v1/list/%@", userId] relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    return req;
}

- (FSURLOperation*)reservationOperationReservationListForUser:(NSString*)userId
                                                    onSuccess:(NDSuccessBlock)success
                                                    onFailure:(NDFailureBlock)failure
                                             withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self reservationRequestReservationListForUser:userId];
    
    FSURLOperation* oper =
    [FSURLOperation URLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success) {
            NSError* err=nil;
            id _payload = [NSJSONSerialization JSONObjectWithData:payload options:kNilOptions error:&err];
            if (err&&failure) failure(resp, payload, err);
            id fixedUpOrdinances = nil;
            @autoreleasepool {
                NSMutableArray* ordinances = [NSMutableArray array];
                NSMutableDictionary* dict;
                for (id reservation in [_payload valueForKeyPath:@"list.reservation"]) {
                    dict = [NSMutableDictionary dictionaryWithDictionary:[reservation objectForKey:[[reservation allKeys] lastObject]]];
                    [dict setObject:[[reservation allKeys] lastObject] forKey:@"type"];
                    [ordinances addObject:[NSDictionary dictionaryWithDictionary:dict]];
                }
                fixedUpOrdinances = [[NSArray alloc] initWithArray:ordinances];
            }
            success(resp, fixedUpOrdinances, payload);
        }
    } onThread:thread];
    
    return oper;
}

- (FSURLOperation*)reservationOperationReservationListForUser:(NSString*)userId
                                                    onSuccess:(NDSuccessBlock)success
                                                    onFailure:(NDFailureBlock)failure
{
    return [self reservationOperationReservationListForUser:userId onSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)reservationListForUser:(NSString*)userId
                     onSuccess:(NDSuccessBlock)success
                     onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self reservationOperationReservationListForUser:userId
                                                                             onSuccess:success
                                                                             onFailure:failure
                                                                      withTargetThread:nil]];
}

#pragma mark Person Read

- (NSURLRequest*)reservationRequestReadPersons:(NSArray*)people
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"/reservation/v1/person/%@", [people componentsJoinedByString:@","]] relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    return req;
}

- (FSURLOperation*)reservationOperationReadPersons:(NSArray*)people
                                         onSuccess:(NDSuccessBlock)success
                                         onFailure:(NDFailureBlock)failure
                                  withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self reservationRequestReadPersons:people];
    
    FSURLOperation* oper =
    [FSURLOperation URLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success) {
            NSError* err=nil;
            id _payload = [NSJSONSerialization JSONObjectWithData:payload options:kNilOptions error:&err];
            if (!err) success(resp, _payload, payload);
            else if (failure) failure(resp, payload, err);
        }
    } onThread:thread];
    
    return oper;
}

- (FSURLOperation*)reservationOperationReadPersons:(NSArray*)people
                                         onSuccess:(NDSuccessBlock)success
                                         onFailure:(NDFailureBlock)failure
{
    return [self reservationOperationReadPersons:people onSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)reservationReadPersons:(NSArray*)people
                     onSuccess:(NDSuccessBlock)success
                     onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self reservationOperationReadPersons:people
                                                                  onSuccess:success
                                                                  onFailure:failure
                                                           withTargetThread:nil]];
}

@end

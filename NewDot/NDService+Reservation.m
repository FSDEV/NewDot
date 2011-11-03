//
//  NDService+Reservation.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService+Reservation.h"
#import "NDService+Implementation.h"

#import "NDHTTPURLOperation.h"

#import "JSONKit.h"

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

- (NDHTTPURLOperation*)reservationOperationPropertiesOnSuccess:(NDSuccessBlock)success
                                                     onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL URLWithString:@"/reservation/v1/properties" relativeToURL:self.serverUrl queryParameters:self.defaultURLParameters];
    NSURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    NDHTTPURLOperation* oper =
    [NDHTTPURLOperation HTTPURLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success) {
            id _payload = [[JSONDecoder decoder] objectWithData:payload];
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            for (id kvpair in [_payload valueForKey:@"properties"])
                [dict setObject:[kvpair objectForKey:@"value"] forKey:[kvpair objectForKey:@"name"]];
            success(resp, [dict autorelease], payload);
        }
    }];
    
    return oper;
}

- (void)reservationPropertiesOnSuccess:(NDSuccessBlock)success
                             onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self reservationOperationPropertiesOnSuccess:success
                                                                          onFailure:failure]];
}

#pragma mark Reservation List

- (NDHTTPURLOperation*)reservationOperationReservationListForUser:(NSString*)userId
                                                        onSuccess:(NDSuccessBlock)success
                                                        onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"/reservation/v1/list/%@", userId] relativeToURL:self.serverUrl queryParameters:[[self copyOfDefaultURLParametersWithSessionId] autorelease]];
    NSURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    NDHTTPURLOperation* oper =
    [NDHTTPURLOperation HTTPURLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success) {
            id _payload = [[JSONDecoder decoder] objectWithData:payload];
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
            success(resp, [fixedUpOrdinances autorelease], payload);
        }
    }];
    
    return oper;
}

- (void)reservationListForUser:(NSString*)userId
                     onSuccess:(NDSuccessBlock)success
                     onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self reservationOperationReservationListForUser:userId
                                                                             onSuccess:success
                                                                             onFailure:failure]];
}

#pragma mark Person Read

- (NDHTTPURLOperation*)reservationOperationReadPersons:(NSArray*)people
                                             onSuccess:(NDSuccessBlock)success
                                             onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"/reservation/v1/person/%@", [people componentsJoinedByString:@","]] relativeToURL:self.serverUrl queryParameters:[[self copyOfDefaultURLParametersWithSessionId] autorelease]];
    NSURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    NDHTTPURLOperation* oper =
    [NDHTTPURLOperation HTTPURLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success) success(resp, [[JSONDecoder decoder] objectWithData:payload], payload);
    }];
    
    return oper;
}

- (void)reservationReadPersons:(NSArray*)people
                     onSuccess:(NDSuccessBlock)success
                     onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self reservationOperationReadPersons:people
                                                                  onSuccess:success
                                                                  onFailure:failure]];
}

@end

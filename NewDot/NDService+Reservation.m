//
//  NDService+Reservation.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService+Reservation.h"
#import "NDService+Implementation.h"

#import "NSURL+QueryStringConstructor.h"

#import "JSONKit.h"

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

- (void)reservationPropertiesOnSuccess:(NDSuccessBlock)success
                             onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL URLWithString:@"/reservation/v1/properties" relativeToURL:self.serverUrl queryParameters:self.defaultURLParameters];
    NSURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
        NSHTTPURLResponse* _resp = (NSHTTPURLResponse*)resp;
        if (asplosion||[_resp statusCode]!=200) {
            if (failure) failure(_resp, payload, asplosion);
        } else if (success) {
            id _payload = [[JSONDecoder decoder] objectWithData:payload];
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            for (id kvpair in [_payload valueForKey:@"properties"])
                [dict setObject:[kvpair objectForKey:@"value"] forKey:[kvpair objectForKey:@"name"]];
            success(_resp, [dict autorelease], payload);
        }
    }];
}

- (void)reservationListForUser:(NSString*)userId
                     onSuccess:(NDSuccessBlock)success
                     onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"/reservation/v1/list/%@", userId] relativeToURL:self.serverUrl queryParameters:[[self copyOfDefaultURLParametersWithSessionId] autorelease]];
    NSURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
        NSHTTPURLResponse* _resp = (NSHTTPURLResponse*)resp;
        if (asplosion||[_resp statusCode]!=200) {
            if (failure) failure(_resp, payload, asplosion);
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
            success(_resp, [fixedUpOrdinances autorelease], payload);
        }
    }];
}

- (void)reservationReadPersons:(NSArray*)people
                     onSuccess:(NDSuccessBlock)success
                     onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"/reservation/v1/person/%@", [people componentsJoinedByString:@","]] relativeToURL:self.serverUrl queryParameters:[[self copyOfDefaultURLParametersWithSessionId] autorelease]];
    NSURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
        NSHTTPURLResponse* _resp = (NSHTTPURLResponse*)resp;
        if (asplosion||[_resp statusCode]!=200) {
            if (failure) failure(_resp, payload, asplosion);
        } else if (success) success(_resp, [[JSONDecoder decoder] objectWithData:payload], payload);
    }];
}

@end

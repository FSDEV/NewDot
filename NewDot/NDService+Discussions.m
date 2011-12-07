//
//  NDService+Discussions.m
//  NewDot
//
//  Created by Christopher Miller on 10/6/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService+Discussions.h"
#import "NDService+Implementation.h"

#import "NDHTTPURLOperation.h"

#import "NSDictionary+Merge.h"
#import "NSURL+QueryStringConstructor.h"


@implementation NDService (Discussions)

#pragma mark Properties

- (NDHTTPURLOperation*)discussionsOperationPropertiesOnSuccess:(NDSuccessBlock)success
                                                     onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL URLWithString:@"/discussions/properties" relativeToURL:self.serverUrl queryParameters:[self defaultURLParameters]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [req addValue:@"application/json" forHTTPHeaderField:@"Accept"]; // BECAUSE FAMILYSEARCH ISN'T CONSISTENT ACROSS MODULES
    
    NDHTTPURLOperation* oper =
    [NDHTTPURLOperation HTTPURLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success) {
            NSError* err;
            id _payload = [NSJSONSerialization JSONObjectWithData:payload options:kNilOptions error:&err];
             // COMMENTED OUT BECAUSE FAMILYSEARCH ISN'T CONSISTENT ACROSS MODULES
/*          if (err&&failure) failure(resp, payload, err); // FAMILYSEARCH ISN'T FREAKING CONSISTENT
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            for (id kvpair in [_payload valueForKey:@"properties"])
                [dict setObject:[kvpair objectForKey:@"value"] forKey:[kvpair objectForKey:@"name"]]; */
            success(resp, _payload, payload);
        }
    }];
    
    return oper;
}

- (void)discussionsPropertiesOnSuccess:(NDSuccessBlock)success
                             onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self discussionsOperationPropertiesOnSuccess:success
                                                                          onFailure:failure]];
}

#pragma mark System Tags

- (NDHTTPURLOperation*)discussionsOperationSystemTagsOnSuccess:(NDSuccessBlock)success
                                                     onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL URLWithString:@"/discussions/systemtags" relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [req addValue:@"application/json" forHTTPHeaderField:@"Accept"];  // BECAUSE FAMILYSEARCH ISN'T CONSISTENT ACROSS MODULES
    
    NDHTTPURLOperation* oper =
    [NDHTTPURLOperation HTTPURLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success) {
            NSError* err=nil;
            id _payload = [NSJSONSerialization JSONObjectWithData:payload options:kNilOptions error:&err];
            if (!err) success(resp, _payload, payload);
            else if (failure) failure(resp, payload, err);
        }
    }];
    
    return oper;
}

- (void)discussionsSystemTagsOnSuccess:(NDSuccessBlock)success
                             onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self discussionsOperationSystemTagsOnSuccess:success
                                                                          onFailure:failure]];
}

#pragma mark Discussions from System Tags

- (NDHTTPURLOperation*)discussionsOperationDiscussionsWithSystemTags:(NSArray*)tags
                                                           onSuccess:(NDSuccessBlock)success
                                                           onFailure:(NDFailureBlock)failure
{
    NSMutableArray* paramTags = [NSMutableArray arrayWithCapacity:[tags count]];
    NSString* allTags = [tags componentsJoinedByString:@","];
    for (id tag in tags)
        [paramTags addObject:[NSString stringWithFormat:@"systemTag=%@",[tag stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSURL* url = [NSURL URLWithString:@"/discussions/discussions" relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId] tailParams:[NSString stringWithFormat:@"systemTag=%@", allTags]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [req addValue:@"application/json" forHTTPHeaderField:@"Accept"];  // BECAUSE FAMILYSEARCH ISN'T CONSISTENT ACROSS MODULES
    
    NDHTTPURLOperation* oper =
    [NDHTTPURLOperation HTTPURLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success){
            NSError* err=nil;
            id _payload = [NSJSONSerialization JSONObjectWithData:payload options:kNilOptions error:&err];
            if (!err) success(resp, _payload, payload);
            else if (failure) failure(resp, payload, err);
        }
    }];
    
    return oper;
}

- (void)discussionsWithSystemTags:(NSArray*)tags
                        onSuccess:(NDSuccessBlock)success
                        onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self discussionsOperationDiscussionsWithSystemTags:tags
                                                                                onSuccess:success
                                                                                onFailure:failure]];
}

#pragma mark Discussions with IDs

- (NDHTTPURLOperation*)discussionsOperationDiscussionsWithIds:(NSArray*)ids
                                                       method:(enum NDRequestMethod)method
                                                    onSuccess:(NDSuccessBlock)success
                                                    onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL URLWithString:@"/discussions/discussions" relativeToURL:self.serverUrl queryParameters:[[self copyOfDefaultURLParametersWithSessionId] dictionaryByMergingDictionary:[NSDictionary dictionaryWithObject:[ids componentsJoinedByString:@","] forKey:@"discussion"]]];;
    NSMutableURLRequest* req = nil;
    switch (method) {
        case POST:
            //            url = [NSURL fs_URLWithString:@"/discussions/discussions" relativeToURL:self.serverUrl queryParameters:[[self copyOfDefaultURLParametersWithSessionId] fs_dictionaryByMergingDictionary:[NSDictionary dictionaryWithObject:[ids componentsJoinedByString:@","] forKey:@"discussion"]]];
            req = [self standardRequestForURL:url HTTPMethod:@"POST"];
            break;
        case GET:
            // TODO: Fix this. It's probably broken in major ways.
            req = [self standardRequestForURL:url HTTPMethod:@"POST"];
            break;
        default:
            [NSException raise:@"net.fsdev.newdot.unrecognised-method" format:@"I can't really do squat with this, bub."];
            break;
    }
    [req addValue:@"application/json" forHTTPHeaderField:@"Accept"];  // BECAUSE FAMILYSEARCH ISN'T CONSISTENT ACROSS MODULES
    
    NDHTTPURLOperation* oper =
    [NDHTTPURLOperation HTTPURLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success) {
            NSError* err=nil;
            id _payload = [NSJSONSerialization JSONObjectWithData:payload options:kNilOptions error:&err];
            if (!err) success(resp, _payload, payload);
            else if (failure) failure(resp, payload, err);
        }
    }];
    
    return oper;
}

- (void)discussionsWithIds:(NSArray*)ids
                    method:(enum NDRequestMethod)method
                 onSuccess:(NDSuccessBlock)success
                 onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self discussionsOperationDiscussionsWithIds:ids
                                                                            method:method
                                                                         onSuccess:success
                                                                         onFailure:failure]];
}

@end

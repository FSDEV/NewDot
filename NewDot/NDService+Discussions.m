//
//  NDService+Discussions.m
//  NewDot
//
//  Created by Christopher Miller on 10/6/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService+Discussions.h"
#import "NDService+Implementation.h"

#import "FSURLOperation.h"

#import "NSDictionary+Merge.h"
#import "NSURL+QueryStringConstructor.h"


@implementation NDService (Discussions)

#pragma mark Properties

- (NSURLRequest*)discussionsRequestProperties
{
    NSURL* url = [NSURL URLWithString:@"/discussions/properties" relativeToURL:self.serverUrl queryParameters:[self defaultURLParameters]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [req addValue:@"application/json" forHTTPHeaderField:@"Accept"]; // BECAUSE FAMILYSEARCH ISN'T CONSISTENT ACROSS MODULES
    
    return req;
}

- (FSURLOperation*)discussionsOperationPropertiesOnSuccess:(NDSuccessBlock)success
                                                 onFailure:(NDFailureBlock)failure
                                          withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self discussionsRequestProperties];

    FSURLOperation* oper =
    [FSURLOperation URLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
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
    } onThread:thread];
    
    return oper;
}

- (FSURLOperation*)discussionsOperationPropertiesOnSuccess:(NDSuccessBlock)success
                                                 onFailure:(NDFailureBlock)failure
{
    return [self discussionsOperationPropertiesOnSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)discussionsPropertiesOnSuccess:(NDSuccessBlock)success
                             onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self discussionsOperationPropertiesOnSuccess:success
                                                                          onFailure:failure
                                                                   withTargetThread:nil]];
}

#pragma mark System Tags

- (NSURLRequest*)discussionsRequestSystemTags
{
    NSURL* url = [NSURL URLWithString:@"/discussions/systemtags" relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [req addValue:@"application/json" forHTTPHeaderField:@"Accept"];  // BECAUSE FAMILYSEARCH ISN'T CONSISTENT ACROSS MODULES
    
    return req;
}

- (FSURLOperation*)discussionsOperationSystemTagsOnSuccess:(NDSuccessBlock)success
                                                 onFailure:(NDFailureBlock)failure
                                          withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self discussionsRequestSystemTags];
    
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

- (FSURLOperation*)discussionsOperationSystemTagsOnSuccess:(NDSuccessBlock)success
                                                 onFailure:(NDFailureBlock)failure
{
    return [self discussionsOperationSystemTagsOnSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)discussionsSystemTagsOnSuccess:(NDSuccessBlock)success
                             onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self discussionsOperationSystemTagsOnSuccess:success
                                                                          onFailure:failure
                                                                   withTargetThread:nil]];
}

#pragma mark Discussions from System Tags

- (NSURLRequest*)discussionsRequestDiscussionsWithSystemTags:(NSArray*)tags
{
    NSMutableArray* paramTags = [NSMutableArray arrayWithCapacity:[tags count]];
    //    NSString* allTags = [tags componentsJoinedByString:@","];
    for (id tag in tags)
        [paramTags addObject:[NSString stringWithFormat:@"systemTag=%@",[tag stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSString* allTags = [paramTags componentsJoinedByString:@"&"];
    NSMutableDictionary* params = [self copyOfDefaultURLParametersWithSessionId];
    [params setObject:@"FamilyTree" forKey:@"productKey"];
    NSURL* url = [NSURL URLWithString:@"/discussions/discussions" relativeToURL:self.serverUrl queryParameters:params tailParams:allTags];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [req addValue:@"application/json" forHTTPHeaderField:@"Accept"];  // BECAUSE FAMILYSEARCH ISN'T CONSISTENT ACROSS MODULES
    
    return req;
}

- (FSURLOperation*)discussionsOperationDiscussionsWithSystemTags:(NSArray*)tags
                                                       onSuccess:(NDSuccessBlock)success
                                                       onFailure:(NDFailureBlock)failure
                                                withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self discussionsRequestDiscussionsWithSystemTags:tags];
    
    FSURLOperation* oper =
    [FSURLOperation URLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else if (success){
            NSError* err=nil;
            id _payload = [NSJSONSerialization JSONObjectWithData:payload options:kNilOptions error:&err];
            if (!err) success(resp, _payload, payload);
            else if (failure) failure(resp, payload, err);
        }
    } onThread:thread];
    
    return oper;
}

- (FSURLOperation*)discussionsOperationDiscussionsWithSystemTags:(NSArray*)tags
                                                       onSuccess:(NDSuccessBlock)success
                                                       onFailure:(NDFailureBlock)failure
{
    return [self discussionsOperationDiscussionsWithSystemTags:tags onSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)discussionsWithSystemTags:(NSArray*)tags
                        onSuccess:(NDSuccessBlock)success
                        onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self discussionsOperationDiscussionsWithSystemTags:tags
                                                                                onSuccess:success
                                                                                onFailure:failure
                                                                         withTargetThread:nil]];
}

#pragma mark Discussions with IDs

- (NSURLRequest*)discussionsRequestDiscussionsWithIds:(NSArray*)ids
                                               method:(enum NDRequestMethod)method
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
    
    return req;
}

- (FSURLOperation*)discussionsOperationDiscussionsWithIds:(NSArray*)ids
                                                   method:(enum NDRequestMethod)method
                                                onSuccess:(NDSuccessBlock)success
                                                onFailure:(NDFailureBlock)failure
                                         withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self discussionsRequestDiscussionsWithIds:ids method:method];
    
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

- (FSURLOperation*)discussionsOperationDiscussionsWithIds:(NSArray*)ids
                                                   method:(enum NDRequestMethod)method
                                                onSuccess:(NDSuccessBlock)success
                                                onFailure:(NDFailureBlock)failure
{
    return [self discussionsOperationDiscussionsWithIds:ids method:method onSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)discussionsWithIds:(NSArray*)ids
                    method:(enum NDRequestMethod)method
                 onSuccess:(NDSuccessBlock)success
                 onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self discussionsOperationDiscussionsWithIds:ids
                                                                            method:method
                                                                         onSuccess:success
                                                                         onFailure:failure
                                                                  withTargetThread:nil]];
}

@end

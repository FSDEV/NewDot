//
//  NDService+Discussions.h
//  NewDot
//
//  Created by Christopher Miller on 10/6/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService.h"

@class NDHTTPURLOperation;

@interface NDService (Discussions)

/**
 * Some relevant properties to working with the Discussions module.
 */
- (NSURLRequest*)discussionsRequestProperties;
- (NDHTTPURLOperation*)discussionsOperationPropertiesOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (NDHTTPURLOperation*)discussionsOperationPropertiesOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (void)discussionsPropertiesOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

/**
 * Returns a list of all system tags created by the currently authenticated user.
 */
- (NSURLRequest*)discussionsRequestSystemTags;
- (NDHTTPURLOperation*)discussionsOperationSystemTagsOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (NDHTTPURLOperation*)discussionsOperationSystemTagsOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)discussionsSystemTagsOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

/**
 * Request for all discussions with the given system tags.
 */
- (NSURLRequest*)discussionsRequestDiscussionsWithSystemTags:(NSArray*)tags;
- (NDHTTPURLOperation*)discussionsOperationDiscussionsWithSystemTags:(NSArray*)tags onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (NDHTTPURLOperation*)discussionsOperationDiscussionsWithSystemTags:(NSArray*)tags onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)discussionsWithSystemTags:(NSArray*)tags onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

/**
 * Request for all discussions with the given discussion IDs.
 *
 * @param method This can be requested using either GET or POST.
 */
- (NSURLRequest*)discussionsRequestDiscussionsWithIds:(NSArray*)ids method:(enum NDRequestMethod)method;
- (NDHTTPURLOperation*)discussionsOperationDiscussionsWithIds:(NSArray*)ids method:(enum NDRequestMethod)method onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (NDHTTPURLOperation*)discussionsOperationDiscussionsWithIds:(NSArray*)ids method:(enum NDRequestMethod)method onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)discussionsWithIds:(NSArray*)ids method:(enum NDRequestMethod)method onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

@end

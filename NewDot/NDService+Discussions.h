//
//  NDService+Discussions.h
//  NewDot
//
//  Created by Christopher Miller on 10/6/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService.h"

@interface NDService (Discussions)

/**
 * Some relevant properties to working with the Discussions module.
 */
- (void)discussionsPropertiesOnSuccess:(NDSuccessBlock)success
                             onFailure:(NDFailureBlock)failure;

/**
 * Returns a list of all system tags created by the currently authenticated user.
 */
- (void)discussionsSystemTagsOnSuccess:(NDSuccessBlock)success
                             onFailure:(NDFailureBlock)failure;

/**
 * Request for all discussions with the given system tags.
 */
- (void)discussionsWithSystemTags:(NSArray*)tags
                        onSuccess:(NDSuccessBlock)success
                        onFailure:(NDFailureBlock)failure;

/**
 * Request for all discussions with the given discussion IDs.
 *
 * @param method This can be requested using either GET or POST.
 */
- (void)discussionsWithIds:(NSArray*)ids
                    method:(enum NDRequestMethod)method
                 onSuccess:(NDSuccessBlock)success
                 onFailure:(NDFailureBlock)failure;

@end

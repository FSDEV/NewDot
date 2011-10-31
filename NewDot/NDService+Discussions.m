//
//  NDService+Discussions.m
//  NewDot
//
//  Created by Christopher Miller on 10/6/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService+Discussions.h"
#import "NSDictionary+Merge.h"

#import "AFHTTPClient.h"

@implementation NDService (Discussions)

- (void)discussionsPropertiesOnSuccess:(NDGenericSuccessBlock)success
                             onFailure:(NDGenericFailureBlock)failure
{
    [self.client getPath:@"/discussions/properties"
              parameters:self.defaultURLParameters
                 success:^(id response) {
                     NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                     for (id kvpair in [response valueForKey:@"properties"])
                         [dict setObject:[kvpair valueForKey:@"value"] forKey:[kvpair valueForKey:@"name"]];
                     if (success)
                         success(dict);
                 }
                 failure:failure];
}

- (void)discussionsSystemTagsOnSuccess:(NDGenericSuccessBlock)success
                             onFailure:(NDGenericFailureBlock)failure
{
    [self.client getPath:@"/discussions/systemtags"
              parameters:[self copyOfDefaultURLParametersWithSessionId]
                 success:success
                 failure:failure];
}

- (void)discussionsWithSystemTags:(NSArray*)tags
                        onSuccess:(NDGenericSuccessBlock)success
                        onFailure:(NDGenericFailureBlock)failure
{
    NSMutableArray* paramTags = [NSMutableArray arrayWithCapacity:[tags count]];
    for (id tag in tags)
        [paramTags addObject:[NSString stringWithFormat:@"systemTag=%@",tag]];
    [self.client getPath:[NSString stringWithFormat:@"/discussions/discussions?%@", [paramTags componentsJoinedByString:@"&"]]
              parameters:[[self copyOfDefaultURLParametersWithSessionId] fs_dictionaryByMergingDictionary:[NSDictionary dictionaryWithObject:@"" forKey:@"productKey"]]
                 success:success
                 failure:failure];
}

- (void)discussionsWithIds:(NSArray*)ids
                    method:(enum NDRequestMethod)method
                 onSuccess:(NDGenericSuccessBlock)success
                 onFailure:(NDGenericFailureBlock)failure
{
    switch (method) {
        case POST:
            [self.client postPath:@"/discussions/discussions"
                       parameters:[[self copyOfDefaultURLParametersWithSessionId] fs_dictionaryByMergingDictionary:[NSDictionary dictionaryWithObject:[ids componentsJoinedByString:@","] forKey:@"discussion"]]
                          success:success
                          failure:failure];
            break;
        case GET:
            // TODO: Fix this. It's probably broken in major ways.
            [self.client getPath:@"/discussions/discussions"
                      parameters:[[self copyOfDefaultURLParametersWithSessionId] fs_dictionaryByMergingDictionary:[NSDictionary dictionaryWithObject:[ids componentsJoinedByString:@","] forKey:@"discussion"]]
                         success:success
                         failure:failure];
            break;
        default:
            failure(nil, [NSError errorWithDomain:@"net.fsdev.newdot.unrecognised-method" code:-1 userInfo:nil]);
            break;
    }
}

@end

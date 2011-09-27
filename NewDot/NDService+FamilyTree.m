//
//  NDService+FamilyTree.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService+FamilyTree.h"

#import "AFHTTPClient.h"
#import "NSDictionary+Merge.h"

const struct NDFamilyTreeReadPersonsRequestParameters NDFamilyTreeReadPersonsRequestParameters = {
    .names              = @"names",
    .genders            = @"genders",
    .events             = @"events",
    .characteristics    = @"characteristics",
    .exists             = @"exists",
    .values             = @"values",
    .ordinances         = @"ordinances",
    .assertions         = @"assertions",
    .families           = @"families",
    .children           = @"children",
    .parents            = @"parents",
    .personas           = @"personas",
    .changes            = @"changes",
    .properties         = @"properties",
    .identifiers        = @"identifiers",
    .dispositions       = @"dispositions",
    .contributors       = @"contributors",
    .locale             = @"locale"
};

const struct NDFamilyTreeReadPersonsRequestKeys NDFamilyTreeReadPersonsRequestKeys = {
    .none           = @"none",
    .summary        = @"summary",
    .all            = @"all",
    .standard       = @"standard",
    .mine           = @"mine",
    .affirming      = @"affirming",
    .disputing      = @"disputing"
};

@implementation NDService (FamilyTree)

- (void)familyTreePropertiesOnSuccess:(NDGenericSuccessBlock)success
                            onFailure:(NDGenericFailureBlock)failure
{
    [self.client getPath:@"/familytree/v2/properties"
              parameters:self.defaultURLParameters
                 success:^(id response) {
                     NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                     for (id kvpair in [response valueForKey:@"properties"])
                         [dict setObject:[kvpair valueForKey:@"value"] forKey:[kvpair valueForKey:@"name"]];
                     if (success)
                         success(dict);
                 }
                 failure:failure];
}

- (void)familyTreeUserProfileOnSuccess:(NDGenericSuccessBlock)success
                             onFailure:(NDGenericFailureBlock)failure
{
    [self.client getPath:@"/familytree/v2/user"
              parameters:[self copyOfDefaultURLParametersWithSessionId]
                 success:success
                 failure:failure];
}

- (void)familyTreeReadPersons:(NSArray *)people
               withParameters:(NSDictionary *)parameters
                    onSuccess:(NDGenericSuccessBlock)success
                    onFailure:(NDGenericFailureBlock)failure
{
    [self.client getPath:(people)?[NSString stringWithFormat:@"/familytree/v2/person/%@", [people componentsJoinedByString:@","]]:@"/familytree/v2/person"
              parameters:[[self copyOfDefaultURLParametersWithSessionId] fs_dictionaryByMergingDictionary:(parameters)?:[NSDictionary dictionary]]
                 success:success
                 failure:failure];
}

@end

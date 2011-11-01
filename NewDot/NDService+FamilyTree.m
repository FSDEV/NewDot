//
//  NDService+FamilyTree.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService+FamilyTree.h"
#import "NDService+Implementation.h"

#import "JSONKit.h"
#import "NSDictionary+Merge.h"
#import "NSString+LastWord.h"
#import "NSURL+QueryStringConstructor.h"

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

@interface NDService (FamilyTree_private)

- (NSDictionary*)readPersonsValidKeys;

@end

@implementation NDService (FamilyTree)

- (void)familyTreePropertiesOnSuccess:(NDGenericSuccessBlock)success
                            onFailure:(NDGenericFailureBlock)failure
{
    NSURL* url = [NSURL fs_URLWithString:@"/familytree/v2/properties" relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
        NSHTTPURLResponse* _resp = (NSHTTPURLResponse*)resp;
        if (asplosion||[_resp statusCode]!=200) {
            if (failure)
                failure(_resp, asplosion);
        } else {
            if (success) {
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                id _payload = [[JSONDecoder decoder] objectWithData:payload];
                for (id kvpair in [_payload valueForKey:@"properties"])
                    [dict setObject:[kvpair valueForKey:@"value"] forKey:[kvpair valueForKey:@"name"]];
                success(dict);
            }
        }
    }];
}

- (void)familyTreeUserProfileOnSuccess:(NDGenericSuccessBlock)success
                             onFailure:(NDGenericFailureBlock)failure
{
    NSURL* url = [NSURL fs_URLWithString:@"/familytree/v2/user" relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
        NSHTTPURLResponse* _resp = (NSHTTPURLResponse*)resp;
        if (asplosion||[_resp statusCode]!=200) {
            if (failure) failure(_resp, asplosion);
        } else if (success) success([[JSONDecoder decoder] objectWithData:payload]);
    }];
}

- (void)familyTreeReadPersons:(NSArray*)people
               withParameters:(NSDictionary*)parameters
                    onSuccess:(NDGenericSuccessBlock)success
                    onFailure:(NDGenericFailureBlock)failure
{
    NSDictionary* validKeys = [self readPersonsValidKeys];
    NSArray* keys = [validKeys allKeys];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        if (![keys containsObject:key])
            return;
        else if (![[validKeys objectForKey:key] containsObject:obj])
            [NSException raise:NSInternalInconsistencyException format:@"Value %@ is not valid for parameter %@", obj, key];
    }];
    NSURL* url = [NSURL fs_URLWithString:(people)?[NSString stringWithFormat:@"/familytree/v2/person/%@", [people componentsJoinedByString:@","]]:@"/familytree/v2/person" relativeToURL:self.serverUrl queryParameters:[[self copyOfDefaultURLParametersWithSessionId] fs_dictionaryByMergingDictionary:(parameters)?:[NSDictionary dictionary]]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
        NSHTTPURLResponse* _resp = (NSHTTPURLResponse*)resp;
        if (asplosion||[_resp statusCode]!=200) {
            if (failure) failure(_resp, asplosion);
        } else if (success) success([[JSONDecoder decoder] objectWithData:payload]);
    }];
}

- (void)familyTreeDiscussionsForPerson:(NSString*)personId
                             onSuccess:(NDGenericSuccessBlock)success
                             onFailure:(NDParsedFailureBlock)failure
{
    NSURL* url = [NSURL fs_URLWithString:[NSString stringWithFormat:@"/familytree/v2/person/%@/discussion", personId] relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
        NSHTTPURLResponse* _resp = (NSHTTPURLResponse*)resp;
        if (asplosion||[_resp statusCode]!=200) {
            if (failure) failure([_resp statusCode], _resp, asplosion);
        } else if (success) success([[JSONDecoder decoder] objectWithData:payload]);
    }];
}

- (NSArray*)familyTreeLocales
{
    static NSArray* locales;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locales = [[NSArray alloc] initWithObjects:@"ar", @"be", @"bg", @"ca", @"cs", @"da", @"de", @"el", @"en", @"es", @"et", @"fi", @"fr", @"ga", @"hr", @"hu", @"in", @"is", @"it", @"iw", @"ja", @"ko", @"lt", @"lv", @"mk", @"ms", @"mt", @"nl", @"no", @"pl", @"pt", @"ro", @"ru", @"sk", @"sl", @"sq", @"sr", @"sv", @"th", @"tr", @"uk", @"vi", @"zh", nil];
    });
    return locales;
}

#pragma mark FamilyTree+Private

- (NSArray*)ft_noneSummaryAll
{
    static NSArray* noneSummaryAllKeys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        noneSummaryAllKeys = [[NSArray alloc] initWithObjects:NDFamilyTreeReadPersonsRequestKeys.none, NDFamilyTreeReadPersonsRequestKeys.summary, NDFamilyTreeReadPersonsRequestKeys.all, nil];
    });
    return noneSummaryAllKeys;
}

- (NSArray*)ft_noneAll
{
    static NSArray* noneAllKeys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        noneAllKeys = [[NSArray alloc] initWithObjects:NDFamilyTreeReadPersonsRequestKeys.none, NDFamilyTreeReadPersonsRequestKeys.all, nil];
    });
    return noneAllKeys;
}

- (NSDictionary*)readPersonsValidKeys
{
    static NSDictionary* validKeys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        validKeys = [[NSDictionary alloc] initWithObjectsAndKeys:
                     [self ft_noneSummaryAll], NDFamilyTreeReadPersonsRequestParameters.names,
                     [self ft_noneSummaryAll], NDFamilyTreeReadPersonsRequestParameters.genders,
                     [NSArray arrayWithObjects:NDFamilyTreeReadPersonsRequestKeys.none, NDFamilyTreeReadPersonsRequestKeys.summary, NDFamilyTreeReadPersonsRequestKeys.standard, NDFamilyTreeReadPersonsRequestKeys.all, nil], NDFamilyTreeReadPersonsRequestParameters.events,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.characteristics,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.exists,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.values,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.ordinances,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.assertions,
                     [self ft_noneSummaryAll], NDFamilyTreeReadPersonsRequestParameters.families,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.children,
                     [self ft_noneSummaryAll], NDFamilyTreeReadPersonsRequestParameters.parents,
                     [NSArray arrayWithObjects:NDFamilyTreeReadPersonsRequestKeys.none, NDFamilyTreeReadPersonsRequestKeys.all, NDFamilyTreeReadPersonsRequestKeys.mine, nil], NDFamilyTreeReadPersonsRequestParameters.personas,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.changes,
                     [self ft_noneSummaryAll], NDFamilyTreeReadPersonsRequestParameters.properties,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.identifiers,
                     [NSArray arrayWithObjects:NDFamilyTreeReadPersonsRequestKeys.all, NDFamilyTreeReadPersonsRequestKeys.affirming, NDFamilyTreeReadPersonsRequestKeys.disputing, nil], NDFamilyTreeReadPersonsRequestParameters.dispositions,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.contributors,
                     [self familyTreeLocales], NDFamilyTreeReadPersonsRequestParameters.locale,
                     nil];
    });
    return validKeys;
}

@end

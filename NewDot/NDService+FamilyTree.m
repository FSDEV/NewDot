//
//  NDService+FamilyTree.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService+FamilyTree.h"
#import "NDService+Implementation.h"

#import "FSURLOperation.h"

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

const struct NDFamilyTreeReadPersonsRequestValues NDFamilyTreeReadPersonsRequestValues = {
    .none           = @"none",
    .summary        = @"summary",
    .all            = @"all",
    .standard       = @"standard",
    .mine           = @"mine",
    .affirming      = @"affirming",
    .disputing      = @"disputing"
};

const struct NDFamilyTreeReadType NDFamilyTreeReadType = {
    .person = @"person",
    .persona = @"persona"
};

const struct NDFamilyTreeRelationshipType NDFamilyTreeRelationshipType = {
    .parent = @"parent",
    .spouse = @"spouse",
    .child = @"child"
};

@interface NDService (FamilyTree_private)

- (NSDictionary*)readPersonsValidKeys;

@end

@implementation NDService (FamilyTree)

- (NSArray*)familyTreeLocales
{
    static NSArray* locales;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locales = [[NSArray alloc] initWithObjects:@"ar", @"be", @"bg", @"ca", @"cs", @"da", @"de", @"el", @"en", @"es", @"et", @"fi", @"fr", @"ga", @"hr", @"hu", @"in", @"is", @"it", @"iw", @"ja", @"ko", @"lt", @"lv", @"mk", @"ms", @"mt", @"nl", @"no", @"pl", @"pt", @"ro", @"ru", @"sk", @"sl", @"sq", @"sr", @"sv", @"th", @"tr", @"uk", @"vi", @"zh", nil];
    });
    return locales;
}

#pragma mark Properties

- (NSURLRequest*)familyTreeRequestProperties
{
    NSURL* url = [NSURL URLWithString:@"/familytree/v2/properties" relativeToURL:self.serverUrl queryParameters:[self defaultURLParameters]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    return req;
}

- (FSURLOperation*)familyTreeOperationPropertiesOnSuccess:(NDSuccessBlock)success
                                                onFailure:(NDFailureBlock)failure
                                         withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self familyTreeRequestProperties];
    
    FSURLOperation* oper =
    [FSURLOperation URLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse* resp, NSData* payload, NSError* asplosion) {
        if (asplosion||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, asplosion);
        } else {
            if (success) {
                NSError* err=nil;
                id _payload = [NSJSONSerialization JSONObjectWithData:payload options:kNilOptions error:&err];
                if (err&&failure) failure(resp, payload, err);
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                for (id kvpair in [_payload valueForKey:@"properties"])
                    [dict setObject:[kvpair valueForKey:@"value"] forKey:[kvpair valueForKey:@"name"]];
                success(resp, dict, payload);
            }
        }
    } onThread:thread];
    
    return oper;
}

- (FSURLOperation*)familyTreeOperationPropertiesOnSuccess:(NDSuccessBlock)success
                                                onFailure:(NDFailureBlock)failure
{
    return [self familyTreeOperationPropertiesOnSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)familyTreePropertiesOnSuccess:(NDSuccessBlock)success
                            onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self familyTreeOperationPropertiesOnSuccess:success
                                                                         onFailure:failure
                                                                  withTargetThread:nil]];
}

#pragma mark Profile

- (NSURLRequest*)familyTreeRequestProfile
{
    NSURL* url = [NSURL URLWithString:@"/familytree/v2/user" relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    return req;
}

- (FSURLOperation*)familyTreeOperationUserProfileOnSuccess:(NDSuccessBlock)success
                                                 onFailure:(NDFailureBlock)failure
                                          withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self familyTreeRequestProfile];
    
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

- (FSURLOperation*)familyTreeOperationUserProfileOnSuccess:(NDSuccessBlock)success
                                                 onFailure:(NDFailureBlock)failure
{
    return [self familyTreeOperationUserProfileOnSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)familyTreeUserProfileOnSuccess:(NDSuccessBlock)success
                             onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self familyTreeOperationUserProfileOnSuccess:success
                                                                          onFailure:failure
                                                                   withTargetThread:nil]];
}

#pragma mark Read Persons

- (NSURLRequest*)familyTreeRequestPersons:(NSArray*)people
                           withParameters:(NSDictionary*)parameters
{
    NSDictionary* validKeys = [self readPersonsValidKeys];
    NSArray* keys = [validKeys allKeys];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        if (![keys containsObject:key])
            return;
        else if (![[validKeys objectForKey:key] containsObject:obj])
            [NSException raise:NSInternalInconsistencyException format:@"Value %@ is not valid for parameter %@", obj, key];
    }];
    NSURL* url = [NSURL URLWithString:(people)?[NSString stringWithFormat:@"/familytree/v2/person/%@", [people componentsJoinedByString:@","]]:@"/familytree/v2/person" relativeToURL:self.serverUrl queryParameters:[[self copyOfDefaultURLParametersWithSessionId] dictionaryByMergingDictionary:(parameters)?:[NSDictionary dictionary]]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    return req;
}

- (FSURLOperation*)familyTreeOperationReadPersons:(NSArray*)people
                                   withParameters:(NSDictionary*)parameters
                                        onSuccess:(NDSuccessBlock)success
                                        onFailure:(NDFailureBlock)failure
                                 withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self familyTreeRequestPersons:people withParameters:parameters];
    
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

- (FSURLOperation*)familyTreeOperationReadPersons:(NSArray*)people
                                   withParameters:(NSDictionary*)parameters
                                        onSuccess:(NDSuccessBlock)success
                                        onFailure:(NDFailureBlock)failure
{
    return [self familyTreeOperationReadPersons:people withParameters:parameters onSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)familyTreeReadPersons:(NSArray*)people
               withParameters:(NSDictionary*)parameters
                    onSuccess:(NDSuccessBlock)success
                    onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self familyTreeOperationReadPersons:people
                                                            withParameters:parameters
                                                                 onSuccess:success
                                                                 onFailure:failure
                                                          withTargetThread:nil]];
}

#pragma mark Discussions For Person

- (NSURLRequest*)familyTreeRequestDiscussionsForPerson:(NSString*)personId
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"/familytree/v2/person/%@/discussion", personId] relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    return req;
}

- (FSURLOperation*)familyTreeOperationDiscussionsForPerson:(NSString*)personId
                                                 onSuccess:(NDSuccessBlock)success
                                                 onFailure:(NDFailureBlock)failure
                                          withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self familyTreeRequestDiscussionsForPerson:personId];
    
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

- (FSURLOperation*)familyTreeOperationDiscussionsForPerson:(NSString*)personId
                                                 onSuccess:(NDSuccessBlock)success
                                                 onFailure:(NDFailureBlock)failure
{
    return [self familyTreeOperationDiscussionsForPerson:personId onSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)familyTreeDiscussionsForPerson:(NSString*)personId
                             onSuccess:(NDSuccessBlock)success
                             onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self familyTreeOperationDiscussionsForPerson:personId
                                                                          onSuccess:success
                                                                          onFailure:failure
                                                                   withTargetThread:nil]];
}

#pragma mark Relationship Read

- (NSURLRequest*)familyTreeRequestRelationshipOfReadType:(NSString*)readType
                                               forPerson:(NSString*)personId
                                        relationshipType:(NSString*)relationshipType
                                               toPersons:(NSArray*)personIds
                                          withParameters:(NSDictionary*)parameters
{
    NSAssert([readType isEqualToString:NDFamilyTreeReadType.person]||[readType isEqualToString:NDFamilyTreeReadType.persona] , @"Invalid read type!");
    NSAssert(personId!=nil, @"Person[a] ID is nil!");
    NSAssert([relationshipType isEqualToString:NDFamilyTreeRelationshipType.parent]||[relationshipType isEqualToString:NDFamilyTreeRelationshipType.spouse]||[relationshipType isEqualToString:NDFamilyTreeRelationshipType.child], @"Invalid relationship type!");
    
    NSArray* _personIds = personIds?:[NSArray array];
    
    NSMutableDictionary* queryParams = [self copyOfDefaultURLParametersWithSessionId];
    [queryParams addEntriesFromDictionary:parameters];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"/familytree/v2/%@/%@/%@/%@", readType, personId, relationshipType, [_personIds componentsJoinedByString:@","]] relativeToURL:self.serverUrl queryParameters:queryParams];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    return req;
}

- (FSURLOperation*)familyTreeOperationRelationshipOfReadType:(NSString*)readType
                                                   forPerson:(NSString*)personId
                                            relationshipType:(NSString*)relationshipType
                                                   toPersons:(NSArray*)personIds
                                              withParameters:(NSDictionary*)parameters
                                                   onSuccess:(NDSuccessBlock)success
                                                   onFailure:(NDFailureBlock)failure
                                            withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self familyTreeRequestRelationshipOfReadType:readType forPerson:personId relationshipType:relationshipType toPersons:personIds withParameters:parameters];
    
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

- (FSURLOperation*)familyTreeOperationRelationshipOfReadType:(NSString*)readType
                                                   forPerson:(NSString*)personId
                                            relationshipType:(NSString*)relationshipType
                                                   toPersons:(NSArray*)personIds
                                              withParameters:(NSDictionary*)parameters
                                                   onSuccess:(NDSuccessBlock)success
                                                   onFailure:(NDFailureBlock)failure
{
    return [self familyTreeOperationRelationshipOfReadType:readType forPerson:personId relationshipType:relationshipType toPersons:personIds withParameters:parameters onSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)familyTreeRelationshipOfReadType:(NSString*)readType
                               forPerson:(NSString*)personId
                        relationshipType:(NSString*)relationshipType
                               toPersons:(NSArray*)personIds
                          withParameters:(NSDictionary*)parameters
                               onSuccess:(NDSuccessBlock)success
                               onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self familyTreeOperationRelationshipOfReadType:readType
                                                                            forPerson:personId
                                                                     relationshipType:relationshipType
                                                                            toPersons:personIds
                                                                       withParameters:parameters
                                                                            onSuccess:success
                                                                            onFailure:failure
                                                                     withTargetThread:nil]];
}

#pragma mark FamilyTree+Private

- (NSArray*)ft_noneSummaryAll
{
    static NSArray* noneSummaryAllKeys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        noneSummaryAllKeys = [[NSArray alloc] initWithObjects:NDFamilyTreeReadPersonsRequestValues.none, NDFamilyTreeReadPersonsRequestValues.summary, NDFamilyTreeReadPersonsRequestValues.all, nil];
    });
    return noneSummaryAllKeys;
}

- (NSArray*)ft_noneAll
{
    static NSArray* noneAllKeys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        noneAllKeys = [[NSArray alloc] initWithObjects:NDFamilyTreeReadPersonsRequestValues.none, NDFamilyTreeReadPersonsRequestValues.all, nil];
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
                     [NSArray arrayWithObjects:NDFamilyTreeReadPersonsRequestValues.none, NDFamilyTreeReadPersonsRequestValues.summary, NDFamilyTreeReadPersonsRequestValues.standard, NDFamilyTreeReadPersonsRequestValues.all, nil], NDFamilyTreeReadPersonsRequestParameters.events,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.characteristics,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.exists,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.values,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.ordinances,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.assertions,
                     [self ft_noneSummaryAll], NDFamilyTreeReadPersonsRequestParameters.families,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.children,
                     [self ft_noneSummaryAll], NDFamilyTreeReadPersonsRequestParameters.parents,
                     [NSArray arrayWithObjects:NDFamilyTreeReadPersonsRequestValues.none, NDFamilyTreeReadPersonsRequestValues.all, NDFamilyTreeReadPersonsRequestValues.mine, nil], NDFamilyTreeReadPersonsRequestParameters.personas,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.changes,
                     [self ft_noneSummaryAll], NDFamilyTreeReadPersonsRequestParameters.properties,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.identifiers,
                     [NSArray arrayWithObjects:NDFamilyTreeReadPersonsRequestValues.all, NDFamilyTreeReadPersonsRequestValues.affirming, NDFamilyTreeReadPersonsRequestValues.disputing, nil], NDFamilyTreeReadPersonsRequestParameters.dispositions,
                     [self ft_noneAll], NDFamilyTreeReadPersonsRequestParameters.contributors,
                     [self familyTreeLocales], NDFamilyTreeReadPersonsRequestParameters.locale,
                     nil];
    });
    return validKeys;
}

@end

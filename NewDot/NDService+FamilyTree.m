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

#import "NSData+StringValue.h"

const struct NDFamilyTreeReadRequestParameter NDFamilyTreeReadRequestParameter = {
    .names              = @"names"          ,
    .genders            = @"genders"        ,
    .events             = @"events"         ,
    .characteristics    = @"characteristics",
    .exists             = @"exists"         ,
    .values             = @"values"         ,
    .ordinances         = @"ordinances"     ,
    .assertions         = @"assertions"     ,
    .families           = @"families"       ,
    .children           = @"children"       ,
    .parents            = @"parents"        ,
    .personas           = @"personas"       ,
    .changes            = @"changes"        ,
    .properties         = @"properties"     ,
    .identifiers        = @"identifiers"    ,
    .dispositions       = @"dispositions"   ,
    .contributors       = @"contributors"   ,
    .notes              = @"notes"          ,
    .citations          = @"citations"      ,
    .locale             = @"locale"
};

NSArray* NDFamilyTreeAllReadRequestParameters(enum NDFamilyTreeReqType type)
{
    static NSArray* _person,* _relationship;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _person = [[NSArray alloc] initWithObjects:
                  NDFamilyTreeReadRequestParameter.names,        NDFamilyTreeReadRequestParameter.genders,   NDFamilyTreeReadRequestParameter.events,        NDFamilyTreeReadRequestParameter.characteristics,
                  NDFamilyTreeReadRequestParameter.exists,       NDFamilyTreeReadRequestParameter.values,    NDFamilyTreeReadRequestParameter.ordinances,    NDFamilyTreeReadRequestParameter.assertions,
                  NDFamilyTreeReadRequestParameter.families,     NDFamilyTreeReadRequestParameter.children,  NDFamilyTreeReadRequestParameter.parents,       NDFamilyTreeReadRequestParameter.personas,
                  NDFamilyTreeReadRequestParameter.changes,      NDFamilyTreeReadRequestParameter.properties,NDFamilyTreeReadRequestParameter.identifiers,   NDFamilyTreeReadRequestParameter.dispositions,
                  NDFamilyTreeReadRequestParameter.contributors, NDFamilyTreeReadRequestParameter.locale,    nil];
        _relationship = [_person mutableCopy];
        [(NSMutableArray*)_relationship addObject:NDFamilyTreeReadRequestParameter.notes];
        [(NSMutableArray*)_relationship addObject:NDFamilyTreeReadRequestParameter.citations];
        _relationship = [_relationship copy];
    });
    if (person == type) return _person;
    else return _relationship;
}

const struct NDFamilyTreeReadRequestValue NDFamilyTreeReadRequestValue = {
    .none               = @"none"           ,
    .summary            = @"summary"        ,
    .all                = @"all"            ,
    .standard           = @"standard"       ,
    .mine               = @"mine"           ,
    .affirming          = @"affirming"      ,
    .disputing          = @"disputing"
};

const struct NDFamilyTreeReadType NDFamilyTreeReadType = {
    .person             = @"person"         ,
    .persona            = @"persona"
};

const struct NDFamilyTreeRelationshipType NDFamilyTreeRelationshipType = {
    .parent             = @"parent"         ,
    .spouse             = @"spouse"         ,
    .child              = @"child"
};

NSArray* NDFamilyTreeAllRelationshipTypes()
{
    static NSArray* a;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        a = [[NSArray alloc] initWithObjects:NDFamilyTreeRelationshipType.parent, NDFamilyTreeRelationshipType.spouse, NDFamilyTreeRelationshipType.child, nil];
    });
    return a;
}

const struct NDFamilyTreeAssertionType NDFamilyTreeAssertionType = {
    .characteristics    = @"characteristics",
    .citations          = @"citations"      ,
    .events             = @"events"         ,
    .exists             = @"exists"         ,
    .genders            = @"genders"        ,
    .names              = @"names"          ,
    .ordinances         = @"ordinances"     ,
    .notes              = @"notes"
};

NSArray* NDFamilyTreeAllAssertionTypes()
{
    static NSArray* a;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        a = [[NSArray alloc] initWithObjects:
             NDFamilyTreeAssertionType.characteristics,     NDFamilyTreeAssertionType.citations,    NDFamilyTreeAssertionType.events,
             NDFamilyTreeAssertionType.exists,              NDFamilyTreeAssertionType.genders,      NDFamilyTreeAssertionType.names,
             NDFamilyTreeAssertionType.ordinances,          NDFamilyTreeAssertionType.notes,        nil];
    });
    return a;
}

NSDictionary* NDFamilyTreeAllPersonReadValues()
{
    static NSDictionary* d;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        d=[NSDictionary dictionaryWithObjectsAndKeys:
           NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestParameter.names,
           NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestParameter.genders,
           NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestParameter.events,
           NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestParameter.characteristics,
           NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestParameter.exists,
           NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestParameter.values,
           NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestParameter.ordinances,
           NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestParameter.assertions,
           NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestParameter.families,
           NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestParameter.children,
           NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestParameter.parents,
           NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestParameter.personas,
           NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestParameter.properties,
           NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestParameter.identifiers,
           NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestParameter.dispositions,
           NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestParameter.contributors, nil];
    });
    return d;
}

NSDictionary* NDFamilyTreeAllRelationshipReadValues()
{
    static NSDictionary* d;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        d=[NSDictionary dictionaryWithObjectsAndKeys:
           NDFamilyTreeReadRequestValue.all,  NDFamilyTreeReadRequestParameter.events,
           NDFamilyTreeReadRequestValue.all,  NDFamilyTreeReadRequestParameter.characteristics,
           NDFamilyTreeReadRequestValue.all,  NDFamilyTreeReadRequestParameter.exists,
           NDFamilyTreeReadRequestValue.all,  NDFamilyTreeReadRequestParameter.values,
           NDFamilyTreeReadRequestValue.all,  NDFamilyTreeReadRequestParameter.ordinances,
           NDFamilyTreeReadRequestValue.all,  NDFamilyTreeReadRequestParameter.assertions,
           NDFamilyTreeReadRequestValue.all,  NDFamilyTreeReadRequestParameter.dispositions,
           NDFamilyTreeReadRequestValue.all,  NDFamilyTreeReadRequestParameter.contributors,
           NDFamilyTreeReadRequestValue.all,  NDFamilyTreeReadRequestParameter.personas,
           NDFamilyTreeReadRequestValue.all,  NDFamilyTreeReadRequestParameter.notes,
           NDFamilyTreeReadRequestValue.all,  NDFamilyTreeReadRequestParameter.citations, nil];
    });
    return d;
}

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

#pragma mark Update Person (Also does delete)

- (NSURLRequest *)familyTreeRequestPersonUpdate:(NSString *)personId assertions:(NSDictionary *)assertions
{
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"/familytree/v2/person%@",
                                                    personId==nil?@"":[NSString stringWithFormat:@"/%@",personId]]
                         relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest * req = [self standardRequestForURL:url HTTPMethod:@"POST"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary * body = [[NSMutableDictionary alloc] init];
    NSMutableArray * persons = [[NSMutableArray alloc] init];
    NSMutableDictionary * person = [[NSMutableDictionary alloc] init];
    [person setObject:assertions forKey:@"assertions"];
    [persons addObject:person];
    [body setObject:persons forKey:@"persons"];
    
    NSError * err;
    NSData * reqBody = [NSJSONSerialization dataWithJSONObject:body options:[self jsonWritingOptions] error:&err];
    
    [req setHTTPBody:reqBody];
    
    return req;
}

- (FSURLOperation *)familytreeOperationPersonUpdate:(NSString *)personId assertions:(NSDictionary *)assertions onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread *)thread
{
    NSURLRequest * req = [self familyTreeRequestPersonUpdate:personId assertions:assertions];
    
    FSURLOperation * oper =
    [FSURLOperation URLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse *resp, NSData *payload, NSError *error) {
        if (error||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, error);
        } else if (success) {
            NSError * err;
            id _payload = [NSJSONSerialization JSONObjectWithData:payload options:kNilOptions error:&err];
            if (!err) success(resp, _payload, payload);
            else if (failure) failure(resp, payload, err);
        }
    } onThread:thread];
    
    return oper;
}

- (void)familyTreePersonUpdate:(NSString *)personId assertions:(NSDictionary *)assertions onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self familytreeOperationPersonUpdate:personId assertions:assertions onSuccess:success onFailure:failure withTargetThread:nil]];
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
                                               forPerson:(NSString *)_forPersonId
                                        relationshipType:(NSString*)relationshipType
                                               toPersons:(id)_toPersonIds
                                          withParameters:(NSDictionary*)parameters
{
    NSAssert([readType isEqualToString:NDFamilyTreeReadType.person]||[readType isEqualToString:NDFamilyTreeReadType.persona] , @"Invalid read type!");
    NSArray * toPersonIds = NDCoalesceUnknownToArray(_toPersonIds);
    NSAssert([relationshipType isEqualToString:NDFamilyTreeRelationshipType.parent]||[relationshipType isEqualToString:NDFamilyTreeRelationshipType.spouse]||[relationshipType isEqualToString:NDFamilyTreeRelationshipType.child], @"Invalid relationship type!");
    
    NSMutableDictionary* queryParams = [self copyOfDefaultURLParametersWithSessionId];
    [queryParams addEntriesFromDictionary:parameters];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"/familytree/v2/%@/%@/%@%@%@", readType, _forPersonId, relationshipType, [toPersonIds count]==0?@"":@"/", [toPersonIds componentsJoinedByString:@","]] relativeToURL:self.serverUrl queryParameters:queryParams];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    
    return req;
}

- (FSURLOperation*)familyTreeOperationRelationshipOfReadType:(NSString*)readType
                                                   forPerson:(NSString *)forPersonId
                                            relationshipType:(NSString*)relationshipType
                                                   toPersons:(id)toPersonIds
                                              withParameters:(NSDictionary*)parameters
                                                   onSuccess:(NDSuccessBlock)success
                                                   onFailure:(NDFailureBlock)failure
                                            withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self familyTreeRequestRelationshipOfReadType:readType forPerson:forPersonId relationshipType:relationshipType toPersons:toPersonIds withParameters:parameters];
    
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
                                                   forPerson:(NSString *)forPersonId
                                            relationshipType:(NSString*)relationshipType
                                                   toPersons:(id)toPersonIds
                                              withParameters:(NSDictionary*)parameters
                                                   onSuccess:(NDSuccessBlock)success
                                                   onFailure:(NDFailureBlock)failure
{
    return [self familyTreeOperationRelationshipOfReadType:readType forPerson:forPersonId relationshipType:relationshipType toPersons:toPersonIds withParameters:parameters onSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)familyTreeRelationshipOfReadType:(NSString*)readType
                               forPerson:(NSString *)forPersonId
                        relationshipType:(NSString*)relationshipType
                               toPersons:(id)toPersonIds
                          withParameters:(NSDictionary*)parameters
                               onSuccess:(NDSuccessBlock)success
                               onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self familyTreeOperationRelationshipOfReadType:readType
                                                                            forPerson:forPersonId
                                                                     relationshipType:relationshipType
                                                                            toPersons:toPersonIds
                                                                       withParameters:parameters
                                                                            onSuccess:success
                                                                            onFailure:failure
                                                                     withTargetThread:nil]];
}

#pragma mark Relationship Update (Also does delete)

- (NSURLRequest*)familytreeRequestRelationshipUpdateFromPerson:(NSString*)fromPersonid
                                              relationshipType:(NSString*)relationshipType
                                                     toPersons:(NSArray*)toPersonIds
                                          relationshipVersions:(NSArray*)versions
                                                    assertions:(NSArray*)assertions
{
    NSAssert(fromPersonid!=nil, @"From person ID is nil!");
    NSAssert([toPersonIds count]>0, @"To few persons to update relationships to!");
    NSAssert([toPersonIds count]==[versions count], @"Incorrect number of versions; does not match number of toPersonIds");
    NSAssert([toPersonIds count]==[assertions count], @"Incorrect number of assertion collections; does not match number of toPersonIds");
    NSAssert([NDFamilyTreeAllRelationshipTypes() containsObject:relationshipType], @"Incorrect relationship type!");
    for (NSDictionary* assertionCollection in assertions) for (id key in [assertionCollection allKeys]) NSAssert([NDFamilyTreeAllAssertionTypes() containsObject:key], @"Invalid assertion type %@ in assertion collection for %@", key, [toPersonIds objectAtIndex:[assertions indexOfObject:assertionCollection]]);
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"/familytree/v2/person/%@/%@/%@", fromPersonid, relationshipType, [toPersonIds componentsJoinedByString:@","]]
                        relativeToURL:self.serverUrl
                      queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSMutableURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"POST"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // body crap
    NSMutableDictionary* body = [NSMutableDictionary dictionaryWithCapacity:1]; {
        NSMutableArray* persons = [NSMutableArray arrayWithCapacity:1]; {
            NSMutableDictionary* person = [NSMutableDictionary dictionaryWithCapacity:2]; {
                [person setObject:fromPersonid forKey:@"id"];
                NSMutableDictionary* relationships = [NSMutableDictionary dictionaryWithCapacity:1]; {
                    NSMutableArray* relationshipsContainer = [NSMutableArray arrayWithCapacity:[toPersonIds count]]; {
                        for (NSUInteger i=0;
                             i < [toPersonIds count];
                             ++i) {
                            NSMutableDictionary* relationship = [NSMutableDictionary dictionaryWithCapacity:3]; {
                                [relationship setObject:[toPersonIds objectAtIndex:i] forKey:@"id"];
                                [relationship setObject:[versions objectAtIndex:i] forKey:@"version"];
                                [relationship setObject:[assertions objectAtIndex:i] forKey:@"assertions"];
                            } [relationshipsContainer addObject:relationship];
                        }
                    } [relationships setObject:relationshipsContainer forKey:relationshipType];
                } [person setObject:relationships forKey:@"relationships"];
            } [persons addObject:person];
        } [body setObject:persons forKey:@"persons"];
    }
    
    NSError* jsonWriteError=nil;
    [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:body options:[self jsonWritingOptions] error:&jsonWriteError]];
    
    return req;
}

- (FSURLOperation*)familyTreeOperationRelationshipUpdateFromPerson:(NSString*)fromPersonId relationshipType:(NSString*)relationshipType toPersons:(NSArray*)toPersonIds relationshipVersions:(NSArray*)versions assertions:(NSArray*)assertions onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread
{
    NSURLRequest* req = [self familytreeRequestRelationshipUpdateFromPerson:fromPersonId relationshipType:relationshipType toPersons:toPersonIds relationshipVersions:versions assertions:assertions];
    
    
    FSURLOperation* oper =
    [FSURLOperation URLOperationWithRequest:req completionBlock:^(NSHTTPURLResponse *resp, NSData *payload, NSError *error) {
        if (error||[resp statusCode]!=200) {
            if (failure) failure(resp, payload, error);
        } else if (success) {
            NSError* err=nil;
            id _payload = [NSJSONSerialization JSONObjectWithData:payload options:kNilOptions error:&err];
            if (!err) success(resp, _payload, payload);
            else if (failure) failure(resp, payload, err);
        }
    } onThread:thread];
    
    return oper;
}

- (FSURLOperation*)familyTreeOperationRelationshipUpdateFromPerson:(NSString*)fromPersonId relationshipType:(NSString*)relationshipType toPersons:(NSArray*)toPersonIds relationshipVersions:(NSArray*)versions assertions:(NSArray*)assertions onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure
{
    return [self familyTreeOperationRelationshipUpdateFromPerson:fromPersonId relationshipType:relationshipType toPersons:toPersonIds relationshipVersions:versions assertions:assertions onSuccess:success onFailure:failure withTargetThread:nil];
}

- (void)familyTreeRelationshipUpdateFromPerson:(NSString*)fromPersonId relationshipType:(NSString*)relationshipType toPersons:(NSArray*)toPersonIds relationshipVersions:(NSArray*)versions assertions:(NSArray*)assertions onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure
{
    [self.operationQueue addOperation:[self familyTreeOperationRelationshipUpdateFromPerson:fromPersonId relationshipType:relationshipType toPersons:toPersonIds relationshipVersions:versions assertions:assertions onSuccess:success onFailure:failure withTargetThread:nil]];
}

#pragma mark FamilyTree+Private

- (NSArray*)ft_noneSummaryAll
{
    static NSArray* noneSummaryAllKeys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        noneSummaryAllKeys = [[NSArray alloc] initWithObjects:NDFamilyTreeReadRequestValue.none, NDFamilyTreeReadRequestValue.summary, NDFamilyTreeReadRequestValue.all, nil];
    });
    return noneSummaryAllKeys;
}

- (NSArray*)ft_noneAll
{
    static NSArray* noneAllKeys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        noneAllKeys = [[NSArray alloc] initWithObjects:NDFamilyTreeReadRequestValue.none, NDFamilyTreeReadRequestValue.all, nil];
    });
    return noneAllKeys;
}

- (NSDictionary*)readPersonsValidKeys
{
    static NSDictionary* validKeys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        validKeys = [[NSDictionary alloc] initWithObjectsAndKeys:
                     [self ft_noneSummaryAll], NDFamilyTreeReadRequestParameter.names,
                     [self ft_noneSummaryAll], NDFamilyTreeReadRequestParameter.genders,
                     [NSArray arrayWithObjects:NDFamilyTreeReadRequestValue.none, NDFamilyTreeReadRequestValue.summary, NDFamilyTreeReadRequestValue.standard, NDFamilyTreeReadRequestValue.all, nil], NDFamilyTreeReadRequestParameter.events,
                     [self ft_noneAll], NDFamilyTreeReadRequestParameter.characteristics,
                     [self ft_noneAll], NDFamilyTreeReadRequestParameter.exists,
                     [self ft_noneAll], NDFamilyTreeReadRequestParameter.values,
                     [self ft_noneAll], NDFamilyTreeReadRequestParameter.ordinances,
                     [self ft_noneAll], NDFamilyTreeReadRequestParameter.assertions,
                     [self ft_noneSummaryAll], NDFamilyTreeReadRequestParameter.families,
                     [self ft_noneAll], NDFamilyTreeReadRequestParameter.children,
                     [self ft_noneSummaryAll], NDFamilyTreeReadRequestParameter.parents,
                     [NSArray arrayWithObjects:NDFamilyTreeReadRequestValue.none, NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestValue.mine, nil], NDFamilyTreeReadRequestParameter.personas,
                     [self ft_noneAll], NDFamilyTreeReadRequestParameter.changes,
                     [self ft_noneSummaryAll], NDFamilyTreeReadRequestParameter.properties,
                     [self ft_noneAll], NDFamilyTreeReadRequestParameter.identifiers,
                     [NSArray arrayWithObjects:NDFamilyTreeReadRequestValue.all, NDFamilyTreeReadRequestValue.affirming, NDFamilyTreeReadRequestValue.disputing, nil], NDFamilyTreeReadRequestParameter.dispositions,
                     [self ft_noneAll], NDFamilyTreeReadRequestParameter.contributors,
                     [self ft_noneAll], NDFamilyTreeReadRequestParameter.notes,
                     [self ft_noneAll], NDFamilyTreeReadRequestParameter.citations,
                     [self familyTreeLocales], NDFamilyTreeReadRequestParameter.locale,
                     nil];
    });
    return validKeys;
}

@end

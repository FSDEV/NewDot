//
//  NDService+FamilyTree.h
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService.h"

@class FSURLOperation;

/**
 * Set of values to help you construct parameter dictionaries.
 */
extern const struct NDFamilyTreeReadPersonsRequestParameters {
    __unsafe_unretained NSString* names;               // [none, *summary, all]
    __unsafe_unretained NSString* genders;             // [none, *summary, all]
    __unsafe_unretained NSString* events;              // [none, *summary, standard, all]
    __unsafe_unretained NSString* characteristics;     // [*none, all]
    __unsafe_unretained NSString* exists;              // [*none, all]
    __unsafe_unretained NSString* values;              // [*summary, all]
    __unsafe_unretained NSString* ordinances;          // [*none, all]
    __unsafe_unretained NSString* assertions;          // [none, *all] (limited by other parameters)
    __unsafe_unretained NSString* families;            // [*none, summary, all]
    __unsafe_unretained NSString* children;            // [*none, all]
    __unsafe_unretained NSString* parents;             // [*none, summary, all]
    __unsafe_unretained NSString* personas;            // [all, *none, mine]
    __unsafe_unretained NSString* changes;             // [all, *none] DO NOT USE TO ROLL BACK CHANGES!
    __unsafe_unretained NSString* properties;          // [*none, summary, all]
    __unsafe_unretained NSString* identifiers;         // [*none, all]
    __unsafe_unretained NSString* dispositions;        // [all, *affirming, disputing]
    __unsafe_unretained NSString* contributors;        // [all, *none]
    __unsafe_unretained NSString* locale;              // see familyTreeLocales
} NDFamilyTreeReadPersonsRequestParameters; // NSString literals do not need memory management

/**
 * A set of keys to help you construct parameter dictionaries.
 */
extern const struct NDFamilyTreeReadPersonsRequestValues {
    __unsafe_unretained NSString* none;
    __unsafe_unretained NSString* summary;
    __unsafe_unretained NSString* all;
    __unsafe_unretained NSString* standard;
    __unsafe_unretained NSString* mine;
    __unsafe_unretained NSString* affirming;
    __unsafe_unretained NSString* disputing;
} NDFamilyTreeReadPersonsRequestValues; // NSString literals do not need memory management

@interface NDService (FamilyTree)

/**
 * Some relevant properties related to working with the FamilyTree module of FamilySearch.
 */
- (NSURLRequest*)familyTreeRequestProperties;
- (FSURLOperation*)familyTreeOperationPropertiesOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (FSURLOperation*)familyTreeOperationPropertiesOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)familyTreePropertiesOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

/**
 * Read the user profile of the currently logged-in user; for instance, this data includes the record ID of this user.
 */
- (NSURLRequest*)familyTreeRequestProfile;
- (FSURLOperation*)familyTreeOperationUserProfileOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (FSURLOperation*)familyTreeOperationUserProfileOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)familyTreeUserProfileOnSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

/**
 * Read up to `person.max.ids` records from the API. Throws an `NSInternalInconsistencyException` in the event that a parameter is using a key that the API does not support.
 *
 * @param people If `nil`, then it returns the current user's person record.
 * @param parameters See `NDFamilyTreeReadPersonsRequestParameters` and `NDFamilyTreeReadPersonsRequestValues`; may be nil.
 */
- (NSURLRequest*)familyTreeRequestPersons:(NSArray*)people withParameters:(NSDictionary*)parameters;
- (FSURLOperation*)familyTreeOperationReadPersons:(NSArray*)people withParameters:(NSDictionary*)parameters onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (FSURLOperation*)familyTreeOperationReadPersons:(NSArray*)people withParameters:(NSDictionary*)parameters onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)familyTreeReadPersons:(NSArray*)people withParameters:(NSDictionary*)parameters onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

- (NSURLRequest*)familyTreeRequestDiscussionsForPerson:(NSString*)personId;
- (FSURLOperation*)familyTreeOperationDiscussionsForPerson:(NSString*)personId onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (FSURLOperation*)familyTreeOperationDiscussionsForPerson:(NSString*)personId onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)familyTreeDiscussionsForPerson:(NSString*)personId onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

/**
 * Locales! Note that this may migrate to a less specialized category in the future.
 */
- (NSArray*)familyTreeLocales;

@end

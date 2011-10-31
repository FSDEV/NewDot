//
//  NDService+FamilyTree.h
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService.h"

/**
 * Set of values to help you construct parameter dictionaries.
 */
extern const struct NDFamilyTreeReadPersonsRequestParameters {
    NSString* names;               // [none, *summary, all]
    NSString* genders;             // [none, *summary, all]
    NSString* events;              // [none, *summary, standard, all]
    NSString* characteristics;     // [*none, all]
    NSString* exists;              // [*none, all]
    NSString* values;              // [*summary, all]
    NSString* ordinances;          // [*none, all]
    NSString* assertions;          // [none, *all] (limited by other parameters)
    NSString* families;            // [*none, summary, all]
    NSString* children;            // [*none, all]
    NSString* parents;             // [*none, summary, all]
    NSString* personas;            // [all, *none, mine]
    NSString* changes;             // [all, *none] DO NOT USE TO ROLL BACK CHANGES!
    NSString* properties;          // [*none, summary, all]
    NSString* identifiers;         // [*none, all]
    NSString* dispositions;        // [all, *affirming, disputing]
    NSString* contributors;        // [all, *none]
    NSString* locale;              // see familyTreeLocales
} NDFamilyTreeReadPersonsRequestParameters;

/**
 * A set of keys to help you construct parameter dictionaries.
 */
extern const struct NDFamilyTreeReadPersonsRequestKeys {
    NSString* none;
    NSString* summary;
    NSString* all;
    NSString* standard;
    NSString* mine;
    NSString* affirming;
    NSString* disputing;
} NDFamilyTreeReadPersonsRequestKeys;

@interface NDService (FamilyTree)

/**
 * Some relevant properties related to working with the FamilyTree module of FamilySearch.
 */
- (void)familyTreePropertiesOnSuccess:(NDGenericSuccessBlock)success
                            onFailure:(NDGenericFailureBlock)failure;

/**
 * Read the user profile of the currently logged-in user; for instance, this data includes the record ID of this user.
 */
- (void)familyTreeUserProfileOnSuccess:(NDGenericSuccessBlock)success
                             onFailure:(NDGenericFailureBlock)failure;

/**
 * Read up to `person.max.ids` records from the API. Throws an `NSInternalInconsistencyException` in the event that a parameter is using a key that the API does not support.
 *
 * @param people If `nil`, then it returns the current user's person record.
 * @param parameters See `NDFamilyTreeReadPersonsRequestParameters` and `NDFamilyTreeReadPersonsRequestKeys`; may be nil.
 */
- (void)familyTreeReadPersons:(NSArray*)people
               withParameters:(NSDictionary*)parameters
                    onSuccess:(NDGenericSuccessBlock)success
                    onFailure:(NDGenericFailureBlock)failure;

- (void)familyTreeDiscussionsForPerson:(NSString*)personId
                             onSuccess:(NDGenericSuccessBlock)success
                             onFailure:(NDParsedFailureBlock)failure;

/**
 * Locales! Note that this may migrate to a less specialized category in the future.
 */
- (NSArray*)familyTreeLocales;

@end

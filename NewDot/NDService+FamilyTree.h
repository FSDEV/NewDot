//
//  NDService+FamilyTree.h
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService.h"

@class FSURLOperation;

#define usfurt __unsafe_unretained

/**
 * Set of values to help you construct parameter dictionaries.
 */
extern const struct NDFamilyTreeReadRequestParameter {
    usfurt NSString* names;               // [none, *summary, all]
    usfurt NSString* genders;             // [none, *summary, all]
    usfurt NSString* events;              // [none, *summary, standard, all]
    usfurt NSString* characteristics;     // [*none, all]
    usfurt NSString* exists;              // [*none, all]
    usfurt NSString* values;              // [*summary, all]
    usfurt NSString* ordinances;          // [*none, all]
    usfurt NSString* assertions;          // [none, *all] (limited by other parameters)
    usfurt NSString* families;            // [*none, summary, all]
    usfurt NSString* children;            // [*none, all]
    usfurt NSString* parents;             // [*none, summary, all]
    usfurt NSString* personas;            // [all, *none, mine]
    usfurt NSString* changes;             // [all, *none] DO NOT USE TO ROLL BACK CHANGES!
    usfurt NSString* properties;          // [*none, summary, all]
    usfurt NSString* identifiers;         // [*none, all]
    usfurt NSString* dispositions;        // [all, *affirming, disputing]
    usfurt NSString* contributors;        // [all, *none]
    usfurt NSString* notes;               // [all, *none] relationships only
    usfurt NSString* citations;           // [all, *none] relationships only
    usfurt NSString* locale;              // see familyTreeLocales
} NDFamilyTreeReadRequestParameter; // NSString literals do not need memory management

enum NDFamilyTreeReqType {
    person,
    relationship
};

NSArray* NDFamilyTreeAllReadRequestParameters(enum NDFamilyTreeReqType);

/**
 * A set of keys to help you construct parameter dictionaries.
 */
extern const struct NDFamilyTreeReadRequestValue {
    usfurt NSString* none;
    usfurt NSString* summary;
    usfurt NSString* all;
    usfurt NSString* standard;
    usfurt NSString* mine;
    usfurt NSString* affirming;
    usfurt NSString* disputing;
} NDFamilyTreeReadRequestValue; // NSString literals do not need memory management

extern const struct NDFamilyTreeReadType {
    usfurt NSString* person;
    usfurt NSString* persona;
} NDFamilyTreeReadType; // NSString literals do not need memory management

extern const struct NDFamilyTreeRelationshipType {
    usfurt NSString* parent;
    usfurt NSString* spouse;
    usfurt NSString* child;
} NDFamilyTreeRelationshipType; // NSString literals do not need memory management

NSArray* NDFamilyTreeAllRelationshipTypes(void);

extern const struct NDFamilyTreeAssertionType {
    usfurt NSString* characteristics;   // Contains all of a person’s characteristics. (In version 1 of the family tree data model, “characteristics” were called “facts.”
    usfurt NSString* citations;         // Contains all of the source citations about an assertion, person, or relationship.
    usfurt NSString* events;            // Contains a person’s or persona’s event assertions.
    usfurt NSString* exists;            // Contains a person's or persona's exists assertion.
    usfurt NSString* genders;           // Contains all of a person’s or persona’s gender assertions.
    usfurt NSString* names;             // Contains a person’s or persona’s name assertions.
    usfurt NSString* ordinances;        // Contains a person’s or persona’s LDS ordinance assertions.
    usfurt NSString* notes;             // Contains the notes associated with a person, persona, event, or assertion.
} NDFamilyTreeAssertionType;            // NSString literals do not need memory management

NSArray* NDFamilyTreeAllAssertionTypes(void);

#undef usfurt

NSDictionary* NDFamilyTreeAllRelationshipReadValues(void);

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
 * @param parameters See `NDFamilyTreeReadPersonsRequestParameter` and `NDFamilyTreeReadRequestParameter`; may be nil.
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
 * Read up to `relationship.max.ids` from the API. Also wins in the competition "longest method signature."
 *
 * @param readType The kind of relationship (`person` or `persona`) to read. You can use `NDFamilyTreeReadType` for some good pre-chewed constants for this.
 * @param forPerson The person to be reading relationships in relation to.
 * @param relationshipType Kind of relationship. You can use `NDFamilyTreeRelationshipType` for this.
 * @param personIds All the people to read in relation to. If this is nil or empty, then it becomes the list of everything.
 * @param parameters Additional parameters as necessary.
 *
 * @todo Figure out how to do pagination on this thing!
 */
- (NSURLRequest*)familyTreeRequestRelationshipOfReadType:(NSString*)readType forPerson:(NSString*)personId relationshipType:(NSString*)relationshipType toPersons:(NSArray*)personIds withParameters:(NSDictionary*)parameters;
- (FSURLOperation*)familyTreeOperationRelationshipOfReadType:(NSString*)readType forPerson:(NSString*)personId relationshipType:(NSString*)relationshipType toPersons:(NSArray*)personIds withParameters:(NSDictionary*)parameters onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (FSURLOperation*)familyTreeOperationRelationshipOfReadType:(NSString*)readType forPerson:(NSString*)personId relationshipType:(NSString*)relationshipType toPersons:(NSArray*)personIds withParameters:(NSDictionary*)parameters onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)familyTreeRelationshipOfReadType:(NSString*)readType forPerson:(NSString*)personId relationshipType:(NSString*)relationshipType toPersons:(NSArray*)personIds withParameters:(NSDictionary*)parameters onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

/**
 * Update a relationship (or even delete).
 *
 * @param fromPersonId Self explanatory.
 * @param relationshipType Only one type, please. See NDFamilyTreeRelationshipType.
 * @param toPersonIds You can update as many relationships as you want.
 * @param versions The relationship versions.
 * @param assertions An array of dictionaries of assertion types (see NDFamilyTreeAssertionType) which are arrays. (So a dictionary where key is a string from NDFamilyTreeAssertionType and value is an array of dictionaries representing assertions).
 */
- (NSURLRequest*)familytreeRequestRelationshipUpdateFromPerson:(NSString*)fromPersonid relationshipType:(NSString*)relationshipType toPersons:(NSArray*)toPersonIds relationshipVersions:(NSArray*)versions assertions:(NSArray*)assertions;
- (FSURLOperation*)familyTreeOperationRelationshipUpdateFromPerson:(NSString*)fromPersonId relationshipType:(NSString*)relationshipType toPersons:(NSArray*)toPersonIds relationshipVersions:(NSArray*)versions assertions:(NSArray*)assertions onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (FSURLOperation*)familyTreeOperationRelationshipUpdateFromPerson:(NSString*)fromPersonId relationshipType:(NSString*)relationshipType toPersons:(NSArray*)toPersonIds relationshipVersions:(NSArray*)versions assertions:(NSArray*)assertions onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)familyTreeRelationshipUpdateFromPerson:(NSString*)fromPersonId relationshipType:(NSString*)relationshipType toPersons:(NSArray*)toPersonIds relationshipVersions:(NSArray*)versions assertions:(NSArray*)assertions onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

/**
 * Delete a relationship.
 */
- (NSURLRequest*)familyTreeRequestRelationshipDeleteFromPerson:(NSString *)fromPersonId relationshipType:(NSString *)relationshipType toPerson:(NSString *)toPersonId relationshipVersion:(NSString*)version assertionType:(NSString *)assertionType assertion:(NSDictionary*)assertion;
- (FSURLOperation*)familyTreeOperationRelationshipDeleteFromPerson:(NSString*)fromPersonId relationshipType:(NSString*)relationshipType toPerson:(NSString*)toPersonId relationshipVersion:(NSString*)version assertionType:(NSString*)assertionType assertion:(NSDictionary*)assertion onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure withTargetThread:(NSThread*)thread;
- (FSURLOperation*)familyTreeOperationRelationshipDeleteFromPerson:(NSString*)fromPersonId relationshipType:(NSString*)relationshipType toPerson:(NSString*)toPersonId relationshipVersion:(NSString*)version assertionType:(NSString *)assertionType assertion:(NSDictionary*)assertion onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;
- (void)familyTreeRelationshipDeleteFromPerson:(NSString*)fromPersonId relationshipType:(NSString*)relationshipType toPerson:(NSString*)toPersonId relationshipVersion:(NSString*)version assertionType:(NSString*)assertionType assertion:(NSDictionary*)assertion onSuccess:(NDSuccessBlock)success onFailure:(NDFailureBlock)failure;

/**
 * Locales! Note that this may migrate to a less specialized category in the future.
 */
- (NSArray*)familyTreeLocales;

@end

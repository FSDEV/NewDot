//
//  TestDiscussions.m
//  NewDot
//
//  Created by Christopher Miller on 10/6/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "TestDiscussions.h"

#import "NewDotDebuggingAppDelegate.h"

#import "NDService.h"
#import "NDService+Identity.h"
#import "NDService+FamilyTree.h"
#import "NDService+Discussions.h"

@interface TestDiscussions ()

@property (readwrite, assign) NSUInteger tagCount;
@property (readwrite, assign) NSUInteger tagAccumulator;
@property (readwrite, retain) NSMutableArray * discussionIds;

- (void)login;
- (void)discussionsList;
- (void)discussionsWithSystemTags:(NSArray *)systemTags;
- (void)accumulateDiscussion;
- (void)accumulateDiscussionWithIds:(NSArray *)dIds;
- (void)logout;

@end

@implementation TestDiscussions

@synthesize service;

@synthesize tagCount;
@synthesize tagAccumulator;
@synthesize discussionIds;

- (void)login
{
    [self.service identityCreateSessionForUser:[self.testCredentials valueForKeyPath:@"success.username"]
                                  withPassword:[self.testCredentials valueForKeyPath:@"success.password"]
                                        apiKey:[self.properties valueForKeyPath:@"reference.api-key"]
                                     onSuccess:^(id response) {
                                         LOG_STUFF(@"[[ WIN ]] Session create\n");
                                         [self discussionsList];
                                     }
                                     onFailure:^(enum NDIdentitySessionCreateResult result, NSError * error) {
                                         [NSException raise:@"Failed to log in" format:@"Cannot test the rest of the system without a valid session; failed with error %d and description %@", result, error];
                                     }];
}

- (void)discussionsList
{
    [self.service discussionsSystemTagsOnSuccess:^(id response) {
        LOG_STUFF(@"[[ WIN ]] Got stuff from discussions API\n");
        NSArray * rawTags = [response valueForKey:@"tags"];
        NSMutableArray * fixedTags = [NSMutableArray arrayWithCapacity:[rawTags count]];
        
        for (NSString * tag in rawTags) {
            [fixedTags addObject:[tag substringFromIndex:[tag length]-8]];
        }
        
        [self discussionsWithSystemTags:fixedTags];
    }
                                       onFailure:^(NSError * error) {
                                           [NSException raise:@"Failed to get crap from the API" format:@"Failed with error %@", error];
                                       }];
}

- (void)discussionsWithSystemTags:(NSArray *)systemTags
{
    self.tagCount = [systemTags count]-1;
    self.tagAccumulator = 0;
    self.discussionIds = [NSMutableArray array];
    for (id tag in systemTags)
        [self.service familyTreeDiscussionsForPerson:tag
                                           onSuccess:^(id response) {
                                               NSString * string = [NSString stringWithFormat:@"[[ WIN ]] Got discussions list for %@\n", tag];
                                               LOG_STUFF(string);
                                               [self accumulateDiscussionWithIds:[response valueForKeyPath:@"persons.discussions.uri"]];
                                           }
                                           onFailure:^(NSInteger code, NSError * error) {
                                               if (code != 403)
                                                   [NSException raise:@"Failed to get crap from the API" format:@"Failed with error %@", error];
                                               else {
                                                   LOG_STUFF(@"[[ WIN ]] Just got a 403 on some dumb living record.\n");
                                                   [self accumulateDiscussion];
                                               }
                                           }];
}

- (void)accumulateDiscussion
{
    if (++self.tagAccumulator==self.tagCount)
        [self logout];
}

- (void)accumulateDiscussionWithIds:(NSArray *)dIds
{
    for (id discussionId in dIds) {
        if (discussionId != [NSNull null])
            [self.discussionIds addObject:discussionId];
    }
    [self accumulateDiscussion];
}

- (void)logout
{
    [self.service identityDestroySessionOnSuccess:^(id response) {
        LOG_STUFF(@"[[ WIN ]] Destroyed session\n");
        LOG_STUFF(@"---- DISCUSSIONS TESTS SUCCESSFUL ----\n");
    }
                                        onFailure:^(NSError * error) {
                                            [NSException raise:@"Failed to destroy session" format:@"Cannot destroy the session; this isn't fatal, but really not expected and probably evidence of a larger problem. Error is %@", error];
                                        }];
}

#pragma mark Harness

- (void)test
{
    LOG_STUFF(@"\n---- TESTING DISCUSSIONS ----\n");
    [self login];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    if (self) {
        self.service = [[NDService alloc] initWithBaseURL:[NSURL URLWithString:[self.properties valueForKeyPath:@"reference.server"]]
                                                userAgent:nil];
    }
    
    return self;
}

- (void)dealloc
{
    self.service = nil;
    self.discussionIds = nil;
    
    [super dealloc];
}

@end

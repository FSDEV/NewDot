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
- (void)goFetchumDiscussions;
- (void)logout;

@end

@implementation TestDiscussions

@synthesize service;

@synthesize tagCount;
@synthesize tagAccumulator;
@synthesize discussionIds;

- (void)login
{
    [self.service identityCreateSessionForUser:self.username
                                  withPassword:self.password
                                        apiKey:self.apiKey
                                     onSuccess:^(id response) {
                                         LOG_DISCUSSIONS(0,@"Session Created");
                                         [self discussionsList];
                                     }
                                     onFailure:^(enum NDIdentitySessionCreateResult result, NSError * error) {
                                         LOG_DISCUSSIONS(5,@"Failed to log in!");
                                     }];
}

- (void)discussionsList
{
    [self.service discussionsSystemTagsOnSuccess:^(id response) {
        LOG_DISCUSSIONS(0,@"Retrieved tags from the discussions API");
        NSArray * rawTags = [response valueForKey:@"tags"];
        NSMutableArray * fixedTags = [NSMutableArray arrayWithCapacity:[rawTags count]];
        
        for (NSString * tag in rawTags) {
            [fixedTags addObject:[tag substringFromIndex:[tag length]-8]];
        }
        
        LOG_DISCUSSIONS(0,@"Got these tags: %@", fixedTags);
        
        [self discussionsWithSystemTags:fixedTags];
    }
                                       onFailure:^(NSError * error) {
                                           LOG_DISCUSSIONS(5,@"Failed to get system tags from the API with error %@", error);
                                           [self logout];
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
                                               LOG_DISCUSSIONS(0,@"Got the discussions list for %@",tag);
                                               [self accumulateDiscussionWithIds:[[response valueForKeyPath:@"persons.discussions.uri"] lastObject]];
                                           }
                                           onFailure:^(NSInteger code, NSError * error) {
                                               if (code != 403)
                                                   LOG_DISCUSSIONS(4,@"Failed to get crap from the API with error %@", error);
                                               else {
                                                   LOG_DISCUSSIONS(1,@"403 on some dumb living record. Meh.");
                                                   [self accumulateDiscussion];
                                               }
                                           }];
}

- (void)accumulateDiscussion
{
    if (++self.tagAccumulator==self.tagCount)
        [self goFetchumDiscussions];
}

- (void)accumulateDiscussionWithIds:(NSArray *)dIds
{
    for (id discussionId in dIds) {
        if (discussionId != [NSNull null])
            [self.discussionIds addObject:[discussionId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    [self accumulateDiscussion];
}


- (void)goFetchumDiscussions
{
    if ([self.discussionIds count]==0) {
        LOG_DISCUSSIONS(1,@"No discussions to request");
        [self logout];
    }
    [self.service discussionsWithIds:self.discussionIds
                              method:GET
                           onSuccess:^(id response) {
                               LOG_DISCUSSIONS(0,@"Retrieved discussions data from the API");
                               LOG_DISCUSSIONS(0,@"Discussion object is %@",response);
                               [self logout];
                           }
                           onFailure:^(NSError * error) {
                               LOG_DISCUSSIONS(5,@"Failed to get discussion from the API with error %@", error);
                               [self logout];
                           }];
}

- (void)logout
{
    [self.service identityDestroySessionOnSuccess:^(id response) {
        LOG_DISCUSSIONS(0,@"Destroyed session");
    }
                                        onFailure:^(NSError * error) {
                                            LOG_DISCUSSIONS(5,@"Failed to destroy session with error %@",error);
                                        }];
}

#pragma mark Harness

- (void)testWithUsername:(NSString *)u password:(NSString *)p serverLocation:(NSString *)s apiKey:(NSString *)a
{
    [super testWithUsername:u password:p serverLocation:s apiKey:a];
    
    self.service = [[[NDService alloc] initWithBaseURL:[NSURL URLWithString:self.serverLocation] userAgent:nil] autorelease];
    LOG_DISCUSSIONS(0, @"Testing Discussions Module");
    [self login];
}

#pragma mark NSObject

- (id)init
{
    self = [super init];
    if (self) {

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

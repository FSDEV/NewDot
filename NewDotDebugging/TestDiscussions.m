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
#import "NDService+Discussions.h"

@interface TestDiscussions ()

- (void)login;
- (void)discussionsList;
- (void)discussionsWithSystemTags:(NSArray *)systemTags;
- (void)logout;

@end

@implementation TestDiscussions

@synthesize service;

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
        [self discussionsWithSystemTags:[response valueForKey:@"tags"]];
    }
                                       onFailure:^(NSError * error) {
                                           [NSException raise:@"Failed to get crap from the API" format:@"Failed with error %@", error];
                                       }];
}

- (void)discussionsWithSystemTags:(NSArray *)systemTags
{
    [self.service discussionsWithSystemTags:systemTags
                                  onSuccess:^(id response) {
                                      LOG_STUFF(@"[[ WIN ]] Got stuff from the discussions API\n");
                                      [self logout];
                                  }
                                  onFailure:^(NSError * error) {
                                      [NSException raise:@"Failed to get crap from the API" format:@"Failed with error %@", error];
                                  }];
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
    
    [super dealloc];
}

@end

//
//  TestFamilyTree.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "TestFamilyTree.h"

#import "NDService.h"
#import "NDService+Identity.h"
#import "NDService+FamilyTree.h"

@interface TestFamilyTree ()

- (void)login;

@end

@implementation TestFamilyTree

@synthesize service;

- (void)login
{
    [self.service identityCreateSessionForUser:[self.testCredentials valueForKeyPath:@"success.username"]
                                  withPassword:[self.testCredentials valueForKeyPath:@"success.password"]
                                        apiKey:[self.properties valueForKeyPath:@"reference.api-key"]
                                     onSuccess:^(id response) {
                                         printf("[[ WIN ]] Session create\n");
                                         // Do something else
                                     }
                                     onFailure:^(enum NDIdentitySessionCreateResult result, NSError * error) {
                                         [NSException raise:@"Failed to log in" format:@"Cannot test the rest of the system without a valid session; failed with error %d and description %@", result, error];
                                     }];
}

#pragma mark Harness

- (void)test
{
    printf("\n\nTESTING FAMILYTREE\n\n");
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

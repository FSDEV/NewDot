//
//  LoginTests.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "LoginTests.h"

#import "NDService.h"
#import "NDService+Identity.h"

@implementation LoginTests

@synthesize winTest;
@synthesize failTest;

- (void)test
{
    NSString * error;
    id props = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DeveloperKeys"
                                                                                                                                ofType:@"PLIST"]]
                                                mutabilityOption:NSPropertyListImmutable
                                                          format:NULL
                                                errorDescription:&error];
    NSURL * baseURL = [NSURL URLWithString:[props valueForKeyPath:@"reference.server"]];
    self.winTest = [[NDService alloc] initWithBaseURL:baseURL apiKey:[props valueForKeyPath:@"reference.api-key"] userAgent:@"NewDot/0.1"];
    self.failTest = [[NDService alloc] initWithBaseURL:baseURL apiKey:[props valueForKeyPath:@"reference.api-key"] userAgent:@"NewDot/0.1"];
    id testCredentials = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TestCredentials" ofType:@"PLIST"]] mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:&error];
    
    [self.failTest createSessionForUser:[testCredentials valueForKeyPath:@"fail.username"]
                           withPassword:[testCredentials valueForKeyPath:@"fail.password"]
                                success:^(id response) {
                                    NSAssert(YES==NO, @"Fail succeeded with %@", response);
                                }
                                failure:^(enum NDIdentitySessionCreateResult result, NSError * fail) {
                                    NSLog(@"Failed with code: %d", result);
                                }];
    [self.winTest createSessionForUser:[testCredentials valueForKeyPath:@"success.username"]
                          withPassword:[testCredentials valueForKeyPath:@"success.password"]
                               success:^(id response) {
                                   NSLog(@"Succeeded with session id: %@", self.winTest.sessionId);
                                   [self.winTest readSessionWithSuccess:^(id respons) {
                                                                    NSLog(@"Successful session read");
                                       [self.winTest destroySessionWithSuccess:^(id respon) {
                                           NSLog(@"Successfully destroyed the session. Identity module clear!");
                                       }
                                                                       failure:^(NSError * erro) {
                                                                           NSAssert(YES==NO, @"Failed to destroy session with error %@", erro);
                                                                       }];
                                                                }
                                                                failure:^(NSError * erro) {
                                                                    NSAssert(YES==NO, @"Failed reading session with error %@", erro);
                                                                }];
                               }
                               failure:^(enum NDIdentitySessionCreateResult result, NSError * fail) {
                                   NSAssert(YES==NO, @"Success failed with %@", fail);
                               }];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    self.winTest = nil;
    self.failTest = nil;
}

@end

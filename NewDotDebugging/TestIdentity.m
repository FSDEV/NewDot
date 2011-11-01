//
//  LoginTests.m
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "TestIdentity.h"

#import "NewDotDebuggingAppDelegate.h"

#import "NDService.h"
#import "NDService+Identity.h"

@interface TestIdentity ()

- (void)testLoginFailure;
- (void)testLogin;
- (void)testSessionRead;
- (void)testUserRead;
- (void)testPermissionsRead;
- (void)destroySession;

@end

@implementation TestIdentity

@synthesize winTest;
@synthesize failTest;

- (void)testLoginFailure
{
    [self.failTest identityCreateSessionForUser:@"Fail"
                                   withPassword:@"Fail"
                                         apiKey:self.apiKey
                                      onSuccess:^(NSHTTPURLResponse* resp, id response, NSData* payload) {
                                          LOG_IDENTITY(5,@"Created session with bogus login credentials. This really shouldn't happen. Results are %@", response);
                                          LOG_IDENTITY(5, @"%@", response);
                                      }
                                      onFailure:^(NSHTTPURLResponse* xhr, NSData* payload, NSError* error) {
                                          LOG_IDENTITY(0,@"Session creation failed when it was supposed to with result: %d", [xhr statusCode]);
                                          LOG_IDENTITY(0, @"%@", [payload fs_stringValue]);
                                      }];
}

- (void)testLogin
{
    [self.winTest identityCreateSessionForUser:self.username
                                  withPassword:self.password
                                        apiKey:self.apiKey
                                     onSuccess:^(NSHTTPURLResponse* resp, id response, NSData* payload) {
                                         LOG_IDENTITY(0,@"Session %@ created", self.winTest.sessionId);
                                         [self testSessionRead];
                                     }
                                     onFailure:^(NSHTTPURLResponse* xhr, NSData* payload, NSError* error) {
                                         LOG_IDENTITY(5,@"Session creation failed when it wasn't supposed to with result: %d", [xhr statusCode]);
                                         LOG_IDENTITY(5, @"%@", [payload fs_stringValue]);
                                     }];
}

- (void)testSessionRead
{
    [self.winTest identitySessionOnSuccess:^(NSHTTPURLResponse* resp, id response, NSData* payload) {
        LOG_IDENTITY(0,@"Session read");
        LOG_IDENTITY(0, @"%@", response);
        [self testUserRead];
    }
                                 onFailure:^(NSHTTPURLResponse* xhr, NSData* payload, NSError* error) {
                                     LOG_IDENTITY(5,@"Failed to read session with error %d", [xhr statusCode]);
                                     LOG_IDENTITY(5, @"%@", [payload fs_stringValue]);
                                     [self destroySession];
                                 }];
}

- (void)testUserRead
{
    [self.winTest identityUserProfileOnSuccess:^(NSHTTPURLResponse* resp, id response, NSData* payload) {
        LOG_IDENTITY(0,@"User profile read");
        LOG_IDENTITY(0, @"%@", response);
        [self testPermissionsRead];
    }
                                     onFailure:^(NSHTTPURLResponse* xhr, NSData* payload, NSError* error) {
                                         LOG_IDENTITY(5,@"Failed to read user profile with error %d", [xhr statusCode]);
                                         LOG_IDENTITY(5, @"%@", [payload fs_stringValue]);
                                         [self destroySession];
                                     }];
}

- (void)testPermissionsRead
{
    [self.winTest identityUserPermissionsOnSuccess:^(NSHTTPURLResponse* resp, id response, NSData* payload) {
        LOG_IDENTITY(0,@"Read the user's permissions");
        LOG_IDENTITY(0, @"%@", response);
        [self destroySession];
    }
                                         onFailure:^(NSHTTPURLResponse* xhr, NSData* payload, NSError* error) {
                                             LOG_IDENTITY(5,@"Failed to read the user's permissions (maybe he or she doesn't have permission?) with error %d", [xhr statusCode]);
                                             LOG_IDENTITY(5, @"%@", [payload fs_stringValue]);
                                             [self destroySession];
                                         }];
}

- (void)destroySession
{
    [self.winTest identityDestroySessionOnSuccess:^(NSHTTPURLResponse* resp, id response, NSData* payload) {
        LOG_IDENTITY(0,@"Destroyed session");
    }
                                        onFailure:^(NSHTTPURLResponse* xhr, NSData* payload, NSError* error) {
                                            LOG_IDENTITY(5,@"Failed to destroy session with error %d", [xhr statusCode]);
                                            LOG_IDENTITY(5, @"%@", [payload fs_stringValue]);
                                        }];
}

#pragma mark Harness

- (void)testWithUsername:(NSString*)u password:(NSString*)p serverLocation:(NSString*)s apiKey:(NSString*)a
{
    [super testWithUsername:u password:p serverLocation:s apiKey:a];
    
    NSURL* baseURL = [NSURL URLWithString:s];
    self.winTest = [[[NDService alloc] initWithBaseURL:baseURL userAgent:@"NewDot/0.2"] autorelease];
    self.failTest = [[[NDService alloc] initWithBaseURL:baseURL userAgent:@"NewDot/0.2"] autorelease];
    
    LOG_IDENTITY(0,@"Testing the Identity Module");
    [self testLoginFailure];
    [self testLogin];
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
    self.winTest = nil;
    self.failTest = nil;
    
    [super dealloc];
}

@end

//
//  NewDotDebuggingAppDelegate.m
//  NewDotDebugging
//
//  Created by Christopher Miller on 9/23/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NewDotDebuggingAppDelegate.h"

#import "TestIdentity.h"
#import "TestFamilyTree.h"
#import "TestDiscussions.h"
#import "TestReservation.h"

@implementation NewDotDebuggingAppDelegate

@synthesize window = _window;
@synthesize logStuff;

@synthesize identityTests;
@synthesize familyTreeTests;
@synthesize discussionsTests;
@synthesize reservationTests;

- (void)log:(NSString *)message
{
    self.logStuff.text = [self.logStuff.text stringByAppendingString:message];
    [self.logStuff scrollRangeToVisible:NSMakeRange([self.logStuff.text length], 0)];
}

#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    
    self.identityTests = [[[TestIdentity alloc] init] autorelease];
    self.familyTreeTests = [[[TestFamilyTree alloc] init] autorelease];
    self.discussionsTests = [[[TestDiscussions alloc] init] autorelease];
    self.reservationTests = [[[TestReservation alloc] init] autorelease];
    
    return YES;
}

- (IBAction)testIdentity:(id)sender
{
    [self.identityTests test];
}

- (IBAction)testFamilyTree:(id)sender
{
    [self.familyTreeTests test];
}

- (IBAction)testDiscussions:(id)sender
{
    [self.discussionsTests test];
}

- (IBAction)testReservation:(id)sender
{
    [self.reservationTests test];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    self.logStuff = nil;
    
    self.identityTests = nil;
    self.familyTreeTests = nil;
    self.identityTests = nil;
    
    [super dealloc];
}

@end

//
//  NewDotDebuggingAppDelegate.h
//  NewDotDebugging
//
//  Created by Christopher Miller on 9/23/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

//////
/// Because the debugger is awesome and OCUnit doesn't get me that.
//////


#import <UIKit/UIKit.h>

@class TestIdentity;
@class TestFamilyTree;
@class TestReservation;

@interface NewDotDebuggingAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITextView * logStuff;

@property (readwrite, retain) TestIdentity * identityTests;
@property (readwrite, retain) TestFamilyTree * familyTreeTests;
@property (readwrite, retain) TestReservation * reservationTests;

- (IBAction)testIdentity:(id)sender;
- (IBAction)testFamilyTree:(id)sender;
- (IBAction)testReservation:(id)sender;

- (void)log:(NSString *)message;

@end

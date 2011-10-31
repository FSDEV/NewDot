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
@class TestDiscussions;
@class TestReservation;

@interface NewDotDebuggingAppDelegate : NSObject <UIApplicationDelegate, UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UIWindow* window;

@property (readwrite, retain) TestIdentity* identityTests;
@property (readwrite, retain) TestFamilyTree* familyTreeTests;
@property (readwrite, retain) TestDiscussions* discussionsTests;
@property (readwrite, retain) TestReservation* reservationTests;

@property (readwrite, retain) IBOutlet UITextField* username;
@property (readwrite, retain) IBOutlet UITextField* password;
@property (readwrite, retain) IBOutlet UITextField* serverLocation;
@property (readwrite, retain) IBOutlet UITextField* apiKey;

- (IBAction)testIdentity:(id)sender;
- (IBAction)testFamilyTree:(id)sender;
- (IBAction)testDiscussions:(id)sender;
- (IBAction)testReservation:(id)sender;

@end

//
//  LoginTests.h
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NDService;

@interface TestIdentity : NSObject

@property (readwrite, retain) NSDictionary * properties;
@property (readwrite, retain) NSDictionary * testCredentials;
@property (readwrite, retain) NDService * winTest;
@property (readwrite, retain) NDService * failTest;

- (void)test;

@end

//
//  Harness.h
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

// Strap yourself in, we're testing some code!
@interface Harness : NSObject

@property (readwrite, retain) NSDictionary * properties;
@property (readwrite, retain) NSDictionary * testCredentials;

- (void)test;

@end

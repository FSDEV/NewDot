//
//  TestReservation.h
//  NewDot
//
//  Created by Christopher Miller on 9/26/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Harness.h"

@class NDService;

@interface TestReservation : Harness

@property (readwrite, retain) NDService * service;
@property (readwrite, assign) NSInteger personmaxids;

@end

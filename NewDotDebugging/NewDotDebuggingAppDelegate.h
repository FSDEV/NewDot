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

@class NDService;

@interface NewDotDebuggingAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (readwrite, retain) NDService * service;

@end

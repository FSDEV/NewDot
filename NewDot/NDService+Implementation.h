//
//  NDService+Implementation.h
//  NewDot
//
//  Created by Christopher Miller on 10/31/11.
//  Copyright (c) 2011 FSDEV. All rights reserved.
//

#import "NDService.h"

@interface NDService (Implementation)

- (NSMutableURLRequest*)standardRequestForURL:(NSURL*)url HTTPMethod:(NSString*)method;

@end
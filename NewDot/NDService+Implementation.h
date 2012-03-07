//
//  NDService+Implementation.h
//  NewDot
//
//  Created by Christopher Miller on 10/31/11.
//  Copyright (c) 2011 FSDEV. All rights reserved.
//

#import "NDService.h"

@interface NDService (Implementation)

- (NSMutableDictionary*)copyOfDefaultURLParametersWithSessionId;
- (NSMutableURLRequest*)standardRequestForURL:(NSURL*)url HTTPMethod:(NSString*)method;
- (NSJSONWritingOptions)jsonWritingOptions;

@end

NSArray * NDCoalesceUnknownToArray(id);

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

@property (readwrite, retain) NSString * username;
@property (readwrite, retain) NSString * password;
@property (readwrite, retain) NSString * serverLocation;
@property (readwrite, retain) NSString * apiKey;

- (void)testWithUsername:(NSString *)u
                password:(NSString *)p
          serverLocation:(NSString *)s
                  apiKey:(NSString *)a;

@end

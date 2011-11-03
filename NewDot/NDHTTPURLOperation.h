//
//  NDHTTPURLOperation.h
//  NewDot
//
//  Created by Christopher Miller on 10/31/11.
//  Copyright (c) 2011 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDHTTPURLOperation : NSOperation

@property (readonly, retain) NSURLRequest* request;
@property (readwrite, retain) NSHTTPURLResponse* response;
@property (readwrite, retain) NSMutableData* payload;
@property (readwrite, retain) NSError * error;

+ (NDHTTPURLOperation*)HTTPURLOperationWithRequest:(NSURLRequest*)req
                                   completionBlock:(void(^)(NSHTTPURLResponse* resp, NSData* payload, NSError* error))completion;

- (id)initWithRequest:(NSURLRequest*)_request;

@end

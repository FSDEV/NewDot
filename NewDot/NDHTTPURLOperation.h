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
@property (readonly, retain) NSURLResponse* response;

- (id)initWithRequest:(NSURLRequest*)_request;

@end

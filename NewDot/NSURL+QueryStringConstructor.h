//
//  NSURL+QueryStringConstructor.h
//  NewDot
//
//  Created by Christopher Miller on 10/31/11.
//  Copyright (c) 2011 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (QueryStringConstructor)

+ (id)URLWithString:(NSString*)URLString relativeToURL:(NSURL*)baseURL queryParameters:(NSDictionary*)params;
+ (id)URLWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL queryParameters:(NSDictionary *)params tailParams:(NSString*)tailParams;
- (id)initWithString:(NSString*)URLString relativeToURL:(NSURL*)baseURL queryParameters:(NSDictionary*)params;
- (id)initWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL queryParameters:(NSDictionary *)params tailParams:(NSString*)tailParams;

@end

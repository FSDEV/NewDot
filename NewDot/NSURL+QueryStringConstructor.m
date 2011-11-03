//
//  NSURL+QueryStringConstructor.m
//  NewDot
//
//  Created by Christopher Miller on 10/31/11.
//  Copyright (c) 2011 FSDEV. All rights reserved.
//

#import "NSURL+QueryStringConstructor.h"

@implementation NSURL (QueryStringConstructor)

+ (id)URLWithString:(NSString*)URLString relativeToURL:(NSURL*)baseURL queryParameters:(NSDictionary*)params
{
    return [[[NSURL alloc] initWithString:URLString relativeToURL:baseURL queryParameters:params] autorelease];
}

+ (id)URLWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL queryParameters:(NSDictionary *)params tailParams:(NSString*)tailParams
{
    return [[[NSURL alloc] initWithString:URLString relativeToURL:baseURL queryParameters:params tailParams:tailParams] autorelease];
}

- (id)initWithString:(NSString*)URLString relativeToURL:(NSURL*)baseURL queryParameters:(NSDictionary*)params
{
    return [self initWithString:URLString relativeToURL:baseURL queryParameters:params tailParams:nil];
}

- (id)initWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL queryParameters:(NSDictionary *)params tailParams:(NSString*)tailParams
{
    NSMutableString* _URLString = [[NSMutableString alloc] initWithString:URLString];
    if (params&&[params count]>0) {
        [_URLString appendString:@"?"];
        for (id key in [params allKeys])
            [_URLString appendFormat:@"%@=%@&", [[key description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[[params objectForKey:key] description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if (!tailParams) [_URLString deleteCharactersInRange:NSMakeRange([_URLString length]-1, 1)]; // kill the trailing '&'
    }
    if (tailParams) [_URLString appendString:tailParams];
    
    return [self initWithString:[_URLString autorelease] relativeToURL:baseURL];
}

@end

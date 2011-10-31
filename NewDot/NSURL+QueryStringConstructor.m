//
//  NSURL+QueryStringConstructor.m
//  NewDot
//
//  Created by Christopher Miller on 10/31/11.
//  Copyright (c) 2011 FSDEV. All rights reserved.
//

#import "NSURL+QueryStringConstructor.h"

@implementation NSURL (QueryStringConstructor)

+ (id)fs_URLWithString:(NSString*)URLString relativeToURL:(NSURL*)baseURL queryParameters:(NSDictionary*)params
{
    return [[[NSURL alloc] fs_initWithString:URLString relativeToURL:baseURL queryParameters:params] autorelease];
}

- (id)fs_initWithString:(NSString*)URLString relativeToURL:(NSURL*)baseURL queryParameters:(NSDictionary*)params
{
    NSMutableString* _URLString = [[NSMutableString alloc] initWithString:URLString];
    if (params&&[params count]>0) {
        [_URLString appendString:@"?"];
        for (id key in [params allKeys])
            [_URLString appendFormat:@"%@=%@&", [[key description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[[params objectForKey:key] description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [_URLString deleteCharactersInRange:NSMakeRange([_URLString length]-1, 1)]; // kill the trailing '&'
    }
    
    return [self initWithString:[_URLString autorelease] relativeToURL:baseURL];
}

@end

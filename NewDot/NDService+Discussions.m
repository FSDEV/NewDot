//
//  NDService+Discussions.m
//  NewDot
//
//  Created by Christopher Miller on 10/6/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NDService+Discussions.h"
#import "NDService+Implementation.h"
#import "NSDictionary+Merge.h"
#import "NSURL+QueryStringConstructor.h"

#import "JSONKit.h"

@implementation NDService (Discussions)

- (void)discussionsPropertiesOnSuccess:(NDSuccessBlock)success
                             onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL fs_URLWithString:@"/discussions/properties" relativeToURL:self.serverUrl queryParameters:[self defaultURLParameters]];
    NSURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
        NSHTTPURLResponse* _resp = (NSHTTPURLResponse*)resp;
        if (asplosion||[_resp statusCode]!=200) {
            if (failure) failure(_resp, payload, asplosion);
        } else if (success) {
            id _payload = [[JSONDecoder decoder] objectWithData:payload];
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            for (id kvpair in [_payload valueForKey:@"properties"])
                [dict setObject:[kvpair objectForKey:@"value"] forKey:[kvpair objectForKey:@"name"]];
            success(_resp, dict, payload);
        }
    }];
}

- (void)discussionsSystemTagsOnSuccess:(NDSuccessBlock)success
                             onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL fs_URLWithString:@"/discussions/systemtags" relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId]];
    NSURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
        NSHTTPURLResponse* _resp = (NSHTTPURLResponse*)resp;
        if (asplosion||[_resp statusCode]!=200) {
            if (failure) failure(_resp, payload, asplosion);
        } else if (success) success(_resp, [[JSONDecoder decoder] objectWithData:payload], payload);
    }];
}

- (void)discussionsWithSystemTags:(NSArray*)tags
                        onSuccess:(NDSuccessBlock)success
                        onFailure:(NDFailureBlock)failure
{
    NSMutableArray* paramTags = [NSMutableArray arrayWithCapacity:[tags count]];
    for (id tag in tags)
        [paramTags addObject:[NSString stringWithFormat:@"systemTag=%@",tag]];
    NSURL* url = [NSURL fs_URLWithString:@"/discussions/discussions" relativeToURL:self.serverUrl queryParameters:[self copyOfDefaultURLParametersWithSessionId] tailParams:[paramTags componentsJoinedByString:@"&"]];
    NSURLRequest* req = [self standardRequestForURL:url HTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
        NSHTTPURLResponse* _resp = (NSHTTPURLResponse*)resp;
        if (asplosion||[_resp statusCode]!=200) {
            if (failure) failure(_resp, payload, asplosion);
        } else if (success) success(_resp, [[JSONDecoder decoder] objectWithData:payload], payload);
    }];
}

- (void)discussionsWithIds:(NSArray*)ids
                    method:(enum NDRequestMethod)method
                 onSuccess:(NDSuccessBlock)success
                 onFailure:(NDFailureBlock)failure
{
    NSURL* url = [NSURL fs_URLWithString:@"/discussions/discussions" relativeToURL:self.serverUrl queryParameters:[[self copyOfDefaultURLParametersWithSessionId] fs_dictionaryByMergingDictionary:[NSDictionary dictionaryWithObject:[ids componentsJoinedByString:@","] forKey:@"discussion"]]];;
    NSMutableURLRequest* req = nil;
    switch (method) {
        case POST:
//            url = [NSURL fs_URLWithString:@"/discussions/discussions" relativeToURL:self.serverUrl queryParameters:[[self copyOfDefaultURLParametersWithSessionId] fs_dictionaryByMergingDictionary:[NSDictionary dictionaryWithObject:[ids componentsJoinedByString:@","] forKey:@"discussion"]]];
            req = [self standardRequestForURL:url HTTPMethod:@"POST"];
            [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
                NSHTTPURLResponse* _resp = (NSHTTPURLResponse*)resp;
                if (asplosion||[_resp statusCode]!=200) {
                    if (failure) failure(_resp, payload, asplosion);
                } else if (success) success(_resp, [[JSONDecoder decoder] objectWithData:payload], payload);
            }];
            break;
        case GET:
            // TODO: Fix this. It's probably broken in major ways.
            req = [self standardRequestForURL:url HTTPMethod:@"POST"];
            [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse* resp, NSData* payload, NSError* asplosion) {
                NSHTTPURLResponse* _resp = (NSHTTPURLResponse*)resp;
                if (asplosion||[_resp statusCode]!=200) {
                    if (failure) failure(_resp, payload, asplosion);
                } else if (success) success(_resp, [[JSONDecoder decoder] objectWithData:payload], payload);
            }];
            break;
        default:
            [NSException raise:@"net.fsdev.newdot.unrecognised-method" format:@"I can't really do squat with this, bub."];
            break;
    }
}

@end

//
//  NDService.h
//  NewDot
//
//  Created by Christopher Miller on 9/23/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NDSuccessBlock)(NSHTTPURLResponse* resp, id response, NSData* payload);
typedef void(^NDFailureBlock)(NSHTTPURLResponse* resp, NSData* payload, NSError* error);

enum NDRequestMethod {
    GET,
    POST
} NDRequestMethod;

/**
 * Service-layer interface for dealing with New(DOT)FamilySearch APIs and systems.
 *
 * This API is designed to facilitate easier access to FamilySearch APIs, as well as implement the default best-behavior. The overall effect is that you will be able to get to market faster by not having to write a lot of FamilySearch-specific API details yourself.
 *
 * Data is returned from JSON as a bunch of Cocoa data containers. Please use key-value *paths* to query through the results; it's faster, easier, more delicious, and makes people happy.
 *
 * NDService itself is an object which fires off `NSURLRequest`s at light-speed to the FamilySearch API servers. A single NDService object represents a single connection to the API; to create multiple connections (and thereby sessions) you will require multiple NDService objects.
 *
 * NDService requests are all sent asynchronously; it is perfectly safe to call any of the request methods from the main thread of your application; the system will not block. No support for synchronous calls is planned.
 *
 * Results are provided to you via re-entrant blocks.
 *
 * Every module is provided as its own category on this interface; to use those requests, import the category.
 *
 * For every web call there are usually four request methods you can utilize:
 *
 * - `request`, which returns an `NSURLRequest*`. You can fire this off and it will perform the desired request.
 * - `operation...withTargetThread`, which returns an `NDHTTPURLOperation` that will fire the web request and callbacks on the indicated `NSThread`.
 * - `operation`, which returns an `NDHTTPURLOperation` that will fire the web request and callbacks on the default worker thread (the `networkRequestThread` of the `NDHTTPURLOperation` class)
 * - And finally the verb method, which creates the `NDHTTPURLOperation` using the `NSURLRequest` and puts it into an operation queue for you. If you don't need to perform any dependency work or use a special thread (to avoid threadlocks) then this is the easiest method to use.
 */
@interface NDService : NSObject

/**
 * The base URL prefixed to all API requests.
 */
@property (readonly, strong) NSURL* serverUrl;

/**
 * The session ID for the current NDService; nil if the receiver is not logged in.
 */
@property (readwrite, strong) NSString* sessionId;

/**
 * Set the receiver's `User-Agent` header; useful for disambiguating between multiple clients running on the same API key. If set to `nil`, then it is actually set to `NewDot/x.x`.
 */
@property (readwrite, strong) NSString* userAgent;

/**
 * These parameters are appeneded to every request URL; by default, only `dataFormat=application/json` will be in here.
 */
@property (readwrite, strong) NSMutableDictionary* defaultURLParameters;

@property (readwrite, strong) NSOperationQueue* operationQueue;

/**
 * Make a new NDService object bound to the given base URL, with the given `User-Agent`.
 *
 * @param newServerUrl The base URL prefixed to all requests.
 * @param newUserAgent The `User-Agent` string; if `nil`, it defaults to `NewDot/x.x`.
 */
- (id)initWithBaseURL:(NSURL*)newServerUrl
            userAgent:(NSString*)newUserAgent;

@end

//
//  NSData+UTF8String.m
//  NewDot
//
//  Created by Christopher Miller on 10/28/11.
//  Copyright (c) 2011 FSDEV. All rights reserved.
//

#import "NSData+UTF8String.h"

@implementation NSData (UTF8String)

- (NSString*)fs_UTF8String
{
    return [NSString stringWithCString:[self bytes] encoding:NSUTF8StringEncoding];
}

@end

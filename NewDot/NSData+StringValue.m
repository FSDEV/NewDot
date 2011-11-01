//
//  NSData+UTF8String.m
//  NewDot
//
//  Created by Christopher Miller on 10/28/11.
//  Copyright (c) 2011 FSDEV. All rights reserved.
//

#import "NSData+StringValue.h"

@implementation NSData (StringValue)

- (NSString*)fs_stringValue
{
    return [NSString stringWithCString:[self bytes] encoding:NSUTF8StringEncoding];
}

@end

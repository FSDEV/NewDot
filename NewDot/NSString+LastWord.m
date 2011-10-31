//
//  NSString+LastWord.m
//  NewDot
//
//  Created by Christopher Miller on 10/7/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NSString+LastWord.h"

@implementation NSString (LastWord)

- (NSString*)fs_lastWord
{
    return [[self componentsSeparatedByString:@" "] lastObject];
}

@end

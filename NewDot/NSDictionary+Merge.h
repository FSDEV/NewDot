//
//  NSDictionary+Merge.h
//  NewDot
//
//  Created by Christopher Miller on 9/27/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Small utility to merge an `NSDictionary` into an existing `NSDictionary`.
 */
@interface NSDictionary (Merge)

/**
 * Merges this dictionary with another dictionary.
 * 
 * @warning Any duplicate entries in `self` will be overwritten by the entries in `aDict`.
 *
 * @param aDict The `NSDictionary` to be merged into a mutable copy of `self` to create a new `NSDictionary`.
 */
- (NSDictionary*)fs_dictionaryByMergingDictionary:(NSDictionary*)aDict;

@end

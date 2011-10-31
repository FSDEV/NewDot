//
//  NSArray+Chunky.h
//  NewDot
//
//  Created by Christopher Miller on 9/27/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Chunky)

/**
 * YOU GOT 'TA CHUNKIFY!!! JUST LIKE A BOW-LEGGÈD MONKEY!!! YOU GOT 'TA CHUNKIFY!!! NSAAAAAAARRRRAAAAYAH!
 *
 * Takes sth like this:
 *
 *     ( 1, 2, 3, 4, 5, 6, 7, 8, 9 )
 *
 * and then a call like this:
 *
 *     [myArray chunkifyWithMaxSize:3];
 *
 * will return sth like this:
 *
 *     ( ( 1, 2, 3 ), ( 4, 5, 6 ), ( 7, 8, 9 ))
 */
- (NSArray*)fs_chunkifyWithMaxSize:(NSUInteger)size;

@end

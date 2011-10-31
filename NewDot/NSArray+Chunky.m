//
//  NSArray+Chunky.m
//  NewDot
//
//  Created by Christopher Miller on 9/27/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#import "NSArray+Chunky.h"

@implementation NSArray (Chunky)

- (NSArray*)fs_chunkifyWithMaxSize:(NSUInteger)size
{
    /* Thanks @sethwillits! (https://gist.github.com/1157820, https://twitter.com/sethwillits/status/104641659681255424) */
    NSUInteger numFullChunks = (self.count / size);
	NSUInteger remainder = (self.count % size);
	NSArray** chunks = malloc(sizeof(NSArray*) * (numFullChunks + 1));
	NSArray* result = nil;
    
	for (NSUInteger i = 0; i < numFullChunks; i++) {
		chunks[i] = [self subarrayWithRange:NSMakeRange(i * size, size)];
	}
    
	if (remainder) {
		chunks[numFullChunks] = [self subarrayWithRange:NSMakeRange(numFullChunks * size, remainder)];
	}
    
	result = [NSArray arrayWithObjects:chunks count:(remainder ? (numFullChunks + 1) : numFullChunks)];
	free(chunks);
	return result;
}

@end

//
//  NSString+Base64.h
//  NewDot
//
//  Created by Christopher Miller on 10/31/11.
//  Copyright (c) 2011 FSDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

/* ============================
 * GIGANTIC COPYRIGHT NOTICE!!!
 * ============================
 * 
 * These were pilfered from https://github.com/mikeho/QSUtilities and is not originally authored by Chris Miller.
 * They appear to be in a standard MIT-style license.
 * The actual hard-core bits are from the PHP Core Library, and as such are under the PHP License: http://www.php.net/license/3_01.txt
 * 
 * Keep this in mind! It should be reasonably permissive, though if you have any doubts, it wouldn't hurt to read through both licenses to keep yourself clean.
 */


@interface NSString (Base64)

+ (NSString*)fs_encodeBase64UrlWithBase64:(NSString *)strBase64;
+ (NSString*)fs_encodeBase64WithString:(NSString *)strData;
+ (NSString*)fs_encodeBase64WithData:(NSData *)objData;

@end

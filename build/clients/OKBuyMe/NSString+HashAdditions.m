//
//  NSString+HashAdditions.m
//  RetailClient
//
//  Created by Taylan Pince on 10-10-28.
//  Copyright 2010 Hippo Foundry. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "NSString+HashAdditions.h"


@implementation NSString (NSString_HashAdditions)

- (NSString *)SHA1Hash {
	const char *cString = [self cStringUsingEncoding:NSUTF8StringEncoding];
	
	NSData *stringData = [NSData dataWithBytes:cString length:[self length]];
	
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	
	CC_SHA1([stringData bytes], [stringData length], digest);
	
	NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
	for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
		[outputString appendFormat:@"%02x", digest[i]];
	}
	
	return outputString;
}

@end

//
//  NSObject+KVCAdditions.m
//  CityState
//
//  Created by Taylan Pince on 10-09-21.
//  Copyright 2010 Hippo Foundry. All rights reserved.
//

#import "NSObject+KVCAdditions.h"


@implementation NSObject (NSObject_KVCAdditions)

- (id)nonNullValueForKey:(NSString *)aKey {
	id obj = [self valueForKey:aKey];

	if (obj == [NSNull null]) {
		obj = nil;
	}

	return obj;
}

- (id)nonNilValueForKey:(NSString *)aKey {
	id obj = [self valueForKey:aKey];
	
	if (obj == nil) {
		obj = [NSNull null];
	}
	
	return obj;
}

- (NSInteger)integerValueForKey:(NSString *)aKey {
	return [[self nonNullValueForKey:aKey] integerValue];
}

- (CGFloat)CGFloatValueForKey:(NSString *)aKey {
	id value = [self nonNullValueForKey:aKey];

	return ([value respondsToSelector:@selector(doubleValue)] ? [value doubleValue] : 0.0);
}

- (NSTimeInterval)timeIntervalValueForKey:(NSString *)aKey {
	id value = [self nonNullValueForKey:aKey];

	return ([value respondsToSelector:@selector(doubleValue)] ? [value doubleValue] : 0.0);
}

- (NSURL *)URLValueForKey:(NSString *)aKey {
	NSString *str = [self nonNullValueForKey:aKey];

	return (str != nil ? [NSURL URLWithString:str] : nil);
}

- (UIColor *)colorValueWithHexStringForKey:(NSString *)aKey {
    NSString *str = [self nonNullValueForKey:aKey];
    str = [str substringWithRange:NSMakeRange([str length] - 6, 6)];
    
    if (str == nil) {
		return [UIColor clearColor];
	}
    
    CGFloat comps[3] = { 0.0 };
    
    for(NSUInteger i = 0; i < 3; i++) {
        NSScanner *scanner = [[NSScanner alloc] initWithString:[str substringWithRange:NSMakeRange(2 * i, 2)]];
        unsigned v = 0;
        [scanner scanHexInt:&v];
        comps[i] = v / 255.0;
        [scanner release];
    }
    
    return [UIColor colorWithRed:comps[0] green:comps[1] blue:comps[2] alpha:1.0];
}

- (NSDate *)dateValueFromString:(NSString *)string withDateFormat:(NSString *)dateFormat {
	static NSDateFormatter *formatter = nil;
	
    if (formatter == nil) {
		// We enforce north american locale, otherwise it causes issues on devices with different locales set
		NSLocale *northAmericanLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
		
        formatter = [[NSDateFormatter alloc] init];
		
		[formatter setLocale:northAmericanLocale];
		
		[northAmericanLocale release];
    }

	[formatter setDateFormat:dateFormat];
    
	return [formatter dateFromString:string];
}

- (NSDate *)dateValueForKey:(NSString *)aKey withDateFormat:(NSString *)dateFormat {
	NSString *str = [self nonNullValueForKey:aKey];
	
    return (str == nil) ? nil : [self dateValueFromString:str withDateFormat:dateFormat];
}

- (NSDate *)dateValueForKey:(NSString *)aKey {
	// FORMAT: Fri, 10 Sep 2010 07:44:06 -0000
	return [self dateValueForKey:aKey withDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"];
}

- (NSDate *)timeValueForKey:(NSString *)aKey withDateFormat:(NSString *)dateFormat {
	NSString *str = [self nonNullValueForKey:aKey];
	
	if (str != nil) {
		NSString *prefixFormat = @"yyyy-MM-dd";
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		NSLocale *northAmericanLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
		
		[formatter setLocale:northAmericanLocale];
		[formatter setDateFormat:prefixFormat];

		NSString *today = [formatter stringFromDate:[NSDate date]];
		
		[northAmericanLocale release];
		[formatter release];
		
		return [self dateValueFromString:[NSString stringWithFormat:@"%@ %@", today, str] 
						  withDateFormat:[NSString stringWithFormat:@"%@ %@", prefixFormat, dateFormat]];
	} else {
		return nil;
	}
}

- (NSDate *)dateValueForTimeIntervalKey:(NSString *)aKey {
	NSTimeInterval interval = [self timeIntervalValueForKey:aKey];
	
	return [NSDate dateWithTimeIntervalSince1970:interval];
}

@end

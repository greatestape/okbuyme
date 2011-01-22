//
//  NSObject+KVCAdditions.h
//  CityState
//
//  Created by Taylan Pince on 10-09-21.
//  Copyright 2010 Hippo Foundry. All rights reserved.
//

@interface NSObject (NSObject_KVCAdditions)
- (id)nonNullValueForKey:(NSString *)aKey;
- (id)nonNilValueForKey:(NSString *)aKey;
- (NSURL *)URLValueForKey:(NSString *)aKey;
- (NSInteger)integerValueForKey:(NSString *)aKey;
- (CGFloat)CGFloatValueForKey:(NSString *)aKey;
- (NSTimeInterval)timeIntervalValueForKey:(NSString *)aKey;
- (NSDate *)dateValueForKey:(NSString *)aKey;
- (NSDate *)timeValueForKey:(NSString *)aKey withDateFormat:(NSString *)dateFormat;
- (NSDate *)dateValueForKey:(NSString *)aKey withDateFormat:(NSString *)dateFormat;
- (NSDate *)dateValueFromString:(NSString *)string withDateFormat:(NSString *)dateFormat;
- (NSDate *)dateValueForTimeIntervalKey:(NSString *)aKey;
- (UIColor *)colorValueWithHexStringForKey:(NSString *)aKey;
@end

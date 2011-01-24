//
//  CacheManager.h
//  blogTO
//
//  Created by Taylan Pince on 10-12-10.
//  Copyright 2010 Hippo Foundry. All rights reserved.
//


@interface CacheItem : NSObject {
@private
	NSData *_cacheData;
	NSDate *_timeStamp;
	NSString *_MIMEType;
	NSString *_cachePath;
}

@property (nonatomic, retain, readonly) NSData *cacheData;
@property (nonatomic, retain, readonly) NSDate *timeStamp;
@property (nonatomic, retain, readonly) NSString *MIMEType;
@property (nonatomic, retain, readonly) NSString *cachePath;

+ (CacheItem *)cacheItemWithCacheData:(NSData *)data path:(NSString *)path MIMEType:(NSString *)type stamp:(NSDate *)stamp;
+ (CacheItem *)cacheItemWithPickledObject:(NSDictionary *)pickle;

- (id)initWithCacheData:(NSData *)data path:(NSString *)path MIMEType:(NSString *)type stamp:(NSDate *)stamp;
- (id)initWithPickledObject:(NSDictionary *)pickle;
- (NSDictionary *)pickledObjectForArchive;

@end


@interface CacheManager : NSObject {
@private
	NSString *_cacheDirectoryPath;
	NSOperationQueue *_saveQueue;
}

+ (CacheManager *)sharedManager;

- (CacheItem *)cachedItemForCacheKey:(NSString *)cacheKey;
- (void)cacheData:(NSData *)cacheData forCacheKey:(NSString *)cacheKey withMIMEType:(NSString *)MIMEType;

- (CacheItem *)cachedItemForURL:(NSURL *)url;
- (void)cacheData:(NSData *)cacheData forURL:(NSURL *)url withMIMEType:(NSString *)MIMEType;

- (void)clearCacheForCacheKey:(NSString *)cacheKey;
- (void)clearCacheForURL:(NSURL *)url;

@end

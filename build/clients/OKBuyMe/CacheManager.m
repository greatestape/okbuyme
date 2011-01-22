//
//  CacheManager.m
//  blogTO
//
//  Created by Taylan Pince on 10-12-10.
//  Copyright 2010 Hippo Foundry. All rights reserved.
//

#import "CacheManager.h"
#import "NSString+HashAdditions.h"


const NSUInteger kURLCacheMemoryCapacity = 1024 * 1024;
const NSUInteger kURLCacheDiskCapacity = 10 * 1024 * 1024;

double const kStaleCacheInterval = 60.0 * 60.0 * 48.0;

static NSString * const kURLCachePath = @"caches";
static NSString * const kURLCacheFilename = @"shared";

static NSString * const kCacheInfoPathKey = @"cachePath";
static NSString * const kCacheInfoDataKey = @"cacheData";
static NSString * const kCacheInfoDateKey = @"cacheDate";
static NSString * const kCacheInfoMIMETypeKey = @"mimeType";


@interface URLCache : NSURLCache
@end


@interface CacheManager (PrivateMethods)
- (void)storeCacheWithCacheItem:(CacheItem *)cacheItem;
- (NSString *)cachePathForCacheKey:(NSString *)cacheKey;
@end


@implementation CacheItem

@synthesize cachePath = _cachePath;
@synthesize cacheData = _cacheData;
@synthesize timeStamp = _timeStamp;
@synthesize MIMEType = _MIMEType;

+ (CacheItem *)cacheItemWithCacheData:(NSData *)data path:(NSString *)path MIMEType:(NSString *)type stamp:(NSDate *)stamp {
	return [[[CacheItem alloc] initWithCacheData:data path:path MIMEType:type stamp:stamp] autorelease];
}

+ (CacheItem *)cacheItemWithPickledObject:(NSDictionary *)pickle {
	return [[[CacheItem alloc] initWithPickledObject:pickle] autorelease];
}

- (id)initWithCacheData:(NSData *)data path:(NSString *)path MIMEType:(NSString *)type stamp:(NSDate *)stamp {
	self = [super init];
	
	if (self) {
		_cachePath = [path copy];
		_cacheData = [data copy];
		_MIMEType = [type copy];
		
		if (stamp != nil) {
			_timeStamp = [stamp copy];
		} else {
			_timeStamp = [[NSDate date] copy];
		}
	}
	
	return self;
}

- (id)initWithPickledObject:(NSDictionary *)pickle {
	return [self initWithCacheData:[pickle objectForKey:kCacheInfoDataKey] 
							  path:[pickle objectForKey:kCacheInfoPathKey] 
						  MIMEType:[pickle objectForKey:kCacheInfoMIMETypeKey] 
							 stamp:[pickle objectForKey:kCacheInfoDateKey]];
}

- (NSDictionary *)pickledObjectForArchive {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			_cacheData, kCacheInfoDataKey, 
			_timeStamp, kCacheInfoDateKey, 
			_cachePath, kCacheInfoPathKey, 
			_MIMEType, kCacheInfoMIMETypeKey, nil];
}

- (void)dealloc {
	[_timeStamp release], _timeStamp = nil;
	[_cachePath release], _cachePath = nil;
	[_cacheData release], _cacheData = nil;
	[_MIMEType release], _MIMEType = nil;
	
	[super dealloc];
}

@end


@implementation CacheManager

static CacheManager *_sharedManager = nil;

+ (void)initialize {
	if (self == [CacheManager class]) {
		_sharedManager = [[CacheManager alloc] init];
	}
}

+ (CacheManager *)sharedManager {
	return _sharedManager;
}

- (id)init {
	if (self = [super init]) {
		_saveQueue = [[NSOperationQueue alloc] init];
		_cacheDirectoryPath = [[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] 
								stringByAppendingPathComponent:kURLCachePath] retain];
		
		[_saveQueue setMaxConcurrentOperationCount:1];
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		BOOL directoryExists = NO;
		
		if (![fileManager fileExistsAtPath:_cacheDirectoryPath isDirectory:&directoryExists] || !directoryExists) {
			[fileManager createDirectoryAtPath:_cacheDirectoryPath 
				   withIntermediateDirectories:YES 
									attributes:nil 
										 error:nil];
		}
		
		URLCache *urlCache = [[URLCache alloc] initWithMemoryCapacity:kURLCacheMemoryCapacity 
														 diskCapacity:kURLCacheDiskCapacity 
															 diskPath:_cacheDirectoryPath];
		
		[NSURLCache setSharedURLCache:urlCache];
		
		[urlCache release];
	}
	
	return self;
}

- (NSString *)cachePathForCacheKey:(NSString *)cacheKey {
	return [_cacheDirectoryPath stringByAppendingPathComponent:cacheKey];
}

- (CacheItem *)cachedItemForCacheKey:(NSString *)cacheKey {
	NSDictionary *pickle = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePathForCacheKey:cacheKey]];
	
	if (pickle != nil) {
		CacheItem *cachedItem = [CacheItem cacheItemWithPickledObject:pickle];
		
		if (cachedItem.timeStamp == nil || (cachedItem.timeStamp != nil && (-1 * [cachedItem.timeStamp timeIntervalSinceNow]) > kStaleCacheInterval)) {
			[self clearCacheForCacheKey:cacheKey];
			
			return nil;
		} else {
			return cachedItem;
		}
	} else {
		return nil;
	}
}

- (CacheItem *)cachedItemForURL:(NSURL *)url {
	return [self cachedItemForCacheKey:[[url absoluteString] SHA1Hash]];
}

- (void)cacheData:(NSData *)cacheData forCacheKey:(NSString *)cacheKey withMIMEType:(NSString *)MIMEType {
	if (cacheData != nil) {
		NSString *cachePath = [self cachePathForCacheKey:cacheKey];
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
			[_saveQueue addOperation:[[[NSInvocationOperation alloc] initWithTarget:self 
																		   selector:@selector(storeCacheWithCacheItem:) 
																			 object:[CacheItem cacheItemWithCacheData:cacheData 
																												 path:cachePath 
																											 MIMEType:MIMEType 
																												stamp:nil]] autorelease]];
		}
	}
}

- (void)cacheData:(NSData *)cacheData forURL:(NSURL *)url withMIMEType:(NSString *)MIMEType {
	if (cacheData != nil) {
		[self cacheData:cacheData 
			forCacheKey:[[url absoluteString] SHA1Hash] 
		   withMIMEType:MIMEType];
	}
}

- (void)storeCacheWithCacheItem:(CacheItem *)cacheItem {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	[NSKeyedArchiver archiveRootObject:[cacheItem pickledObjectForArchive] 
								toFile:cacheItem.cachePath];
	
	[pool drain];
}

- (void)clearCacheForCacheKey:(NSString *)cacheKey {
	NSError *error;
	NSString *cachePath = [self cachePathForCacheKey:cacheKey];

	if (![[NSFileManager defaultManager] removeItemAtPath:cachePath error:&error]) {
		NSLog(@"ERROR: %@", [error localizedDescription]);
	}
}

- (void)clearCacheForURL:(NSURL *)url {
	[self clearCacheForCacheKey:[[url absoluteString] SHA1Hash]];
}

- (void)dealloc {
	[_saveQueue cancelAllOperations];
	[_saveQueue release], _saveQueue = nil;
	[_cacheDirectoryPath release], _cacheDirectoryPath = nil;
	
	[super dealloc];
}

@end


@implementation URLCache

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
	NSCachedURLResponse *memoryResponse = [super cachedResponseForRequest:request];
	
	if (memoryResponse != nil) {
		return memoryResponse;
	}
	
	NSURL *requestURL = [request URL];
	CacheItem *cacheItem = [[CacheManager sharedManager] cachedItemForURL:requestURL];

	if (cacheItem != nil) {
		NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:requestURL 
																	MIMEType:cacheItem.MIMEType 
													   expectedContentLength:[cacheItem.cacheData length] 
															textEncodingName:nil];
		
		NSCachedURLResponse *cachedResponse = [[[NSCachedURLResponse alloc] initWithResponse:response 
																						data:cacheItem.cacheData] autorelease];
		
		[self storeCachedResponse:cachedResponse forRequest:request];
		
		[response release];
		
		return cachedResponse;
	}

	return nil;
}

@end

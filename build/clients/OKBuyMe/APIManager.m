//
//  APIManager.m
//  CityState
//
//  Created by Taylan Pince on 10-09-17.
//  Copyright 2010 Hippo Foundry. All rights reserved.
//

#import <Security/Security.h>

#import "JSON.h"

#import "User.h"
#import "APIManager.h"
#import "APIRequest.h"
#import "CacheManager.h"
#import "ImageOperation.h"
#import "KeychainItemWrapper.h"
#import "NSString+HashAdditions.h"


static NSString * const kGeocodeURL = @"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true";
static NSString * const kAPIBaseURL = @"http://ubuntu.local:7999%@";
static NSString * const kUsersPath = @"/users/";
static NSString * const kItemsPath = @"/lists/";

static NSString * const kKeychainIdentifier = @"OKBuyMeAccount";


@interface APIManager (PrivateMethods)
- (void)enqueueRequest:(APIRequest *)request;

- (id)parseJSONData:(NSData *)loadedData;
- (NSString *)encodeURL:(NSString *)string;
- (NSData *)dataFromDict:(NSDictionary *)dict;
- (NSData *)dataFromArray:(NSArray *)array withKey:(NSString *)key;
- (NSString *)pathFromBasePath:(NSString *)basePath withOptions:(NSDictionary *)options;

- (APIRequest *)imageRequestForURL:(NSString *)urlString;
- (APIRequest *)requestForPath:(NSString *)path withBaseURL:(NSString *)baseURL 
					  withData:(NSData *)data method:(APIRequestMethod)method cached:(BOOL)cached;
@end


@implementation APIManager

static APIManager *_sharedManager = nil;

#pragma mark -
#pragma mark Init

+ (void)initialize {
	if (self == [APIManager class]) {
		_sharedManager = [[APIManager alloc] init];
	}
}

+ (APIManager *)sharedManager {
	return _sharedManager;
}

- (id)init {
	if (self = [super init]) {
		_requestQueue = [[NSOperationQueue alloc] init];
		_processQueue = [[NSOperationQueue alloc] init];
		
		[_requestQueue setMaxConcurrentOperationCount:[[NSProcessInfo processInfo] activeProcessorCount] + 1];
		[_processQueue setMaxConcurrentOperationCount:[[NSProcessInfo processInfo] activeProcessorCount] + 1];
		
		[self getAuthorizationCredentials];
	}
	
	return self;
}

#pragma mark -
#pragma mark Authentication

- (BOOL)isAuthenticated {
	return (_username != nil && ![_username isEqualToString:@""] && _password != nil && ![_password isEqualToString:@""]);
}

- (void)getAuthorizationCredentials {
	KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:kKeychainIdentifier 
																	   accessGroup:nil];
	
	_username = [[wrapper objectForKey:(id)kSecAttrAccount] copy];
	_password = [[wrapper objectForKey:(id)kSecValueData] copy];
	
	[wrapper release];
}

- (void)removeAuthorizationCredentials {
	KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:kKeychainIdentifier 
																	   accessGroup:nil];
	
	[wrapper resetKeychainItem];
	[wrapper release];
	
	[_username release], _username = nil;
	[_password release], _password = nil;
}

#pragma mark -
#pragma mark Generic Request Methods

- (id)parseJSONData:(NSData *)loadedData {
	NSString *resource = [[NSString alloc] initWithBytesNoCopy:(void *)[loadedData bytes]
														length:[loadedData length]
													  encoding:NSUTF8StringEncoding
												  freeWhenDone:NO];
	
	id ret = [resource JSONValue];
	
	[resource release];
	
	return ret;
}

- (APIRequest *)requestForPath:(NSString *)path withBaseURL:(NSString *)baseURL 
					  withData:(NSData *)data method:(APIRequestMethod)method cached:(BOOL)cached {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:baseURL, path]];
	APIRequest *request = [APIRequest requestForURL:url 
										   withData:data 
											 method:method 
											 cached:cached];
	
	[request setParserBlock:^ id (NSData *loadedData) {
		return [self parseJSONData:loadedData];
	}];
	
	return request;
}

- (APIRequest *)imageRequestForURL:(NSString *)urlString {
	NSURL *url = [NSURL URLWithString:urlString];
	APIRequest *request = [APIRequest requestForURL:url 
										   withData:nil 
											 method:APIRequestMethodGet 
											 cached:YES];
	
	[request setParserBlock:^ id (NSData *loadedData) {
		UIImage *image = [UIImage imageWithData:loadedData];
		
		return image;
	}];
	
	return request;
}

- (void)enqueueRequest:(APIRequest *)request {
	if (![request isExecuting] && ![request isFinished] && ![[_requestQueue operations] containsObject:request]) {
		[_requestQueue addOperation:request];
	}
}

- (NSString*)encodeURL:(NSString *)string {
	NSString *newString = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
																			   (CFStringRef)string, 
																			   NULL, 
																			   CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), 
																			   CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) autorelease];
	
	if (newString) {
		return newString;
	}
	
	return @"";
}

- (NSData *)dataFromDict:(NSDictionary *)dict {
	NSMutableString *dataString = [NSMutableString string];
	
	for (NSString *key in [dict allKeys]) {
		[dataString appendFormat:@"%@=%@&", key, [self encodeURL:[dict objectForKey:key]]];
	}

	return [dataString dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)dataFromArray:(NSArray *)array withKey:(NSString *)key {
	NSMutableString *dataString = [NSMutableString string];
	
	for (NSString *value in array) {
		[dataString appendFormat:@"%@=%@&", key, [self encodeURL:value]];
	}

	return [dataString dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)pathFromBasePath:(NSString *)basePath withOptions:(NSDictionary *)options {
	NSMutableString *requestPath = [NSMutableString stringWithString:basePath];
	
	if (options != nil) {
		for (NSString *key in [options allKeys]) {
			[requestPath appendFormat:@"&%@=%@", key, [self encodeURL:[options objectForKey:key]]];
		}
	}
	
	return requestPath;
}

- (NSArray *)activeRequestOperations {
	return [_requestQueue operations];
}

- (NSArray *)activeProcessOperations {
	return [_processQueue operations];
}

#pragma mark -
#pragma mark User calls

- (void)registerUserWithInfo:(NSDictionary *)userInfo withCompletionBlock:(void (^)(id, NSError *))block {
	APIRequest *request = [self requestForPath:[self pathFromBasePath:kUsersPath 
														  withOptions:nil] 
								   withBaseURL:kAPIBaseURL 
									  withData:[self dataFromDict:userInfo] 
										method:APIRequestMethodPost 
										cached:NO];
	
	[request addCompletionBlock:block];
	
	[self enqueueRequest:request];
}

#pragma mark -
#pragma mark Geolocation

- (void)getGeocoderResultsForAddress:(NSString *)address withCompletionBlock:(void (^)(id, NSError *))block {
	APIRequest *request = [self requestForPath:[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] 
								   withBaseURL:kGeocodeURL 
									  withData:nil 
										method:APIRequestMethodGet 
										cached:YES];
	
	[request addCompletionBlock:block];
	
	[self enqueueRequest:request];
}

#pragma mark -
#pragma mark Image calls

- (void)loadImageAtURL:(NSString *)imageURL 
		 withIndexPath:(NSIndexPath *)indexPath 
	   completionBlock:(void (^)(id, NSError *))block 
			scaleToFit:(CGSize)targetSize 
		   contentMode:(UIViewContentMode)contentMode {
	APIRequest *request = [self imageRequestForURL:imageURL];
	
	[request setIndexPath:indexPath];

	if (CGSizeEqualToSize(targetSize, CGSizeZero)) {
		[request addCompletionBlock:block];
	} else {
		[request addCompletionBlock:^ void (id resources, NSError *error) {
			if (resources != nil) {
				ImageOperation *operation = [[ImageOperation alloc] initWithImage:(UIImage *)resources 
																	   targetSize:targetSize 
																	  contentMode:contentMode 
																		 cacheKey:[imageURL SHA1Hash]];
				
				[operation setIndexPath:indexPath];
				[operation addCompletionBlock:block];
				
				[_processQueue addOperation:operation];
				
				[operation release];
			} else {
				block(resources, error);
			}
		}];
	}

	[self enqueueRequest:request];
}

- (void)resizeImage:(UIImage *)sourceImage 
	   toTargetSize:(CGSize)targetSize 
	   withCacheKey:(NSString *)cacheKey 
	completionBlock:(void (^)(id, NSError *))block {
	ImageOperation *operation = [[ImageOperation alloc] initWithImage:sourceImage 
														   targetSize:targetSize 
														  contentMode:UIViewContentModeScaleAspectFill 
															 cacheKey:cacheKey];
	
	[operation addCompletionBlock:block];
	[operation setOutputFormat:ImageOperationOutputFormatRawData];
	
	[_processQueue addOperation:operation];
	
	[operation release];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[_requestQueue cancelAllOperations];
	[_processQueue cancelAllOperations];
	[_requestQueue release];
	[_processQueue release];
	
	[super dealloc];
}

@end

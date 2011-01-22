//
//  APIRequest.m
//  CityState
//
//  Created by Taylan Pince on 10-09-17.
//  Copyright 2010 Hippo Foundry. All rights reserved.
//

#import "APIRequest.h"
#import "CacheManager.h"


@interface APIRequest (PrivateMethods)
- (void)sendErrorToBlocks:(NSError *)error;
- (void)sendResourcesToBlocks:(id)resources;
- (void)sendResourcesToBlocks:(id)resources withError:(NSError *)error;
- (void)callParserBlockWithData:(NSData *)data;
@end


@implementation APIRequest

@synthesize indexPath = _indexPath;
@synthesize parserBlock = _parserBlock;

+ (APIRequest *)requestForURL:(NSURL *)url withData:(NSData *)data method:(APIRequestMethod)method cached:(BOOL)cached {
	return [[[self alloc] initWithURL:url data:data method:method cached:cached] autorelease];
}

- (id)initWithURL:(NSURL *)url data:(NSData *)data method:(APIRequestMethod)method cached:(BOOL)cached {
	if (self = [super init]) {
		_indexPath = nil;
		_isCached = cached;
		_requestMethod = method;
		_requestURL = [url copy];
		_requestData = [data copy];
		_completionBlocks = [[NSMutableSet alloc] init];
		
		_isCancelled = NO;
		_isExecuting = NO;
		_isFinished = NO;
		
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_requestURL 
															   cachePolicy:(_isCached) ? NSURLRequestReturnCacheDataElseLoad : NSURLRequestReloadIgnoringCacheData 
														   timeoutInterval:30.0];
		
		switch (_requestMethod) {
			case APIRequestMethodGet:
				[request setHTTPMethod:@"GET"];
				break;
			case APIRequestMethodPost:
				[request setHTTPMethod:@"POST"];
				break;
			case APIRequestMethodDelete:
				[request setHTTPMethod:@"DELETE"];
				break;
			case APIRequestMethodPut:
				[request setHTTPMethod:@"PUT"];
				break;
		}
		NSLog(@"%@: %@", [request HTTPMethod], [[request URL] absoluteString]);
		[request setValue:@"text/javascript" forHTTPHeaderField:@"Accept"];
		
		if (_requestData) {
			[request setHTTPBody:_requestData];
			[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
			[request setValue:[NSString stringWithFormat:@"%d", [_requestData length]] forHTTPHeaderField:@"Content-Length"];
		}
		
		_connection = [[NSURLConnection alloc] initWithRequest:request 
													  delegate:self 
											  startImmediately:NO];

		[_connection scheduleInRunLoop:[NSRunLoop mainRunLoop] 
							   forMode:NSRunLoopCommonModes];
	}
	
	return self;
}

- (void)dealloc {
	[_connection cancel];

    [_response release], _response = nil;
	[_indexPath release], _indexPath = nil;
    [_requestURL release], _requestURL = nil;
    [_connection release], _connection = nil;
    [_loadedData release], _loadedData = nil;
	[_requestData release], _requestData = nil;
	[_completionBlocks release], _completionBlocks = nil;
	
    [super dealloc];
}

- (void)start {
	if ([self isCancelled] || [self isFinished]) {
		return;
	}
	
	[self willChangeValueForKey:@"isExecuting"];
	_isExecuting = YES;
	[self didChangeValueForKey:@"isExecuting"];
	
	if (_connection == nil) {
		[self cancel];
	} else {
		[_connection start];
	}
}

- (void)cancel {
    [_connection cancel];
	
	[self willChangeValueForKey:@"isCancelled"];
	_isCancelled = YES;
	[self didChangeValueForKey:@"isCancelled"];
	
	[self callParserBlockWithData:nil];
}

- (BOOL)isConcurrent {
	return YES;
}

- (BOOL)isFinished {
	return _isFinished;
}

- (BOOL)isExecuting {
	return _isExecuting;
}

- (BOOL)isCancelled {
	return _isCancelled;
}

- (void)addCompletionBlock:(void(^)(id resources, NSError *error))block {
	[_completionBlocks addObject:[[block copy] autorelease]];
}

- (void)sendResourcesToBlocks:(id)resources {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:_cmd 
							   withObject:resources 
							waitUntilDone:NO];
		
		return;
	}
	
	[self sendResourcesToBlocks:resources withError:nil];
}

- (void)sendErrorToBlocks:(NSError *)error {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:_cmd 
							   withObject:error 
							waitUntilDone:NO];
		
		return;
	}

	[self sendResourcesToBlocks:nil withError:error];
}

- (void)sendResourcesToBlocks:(id)resources withError:(NSError *)error {
	for (void(^blk)(id resources, NSError *error) in _completionBlocks) {
		blk(resources, error);
	}

	[self willChangeValueForKey:@"isExecuting"];
	_isExecuting = NO;
	[self didChangeValueForKey:@"isExecuting"];
	
	[self willChangeValueForKey:@"isFinished"];
	_isFinished = YES;
	[self didChangeValueForKey:@"isFinished"];
}

- (void)callParserBlockWithData:(NSData *)data {
	if (data != nil) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

		if (![self isCancelled] && _parserBlock != nil) {
			id parsedData = _parserBlock(data);
			
			if ([parsedData respondsToSelector:@selector(objectForKey:)] && [parsedData objectForKey:@"error"] != nil) {
				[self sendResourcesToBlocks:nil];
			} else {
				[self sendResourcesToBlocks:parsedData];
			}
		} else {
			[self sendResourcesToBlocks:nil];
		}
		
		[pool drain];
	} else {
		[self sendResourcesToBlocks:nil];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	_response = [response retain];

	NSInteger statusCode = 0;

	if ([response respondsToSelector:@selector(statusCode)]) {
		statusCode = [(NSHTTPURLResponse *)response statusCode];
	}
	
	switch (statusCode) {
		case 500: {
			[connection cancel];
			
			[self callParserBlockWithData:nil];
			
			break;
		}
		default: {
			long long expectedLength = [response expectedContentLength];
			
			if (expectedLength == NSURLResponseUnknownLength) {
				expectedLength = 0;
			}
			
			_loadedData = [[NSMutableData alloc] initWithCapacity:expectedLength];
			
			break;
		}
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_loadedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self callParserBlockWithData:nil];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSInteger statusCode = 0;
	
	if ([_response respondsToSelector:@selector(statusCode)]) {
		statusCode = [(NSHTTPURLResponse *)_response statusCode];
	}
    
	if (statusCode == 304 || statusCode >= 400) {
		[self callParserBlockWithData:nil];
	} else {
		if (_isCached) {
			NSString *MIMEType = nil;
			
			if ([_response respondsToSelector:@selector(MIMEType)]) {
				MIMEType = [(NSHTTPURLResponse *)_response MIMEType];
			} else {
				MIMEType = @"text/plain";
			}

			[[CacheManager sharedManager] cacheData:_loadedData 
											 forURL:_requestURL 
									   withMIMEType:MIMEType];
		}
		
		[NSThread detachNewThreadSelector:@selector(callParserBlockWithData:) 
								 toTarget:self 
							   withObject:_loadedData];
	}
}

@end

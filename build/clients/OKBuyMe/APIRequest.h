//
//  APIRequest.h
//  CityState
//
//  Created by Taylan Pince on 10-09-17.
//  Copyright 2010 Hippo Foundry. All rights reserved.
//

typedef enum {
	APIRequestMethodGet,
	APIRequestMethodPost,
	APIRequestMethodPut,
	APIRequestMethodDelete
} APIRequestMethod;


@interface APIRequest : NSOperation {
@private
	APIRequestMethod _requestMethod;

    NSURL *_requestURL;
	NSData *_requestData;
	NSIndexPath *_indexPath;
    NSURLResponse *_response;
    NSMutableData *_loadedData;
    NSURLConnection *_connection;
    NSMutableSet *_completionBlocks;
    
    id (^_parserBlock)(NSData *data);
    
	BOOL _isCached;
	BOOL _isCancelled;
    BOOL _isExecuting;
    BOOL _isFinished;
}

@property(nonatomic, copy) id (^parserBlock)(NSData *data);
@property(nonatomic, copy) NSIndexPath *indexPath;

+ (APIRequest *)requestForURL:(NSURL *)url withData:(NSData *)data method:(APIRequestMethod)method cached:(BOOL)cached;

- (id)initWithURL:(NSURL *)url data:(NSData *)data method:(APIRequestMethod)method cached:(BOOL)cached;
- (void)addCompletionBlock:(void(^)(id resources, NSError *error))block;

@end

//
//  APIManager.h
//  OKBuyMe
//
//  Created by Taylan Pince on 10-09-17.
//  Copyright 2010 Hippo Foundry. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface APIManager : NSObject {
@private
	NSString *_username;
	NSString *_password;
	NSOperationQueue *_requestQueue;
	NSOperationQueue *_processQueue;
}

+ (APIManager *)sharedManager;

- (BOOL)isAuthenticated;
- (void)getAuthorizationCredentials;
- (void)removeAuthorizationCredentials;

- (NSArray *)activeRequestOperations;
- (NSArray *)activeProcessOperations;

- (void)registerUserWithInfo:(NSDictionary *)userInfo withCompletionBlock:(void (^)(id, NSError *))block;

- (void)getGeocoderResultsForAddress:(NSString *)address withCompletionBlock:(void (^)(id, NSError *))block;

- (void)loadImageAtURL:(NSString *)imageURL 
		 withIndexPath:(NSIndexPath *)indexPath 
	   completionBlock:(void (^)(id, NSError *))block 
			scaleToFit:(CGSize)targetSize 
		   contentMode:(UIViewContentMode)contentMode;

- (void)resizeImage:(UIImage *)sourceImage 
	   toTargetSize:(CGSize)targetSize 
	   withCacheKey:(NSString *)cacheKey 
	completionBlock:(void (^)(id, NSError *))block;

@end

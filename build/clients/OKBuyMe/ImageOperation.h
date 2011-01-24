//
//  ImageOperation.h
//  RetailClient
//
//  Created by Taylan Pince on 10-10-19.
//  Copyright 2010 Hippo Foundry. All rights reserved.
//


typedef enum {
	ImageOperationOutputFormatImage,
	ImageOperationOutputFormatRawData,
} ImageOperationOutputFormat;


@interface ImageOperation : NSOperation {
@private
	CGSize _targetSize;
	NSString *_cacheKey;
	UIImage *_sourceImage;
	NSIndexPath *_indexPath;
	UIViewContentMode _contentMode;
	NSMutableSet *_completionBlocks;
	
	ImageOperationOutputFormat _outputFormat;
}

@property (nonatomic, copy) NSIndexPath *indexPath;
@property (nonatomic, assign) ImageOperationOutputFormat outputFormat;

+ (NSString *)cacheKeyWithHash:(NSString *)hash targetSize:(CGSize)targetSize contentMode:(UIViewContentMode)contentMode;

- (id)initWithImage:(UIImage *)image targetSize:(CGSize)targetSize contentMode:(UIViewContentMode)contentMode cacheKey:(NSString *)cacheKey;
- (void)addCompletionBlock:(void(^)(id resources, NSError *error))block;

@end

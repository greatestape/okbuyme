//
//  ImageOperation.m
//  RetailClient
//
//  Created by Taylan Pince on 10-10-19.
//  Copyright 2010 Hippo Foundry. All rights reserved.
//

#import "CacheManager.h"
#import "ImageOperation.h"
#import "UIScreen+ScaleAdditions.h"


static inline double radians (double degrees) {return degrees * M_PI/180;}


@interface ImageOperation (PrivateMethods)
- (void)sendProcessedOutputToBlocks:(id)image;
- (void)sendProcessedOutputToBlocks:(id)image withError:(NSError *)error;
@end


@implementation ImageOperation

@synthesize indexPath = _indexPath;
@synthesize outputFormat = _outputFormat;

+ (NSString *)cacheKeyWithHash:(NSString *)hash targetSize:(CGSize)targetSize contentMode:(UIViewContentMode)contentMode {
	return [NSString stringWithFormat:@"%@_%f_%f_%d", 
			hash, targetSize.width, targetSize.height, contentMode];
}

- (id)initWithImage:(UIImage *)image targetSize:(CGSize)targetSize contentMode:(UIViewContentMode)contentMode cacheKey:(NSString *)cacheKey {
	if (self = [super init]) {
		CGFloat screenScaleRatio = [[UIScreen mainScreen] scaleRatio];
		
		_indexPath = nil;
		_contentMode = contentMode;
		_sourceImage = [image retain];
		_completionBlocks = [[NSMutableSet alloc] init];
		_targetSize = CGSizeMake(targetSize.width * screenScaleRatio, 
								 targetSize.height * screenScaleRatio);

		if (cacheKey != nil) {
			_cacheKey = [[ImageOperation cacheKeyWithHash:cacheKey 
											   targetSize:targetSize 
											  contentMode:_contentMode] copy];
		}
		
		_outputFormat = ImageOperationOutputFormatImage;
	}
	
	return self;
}

- (void)main {
	@try {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		if ((_sourceImage != nil || _cacheKey != nil) && ![self isCancelled]) {
			UIImage *finalImage = nil;
			BOOL alreadyCached = NO;
			
			if (_cacheKey != nil) {
				CacheItem *cacheItem = [[CacheManager sharedManager] cachedItemForCacheKey:_cacheKey];
				
				if (cacheItem != nil) {
					finalImage = [[UIImage alloc] initWithData:cacheItem.cacheData];
					alreadyCached = YES;
				}
			}
			
			if (_sourceImage != nil && finalImage == nil) {
				CGSize imageSize;
				
				switch (_sourceImage.imageOrientation) {
					case UIImageOrientationLeft:
					case UIImageOrientationRight:
						imageSize = CGSizeMake(_sourceImage.size.height, _sourceImage.size.width);
						
						break;
					default:
						imageSize = _sourceImage.size;
						
						break;
				}
				
				
				if (_targetSize.width > 0.0 && _targetSize.height > 0.0 && 
					(_targetSize.width != imageSize.width || _targetSize.height != imageSize.height)) {
					CGImageRef cgImage = NULL;
					
					double scale;

					switch (_contentMode) {
						case UIViewContentModeScaleAspectFill:
							scale = MAX(_targetSize.width / imageSize.width, _targetSize.height / imageSize.height);
							break;
						default:
							scale = MIN(_targetSize.width / imageSize.width, _targetSize.height / imageSize.height);
							break;
					}

					imageSize.width = floor(imageSize.width * scale);
					imageSize.height = floor(imageSize.height * scale);
					
					if (![self isCancelled]) {
						CGRect targetRect;
						CGSize targetSize;
						
						switch (_contentMode) {
							case UIViewContentModeScaleAspectFill:
								targetSize = _targetSize;
								targetRect = CGRectMake(floor((_targetSize.width - imageSize.width) / 2), 
														floor((_targetSize.height - imageSize.height) / 2), 
														imageSize.width, imageSize.height);

								break;
							default:
								targetSize = imageSize;
								targetRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
								break;
						}
						
						CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
						CGSize contextSize;
						
						switch (_sourceImage.imageOrientation) {
							case UIImageOrientationLeft:
							case UIImageOrientationRight:
								contextSize = CGSizeMake(targetSize.height, targetSize.width);
								
								break;
							default:
								contextSize = targetSize;
								
								break;
						}
						
						CGContextRef context = CGBitmapContextCreate(NULL, contextSize.width, contextSize.height, 8, 0, 
																	 colorSpace, (kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Host));
						
						switch (_sourceImage.imageOrientation) {
							case UIImageOrientationLeft: {
								CGContextRotateCTM(context, radians(90.0));
								CGContextTranslateCTM(context, 0.0, -1.0 * targetSize.height);
								
								break;
							}
							case UIImageOrientationRight: {
								CGContextRotateCTM(context, radians(-90.0));
								CGContextTranslateCTM(context, -1.0 * targetSize.width, 0.0);
								
								break;
							}
							case UIImageOrientationDown: {
								CGContextTranslateCTM(context, targetSize.width, targetSize.height);
								CGContextRotateCTM(context, radians(-180.0));
								
								break;
							}
							default:
								break;
						}
						
						if (context != nil) {
							CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
							CGContextSetBlendMode(context, kCGBlendModeCopy);
							
							if (![self isCancelled]) {
								CGContextDrawImage(context, targetRect, [_sourceImage CGImage]);
							}
							
							if (![self isCancelled]) {
								cgImage = CGBitmapContextCreateImage(context);
							}
							
							CGContextRelease(context);
						}
						
						CGColorSpaceRelease(colorSpace);
						
						if (cgImage != NULL) {
							finalImage = [[UIImage alloc] initWithCGImage:cgImage];
							
							CGImageRelease(cgImage);
						}
					}
				} else {
					if (![self isCancelled]) {
						finalImage = [[UIImage alloc] initWithCGImage:[_sourceImage CGImage]];
					}
				}
			}
			
			if (finalImage != nil && ![self isCancelled]) {
				if (_outputFormat == ImageOperationOutputFormatImage) {
					[self sendProcessedOutputToBlocks:finalImage];
				}
				
				if (!alreadyCached || _outputFormat == ImageOperationOutputFormatRawData) {
					NSData *imageData = UIImageJPEGRepresentation(finalImage, 1.0);
					
					if (imageData != nil && !alreadyCached) {
						[[CacheManager sharedManager] cacheData:imageData 
													forCacheKey:_cacheKey 
												   withMIMEType:@"image/jpeg"];
					}
					
					if (_outputFormat == ImageOperationOutputFormatRawData) {
						[self sendProcessedOutputToBlocks:imageData];
					}
				}
				
				[finalImage release];
			}
		}
		
		[pool drain];
	}
	@catch (NSException *e) {
		NSLog(@"RESIZE ERROR: %@", e);
	}
}

- (void)addCompletionBlock:(void(^)(id resources, NSError *error))block {
    [_completionBlocks addObject:[[block copy] autorelease]];
}

- (void)sendProcessedOutputToBlocks:(id)output {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:_cmd 
							   withObject:output 
							waitUntilDone:NO];
		
		return;
	}
	
	[self sendProcessedOutputToBlocks:output withError:nil];
}

- (void)sendProcessedOutputToBlocks:(id)output withError:(NSError *)error {
    for (void(^blk)(id resources, NSError *error) in _completionBlocks) {
        blk(output, error);
	}
}

- (void)dealloc {
	[_cacheKey release];
	[_indexPath release];
	[_sourceImage release];
	[_completionBlocks release];
	
	[super dealloc];
}

@end

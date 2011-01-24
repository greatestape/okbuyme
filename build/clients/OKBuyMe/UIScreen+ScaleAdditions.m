//
//  UIScreen+ScaleAdditions.m
//  blogTO
//
//  Created by Taylan Pince on 10-11-18.
//  Copyright 2010 Hippo Foundry. All rights reserved.
//

#import "UIScreen+ScaleAdditions.h"


@implementation UIScreen (UIScreen_ScaleAdditions)

- (CGFloat)scaleRatio {
	if ([self respondsToSelector:@selector(scale)]) {
		return self.scale;
	} else {
		return 1.0;
	}
}

@end

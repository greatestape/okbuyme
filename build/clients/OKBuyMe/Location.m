// 
//  Location.m
//  OKBuyMe
//
//  Created by Taylan Pince on 11-01-22.
//  Copyright 2011 Hippo Foundry. All rights reserved.
//

#import "Item.h"
#import "Location.h"
#import "NSObject+KVCAdditions.h"


@implementation Location 

@dynamic name;
@dynamic slug;
@dynamic items;

- (void)updateWithDictionary:(NSDictionary *)dict {
	self.slug = [dict nonNullValueForKey:@"slug"];
	self.name = [dict nonNullValueForKey:@"name"];
}

@end

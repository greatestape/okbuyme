// 
//  User.m
//  OKBuyMe
//
//  Created by Taylan Pince on 11-01-22.
//  Copyright 2011 Hippo Foundry. All rights reserved.
//

#import "User.h"
#import "Item.h"
#import "NSObject+KVCAdditions.h"


@implementation User 

@dynamic email;
@dynamic primaryKey;
@dynamic name;
@dynamic items;

- (void)updateWithDictionary:(NSDictionary *)dict {
	self.primaryKey = [dict nonNullValueForKey:@"id"];
	self.email = [dict nonNullValueForKey:@"email"];
	self.name = [dict nonNullValueForKey:@"name"];
}

@end

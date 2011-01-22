// 
//  Item.m
//  OKBuyMe
//
//  Created by Taylan Pince on 11-01-22.
//  Copyright 2011 Hippo Foundry. All rights reserved.
//

#import "Item.h"
#import "User.h"
#import "Location.h"
#import "NSObject+KVCAdditions.h"


@implementation Item 

@dynamic primaryKey;
@dynamic creationTime;
@dynamic note;
@dynamic name;
@dynamic modificationTime;
@dynamic owner;
@dynamic locations;

- (void)updateWithDictionary:(NSDictionary *)dict {
	self.primaryKey = [dict nonNullValueForKey:@"id"];
	self.name = [dict nonNullValueForKey:@"name"];
	self.note = [dict nonNullValueForKey:@"note"];
	self.creationTime = [dict dateValueForKey:@"creation_time" withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	self.modificationTime = [dict dateValueForKey:@"modification_time" withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSDictionary *ownerInfo = [dict nonNullValueForKey:@"owner"];
	
	if (ownerInfo != nil && self.owner == nil) {
		NSError *error = nil;
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" 
												  inManagedObjectContext:[self managedObjectContext]];
		
		[fetchRequest setFetchLimit:1];
		[fetchRequest setEntity:entity];
		[fetchRequest setIncludesPropertyValues:NO];
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"primaryKey == %@", [ownerInfo nonNullValueForKey:@"id"]]];
		
		NSArray *results = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
		
		if (results == nil || [results count] == 0) {
			User *user = [[User alloc] initWithEntity:entity 
					   insertIntoManagedObjectContext:[self managedObjectContext]];
			
			[user updateWithDictionary:ownerInfo];
			[user addItemsObject:self];
			
			self.owner = user;
			
			[user release];
		} else {
			User *user = [results objectAtIndex:0];
			
			[user addItemsObject:self];
			
			self.owner = user;
		}

		[fetchRequest release];
	}
	
	NSArray *locationsList = [dict nonNullValueForKey:@"locations"];
	
	if (locationsList != nil && [locationsList count] > 0) {
		[self removeLocations:self.locations];
		
		NSEntityDescription *locationEntity = [NSEntityDescription entityForName:@"Location" 
														  inManagedObjectContext:[self managedObjectContext]];
		
		for (NSDictionary *locationInfo in locationsList) {
			Location *location = [[Location alloc] initWithEntity:locationEntity 
								   insertIntoManagedObjectContext:[self managedObjectContext]];
			
			[location updateFromDictionary:locationInfo];
			[location addItemsObject:self];
			
			[self addLocationsObject:location];
			
			[location release];
		}
	}
}

@end

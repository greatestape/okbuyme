//
//  Location.h
//  OKBuyMe
//
//  Created by Taylan Pince on 11-01-22.
//  Copyright 2011 Hippo Foundry. All rights reserved.
//

#import <CoreData/CoreData.h>


@class Item;

@interface Location : NSManagedObject {
	
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *slug;
@property (nonatomic, retain) NSSet *items;

- (void)updateWithDictionary:(NSDictionary *)dict;

@end


@interface Location (CoreDataGeneratedAccessors)
- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;
@end

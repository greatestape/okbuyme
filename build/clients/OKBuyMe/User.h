//
//  User.h
//  OKBuyMe
//
//  Created by Taylan Pince on 11-01-22.
//  Copyright 2011 Hippo Foundry. All rights reserved.
//

#import <CoreData/CoreData.h>


@class Item;

@interface User : NSManagedObject {
	
}

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSNumber *primaryKey;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSSet *items;

- (void)updateWithDictionary:(NSDictionary *)dict;

@end


@interface User (CoreDataGeneratedAccessors)
- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;
@end

//
//  Item.h
//  OKBuyMe
//
//  Created by Taylan Pince on 11-01-22.
//  Copyright 2011 Hippo Foundry. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Item : NSManagedObject {
	
}

@property (nonatomic, retain) NSNumber *primaryKey;
@property (nonatomic, retain) NSDate *creationTime;
@property (nonatomic, retain) NSString *note;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDate *modificationTime;
@property (nonatomic, retain) NSManagedObject *owner;
@property (nonatomic, retain) NSSet *locations;

- (void)updateWithDictionary:(NSDictionary *)dict;

@end


@interface Item (CoreDataGeneratedAccessors)
- (void)addLocationsObject:(NSManagedObject *)value;
- (void)removeLocationsObject:(NSManagedObject *)value;
- (void)addLocations:(NSSet *)value;
- (void)removeLocations:(NSSet *)value;
@end

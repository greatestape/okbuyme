//
//  ItemDetailViewController.h
//  OKBuyMe
//
//  Created by Taylan Pince on 11-01-22.
//  Copyright 2011 Hippo Foundry. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "ItemAddEditViewController.h"


@class Item;

@interface ItemDetailViewController : UITableViewController <ItemAddEditViewControllerDelegate> {
@private
	Item *_item;

	NSManagedObjectContext *_scratchObjectContext;
}

- (id)initWithItem:(Item *)item;

@end

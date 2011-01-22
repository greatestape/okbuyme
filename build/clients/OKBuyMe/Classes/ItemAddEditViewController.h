//
//  ItemAddEditViewController.h
//  OKBuyMe
//
//  Created by Taylan Pince on 11-01-22.
//  Copyright 2011 Hippo Foundry. All rights reserved.
//

#import <CoreData/CoreData.h>


@class Item;
@protocol ItemAddEditViewControllerDelegate;

@interface ItemAddEditViewController : UITableViewController {
@private
	Item *_item;
	NSManagedObjectContext *_managedObjectContext;
	
	id <ItemAddEditViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id <ItemAddEditViewControllerDelegate> delegate;

- (id)initWithItem:(Item *)item;
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end


@protocol ItemAddEditViewControllerDelegate
@required
- (void)itemAddEditViewController:(ItemAddEditViewController *)controller didCloseWithSave:(BOOL)save;
@end

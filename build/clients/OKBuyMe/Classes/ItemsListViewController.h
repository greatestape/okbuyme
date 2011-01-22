//
//  ItemsListViewController.h
//  OKBuyMe
//
//  Created by Taylan Pince on 11-01-22.
//  Copyright 2011 Hippo Foundry. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "ItemAddEditViewController.h"


@interface ItemsListViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchDisplayDelegate, ItemAddEditViewControllerDelegate> {
@private
	NSString *_searchKeywords;
	NSManagedObjectContext *_managedObjectContext;
	NSManagedObjectContext *_scratchObjectContext;
	NSFetchedResultsController *_searchResultsController;
	NSFetchedResultsController *_fetchedResultsController;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end

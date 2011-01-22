//
//  ItemsListViewController.m
//  OKBuyMe
//
//  Created by Taylan Pince on 11-01-22.
//  Copyright 2011 Hippo Foundry. All rights reserved.
//

#import "Item.h"
#import "Location.h"
#import "ItemDetailViewController.h"
#import "ItemsListViewController.h"
#import "NSDate+Helpers.h"


@interface ItemsListViewController (PrivateMethods)
- (void)didTapAdd:(id)sender;
- (void)refreshFetchedResults;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forSearchResult:(BOOL)searchResult;
@end


@implementation ItemsListViewController

#pragma mark -
#pragma mark Initialization

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
	self = [super initWithStyle:UITableViewStylePlain];
	
	if (self) {
		_managedObjectContext = [context retain];
	}
	
	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setTitle:@"OK Buy Me"];
	
	UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0)];
	UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar 
																					contentsController:self];
	
	[searchController setDelegate:self];
	[searchController setSearchResultsDataSource:self];
	[searchController setSearchResultsDelegate:self];
	
	if (_searchKeywords != nil) {
		[searchController setActive:YES animated:NO];
		[searchBar setText:_searchKeywords];
	}
	
	[self.tableView setTableHeaderView:searchBar];
	
	[searchBar release];
	
	[self refreshFetchedResults];
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																				target:self 
																				action:@selector(didTapAdd:)];
	
	[self.navigationItem setRightBarButtonItem:addButton];
	
	[addButton release];
}

#pragma mark -
#pragma mark Add Item

- (void)didTapAdd:(id)sender {
	_scratchObjectContext = [[NSManagedObjectContext alloc] init];
	
	[_scratchObjectContext setPersistentStoreCoordinator:[_managedObjectContext persistentStoreCoordinator]];
	
	ItemAddEditViewController *controller = [[ItemAddEditViewController alloc] initWithManagedObjectContext:_scratchObjectContext];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	
	[controller setDelegate:self];
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
	[controller release];
}

- (void)itemAddEditViewController:(ItemAddEditViewController *)controller didCloseWithSave:(BOOL)save {
	if (save) {
		NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
		
		[dnc addObserver:self 
				selector:@selector(scratchObjectContextDidSave:) 
					name:NSManagedObjectContextDidSaveNotification 
				  object:_scratchObjectContext];
		
		NSError *error;
		
		if (![_scratchObjectContext save:&error]) {
			UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" 
																 message:@"Your changes could not be saved, please try again." 
																delegate:nil 
													   cancelButtonTitle:@"OK" 
													   otherButtonTitles:nil];
			
			[errorAlert show];
			[errorAlert release];
		}
		
		[dnc removeObserver:self 
					   name:NSManagedObjectContextDidSaveNotification 
					 object:_scratchObjectContext];
	}
	
	[_scratchObjectContext release], _scratchObjectContext = nil;
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)scratchObjectContextDidSave:(NSNotification *)saveNotification {
	[_managedObjectContext mergeChangesFromContextDidSaveNotification:saveNotification];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (tableView == self.tableView) {
		return [[_fetchedResultsController sections] count];
	} else {
		return [[_searchResultsController sections] count];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.tableView) {
		return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
	} else {
		return [[[_searchResultsController sections] objectAtIndex:section] numberOfObjects];
	}
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forSearchResult:(BOOL)searchResult {
	Item *item;
	
	if (searchResult) {
		item = [_searchResultsController objectAtIndexPath:indexPath];
	} else {
		item = [_fetchedResultsController objectAtIndexPath:indexPath];
	}
	
	[cell.textLabel setText:item.name];
	[cell.detailTextLabel setText:[item.creationTime timeSince]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
									   reuseIdentifier:CellIdentifier] autorelease];
		
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
	
	[self configureCell:cell atIndexPath:indexPath forSearchResult:(tableView != self.tableView)];
	
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Item *item;
	
	if (tableView == self.tableView) {
		item = [_fetchedResultsController objectAtIndexPath:indexPath];
	} else {
		item = [_searchResultsController objectAtIndexPath:indexPath];
	}

	ItemDetailViewController *controller = [[ItemDetailViewController alloc] initWithItem:item];
	
	[self.navigationController pushViewController:controller animated:YES];
	
	[controller release];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Fetched Results Controller

- (void)refreshFetchedResults {
	[_fetchedResultsController release], _fetchedResultsController = nil;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" 
											  inManagedObjectContext:_managedObjectContext];
	
	[fetchRequest setEntity:entity];
	
	NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc] initWithKey:@"creationTime" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:dateSorter, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	_fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																	managedObjectContext:_managedObjectContext 
																	  sectionNameKeyPath:nil 
																			   cacheName:@"Root"];
	
	[_fetchedResultsController setDelegate:self];
	
	[dateSorter release];
	[fetchRequest release];
	[sortDescriptors release];
	
	NSError *error;
	
	if (![_fetchedResultsController performFetch:&error]) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil 
															 message:@"There was an error, please quit and try again." 
															delegate:nil 
												   cancelButtonTitle:@"OK" 
												   otherButtonTitles:nil];
		
		[errorAlert show];
		[errorAlert release];
	}
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	/*if ([[APIManager sharedManager] isSynchronizationInProgress]) {
		return;
	}*/
	
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	/*if ([[APIManager sharedManager] isSynchronizationInProgress]) {
		return;
	}*/
	
    switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] 
						  withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] 
						  withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	/*if ([[APIManager sharedManager] isSynchronizationInProgress]) {
		return;
	}*/
	
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] 
								  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
								  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] 
					atIndexPath:indexPath forSearchResult:NO];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
								  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] 
								  withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	/*if ([[APIManager sharedManager] isSynchronizationInProgress]) {
		return;
	}*/
	
	[self.tableView endUpdates];
}

#pragma mark -
#pragma mark Search Controller

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
	if (_searchKeywords == nil) {
		[_searchKeywords release], _searchKeywords = nil;
		
		_searchKeywords = [controller.searchBar.text retain];
	}
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
	[_searchKeywords release], _searchKeywords = nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	if (searchString == nil) {
		return NO;
	}
	
	[_searchKeywords release], _searchKeywords = nil;
	
	_searchKeywords = [searchString copy];
	
	if (_searchResultsController == nil) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" 
												  inManagedObjectContext:_managedObjectContext];
		
		[fetchRequest setEntity:entity];
		
		NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameSorter, nil];
		
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		_searchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																	   managedObjectContext:_managedObjectContext 
																		 sectionNameKeyPath:nil 
																				  cacheName:nil];
		
		[nameSorter release];
		[fetchRequest release];
		[sortDescriptors release];
	}
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@ || owner.name contains[cd] %@", 
							  _searchKeywords, _searchKeywords];
	
	[_searchResultsController.fetchRequest setPredicate:predicate];
	
	NSError *error;
	
	if (![_searchResultsController performFetch:&error]) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil 
															 message:@"There was an error, please quit and try again." 
															delegate:nil 
												   cancelButtonTitle:@"OK" 
												   otherButtonTitles:nil];
		
		[errorAlert show];
		[errorAlert release];
	}
	
	return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

- (void)dealloc {
	[_searchKeywords release];
	[_managedObjectContext release];
	[_scratchObjectContext release];
	[_searchResultsController release];
	[_fetchedResultsController release];
	
    [super dealloc];
}

@end

//
//  ItemsListViewController.m
//  OKBuyMe
//
//  Created by Taylan Pince on 11-01-22.
//  Copyright 2011 Hippo Foundry. All rights reserved.
//

#import "Item.h"
#import "ItemsListViewController.h"


@interface ItemsListViewController (PrivateMethods)
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
	
	//[searchController release];
	[searchBar release];
	
	[self refreshFetchedResults];
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
	
	//[cell.textLabel setText:entry.shortTitle];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:CellIdentifier] autorelease];
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
	[_searchResultsController release];
	[_fetchedResultsController release];
	
    [super dealloc];
}

@end

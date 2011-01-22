//
//  ItemDetailViewController.m
//  OKBuyMe
//
//  Created by Taylan Pince on 11-01-22.
//  Copyright 2011 Hippo Foundry. All rights reserved.
//

#import "Item.h"
#import "Location.h"
#import "ItemDetailViewController.h"


@interface ItemDetailViewController (PrivateMethods)
- (void)didTapEdit:(id)sender;
@end


@implementation ItemDetailViewController


#pragma mark -
#pragma mark Initialization

- (id)initWithItem:(Item *)item {
	self = [super initWithStyle:UITableViewStyleGrouped];
	
	if (self) {
		_item = [item retain];
	}
	
	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
																				target:self 
																				action:@selector(didTapEdit:)];
	
	[self.navigationItem setRightBarButtonItem:editButton];
	
	[editButton release];
}

#pragma mark -
#pragma mark Add Item

- (void)didTapEdit:(id)sender {
	_scratchObjectContext = [[NSManagedObjectContext alloc] init];
	
	[_scratchObjectContext setPersistentStoreCoordinator:[[_item managedObjectContext] persistentStoreCoordinator]];
	
	Item *item = (Item *)[_scratchObjectContext objectWithID:[_item objectID]];
	ItemAddEditViewController *controller = [[ItemAddEditViewController alloc] initWithItem:item];
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
	[[_item managedObjectContext] mergeChangesFromContextDidSaveNotification:saveNotification];
	
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 1:
			return @"Locations";
			break;
		default:
			return nil;
			break;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 2;
			break;
		case 1:
			return [_item.locations count];
			break;
		default:
			return 0;
			break;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
		case 0: {
			static NSString *titleCellIdentifier = @"titleCell";
			
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
			
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 
											   reuseIdentifier:titleCellIdentifier] autorelease];
				
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			}
			
			switch (indexPath.row) {
				case 0: {
					[cell.textLabel setText:@"Name"];
					[cell.detailTextLabel setText:_item.name];
					
					break;
				}
				case 1: {
					[cell.textLabel setText:@"Notes"];
					[cell.detailTextLabel setText:_item.notes];
					
					break;
				}
			}
			
			return cell;
			break;
		}
		case 1: {
			static NSString *CellIdentifier = @"Cell";
			
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
											   reuseIdentifier:CellIdentifier] autorelease];
			}
			
			Location *location = [[_item.locations allObjects] objectAtIndex:(indexPath.row - 1)];
			
			[cell.textLabel setText:location.name];
			
			return cell;
			break;
		}
		default: {
			return nil;
			break;
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Calculate note height if in section 0
	return tableView.rowHeight;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
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
	[_item release];
	
    [super dealloc];
}

@end

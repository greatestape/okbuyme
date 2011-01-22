//
//  ItemAddEditViewController.m
//  OKBuyMe
//
//  Created by Taylan Pince on 11-01-22.
//  Copyright 2011 Hippo Foundry. All rights reserved.
//

#import "Item.h"
#import "Location.h"
#import "ItemAddEditViewController.h"


@interface ItemAddEditViewController (PrivateMethods)
- (void)didTapSave:(id)sender;
- (void)didTapCancel:(id)sender;
@end


@implementation ItemAddEditViewController

@synthesize delegate;

#pragma mark -
#pragma mark Initialization

- (id)initWithItem:(Item *)item {
	self = [super initWithStyle:UITableViewStyleGrouped];
	
	if (self) {
		_item = [item retain];
		_managedObjectContext = [[item managedObjectContext] retain];
	}
	
	return self;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
	self = [super initWithStyle:UITableViewStyleGrouped];
	
	if (self) {
		_managedObjectContext = [context retain];
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" 
												  inManagedObjectContext:_managedObjectContext];
		
		_item = [[Item alloc] initWithEntity:entity insertIntoManagedObjectContext:_managedObjectContext];
	}
	
	return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if ([[_item objectID] isTemporaryID]) {
		[self setTitle:@"Add Item"];
	} else {
		[self setTitle:@"Edit Item"];
	}

	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
																				target:self 
																				action:@selector(didTapSave:)];
	
	[saveButton setEnabled:NO];
	
	[self.navigationItem setRightBarButtonItem:saveButton];

	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																				  target:self 
																				  action:@selector(didTapCancel:)];
	
	[self.navigationItem setLeftBarButtonItem:cancelButton];
	
	[cancelButton release];
	[saveButton release];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] 
								animated:YES 
						  scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark -
#pragma mark Action callbacks

- (void)didTapSave:(id)sender {
	if ([_item isValid]) {
		[_item setCreationTime:[NSDate date]];
		
		[delegate itemAddEditViewController:self didCloseWithSave:YES];
	}
}

- (void)didTapCancel:(id)sender {
	[delegate itemAddEditViewController:self didCloseWithSave:NO];
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
			return [_item.locations count] + 1;
			break;
		default:
			return 0;
			break;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0: {
			static NSString *editableCellIdentifier = @"editableCell";
			
			EditableTableViewCell *cell = (EditableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:editableCellIdentifier];
			
			if (cell == nil) {
				cell = [[[EditableTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
													 reuseIdentifier:editableCellIdentifier] autorelease];
				
				[cell setDelegate:self];
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
				[cell.textField setFont:[UIFont boldSystemFontOfSize:16.0]];
			}
			
			switch (indexPath.row) {
				case 0: {
					[cell.textField setPlaceholder:@"Name"];
					[cell.textField setText:_item.name];
					
					break;
				}
				case 1: {
					[cell.textField setPlaceholder:@"Notes"];
					[cell.textField setText:_item.notes];
					
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
			
			switch (indexPath.row) {
				case 0: {
					[cell.textLabel setText:@"Add a Location"];
					
					break;
				}
				default: {
					Location *location = [[_item.locations allObjects] objectAtIndex:(indexPath.row - 1)];
					
					[cell.textLabel setText:location.name];
					
					break;
				}
			}
			
			return cell;
			break;
		}
		default: {
			return nil;
			break;
		}
	}
}

#pragma mark -
#pragma mark EditableTableViewCellDelegate callbacks

- (void)editableTableViewCellDidBeginEditing:(EditableTableViewCell *)cell {
	/*NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	
	_activeCell = indexPath.row;*/
}

- (void)editableTableViewCell:(EditableTableViewCell *)cell didChangeValue:(NSString *)value {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	
	switch (indexPath.row) {
		case 0: {
			[_item setName:value];
			
			break;
		}
		case 1: {
			[_item setNotes:value];
			
			break;
		}
	}
	
	[self.navigationItem.rightBarButtonItem setEnabled:[_item isValid]];
}

- (void)editableTableViewCellDidClear:(EditableTableViewCell *)cell {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	
	switch (indexPath.row) {
		case 0: {
			[_item setName:nil];
			
			break;
		}
		case 1: {
			[_item setNotes:nil];
			
			break;
		}
	}
	
	[self.navigationItem.rightBarButtonItem setEnabled:[_item isValid]];
}

- (void)editableTableViewCellDidReturn:(EditableTableViewCell *)cell {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	
	switch (indexPath.row) {
		case 0:
			[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] 
										animated:NO 
								  scrollPosition:UITableViewScrollPositionNone];
			break;
		case 1:
			[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] 
										animated:NO 
								  scrollPosition:UITableViewScrollPositionNone];
			break;
	}
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
	[_managedObjectContext release];
	
    [super dealloc];
}

@end

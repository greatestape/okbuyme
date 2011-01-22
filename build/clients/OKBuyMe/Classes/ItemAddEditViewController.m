//
//  ItemAddEditViewController.m
//  OKBuyMe
//
//  Created by Taylan Pince on 11-01-22.
//  Copyright 2011 Hippo Foundry. All rights reserved.
//

#import "Item.h"
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
	
	[self.navigationItem setRightBarButtonItem:cancelButton];
	
	[cancelButton release];
	[saveButton release];
}

#pragma mark -
#pragma mark Action callbacks

- (void)didTapSave:(id)sender {
	
}

- (void)didTapCancel:(id)sender {
	[delegate itemAddEditViewController:self didCloseWithSave:NO];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 2;
			break;
		case 1:
			return 1;
			break;
		default:
			return 0;
			break;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:CellIdentifier] autorelease];
    }
	
	
	
    return cell;
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

//
//  LoginRegisterViewController.m
//  OKBuyMe
//
//  Created by Taylan Pince on 11-01-22.
//  Copyright 2011 Hippo Foundry. All rights reserved.
//

#import "LoginRegisterViewController.h"


static NSString * const kEmailKey = @"email";
static NSString * const kPasswordKey = @"password";
static NSString * const kNameKey = @"name";
static NSString * const kEmailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";


@interface LoginRegisterViewController (PrivateMethods)
- (void)segmentedControlValueDidChange:(id)sender;
- (void)didTapGoButton:(id)sender;
- (BOOL)isFormValid;
- (void)submitForm;
@end


@implementation LoginRegisterViewController

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	[self setTitle:@"Sign In"];
	
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 54.0)];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Sign In", @"Register", nil]];
	
	[segmentedControl setSelectedSegmentIndex:0];
	[segmentedControl setFrame:CGRectMake(10.0, 10.0, self.tableView.frame.size.width - 20.0, 44.0)];
	[segmentedControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
	
	[headerView addSubview:segmentedControl];
	
	[self.tableView setTableHeaderView:headerView];
	
	[segmentedControl release];
	[headerView release];
	
	UIBarButtonItem *goButton = [[UIBarButtonItem alloc] initWithTitle:@"Go" 
																 style:UIBarButtonItemStyleDone 
																target:self 
																action:@selector(didTapGoButton:)];
	
	[goButton setEnabled:NO];
	
	[self.navigationItem setRightBarButtonItem:goButton];
	
	[goButton release];
	
	_postData = [[NSMutableDictionary alloc] init];
	_currentMode = LoginRegisterViewControllerModeLogin;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] 
								animated:NO 
						  scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark -
#pragma mark Action Callbacks

- (void)didTapGoButton:(id)sender {
	[self submitForm];
}

- (void)segmentedControlValueDidChange:(id)sender {
	UISegmentedControl *control = (UISegmentedControl *)sender;
	
	switch (control.selectedSegmentIndex) {
		case 1: {
			_currentMode = LoginRegisterViewControllerModeRegister;
			
			[self setTitle:@"Register"];
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] 
								  withRowAnimation:UITableViewRowAnimationTop];
			break;
		}
		case 0: {
			_currentMode = LoginRegisterViewControllerModeLogin;
			
			[self setTitle:@"Sign In"];
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] 
								  withRowAnimation:UITableViewRowAnimationBottom];
			break;
		}
	}
	
	[self.navigationItem.rightBarButtonItem setEnabled:[self isFormValid]];
	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] 
								animated:NO 
						  scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (_currentMode) {
		case LoginRegisterViewControllerModeLogin:
			return 2;
			break;
		case LoginRegisterViewControllerModeRegister:
			return 3;
			break;
		default:
			return 0;
			break;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *editableCellIdentifier = @"editableCell";
	
    EditableTableViewCell *cell = (EditableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:editableCellIdentifier];
	
	if (cell == nil) {
		cell = [[[EditableTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
											 reuseIdentifier:editableCellIdentifier] autorelease];
		
		[cell.textField setAutocorrectionType:UITextAutocorrectionTypeNo];
		[cell.textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		[cell.textField setReturnKeyType:UIReturnKeyNext];

		[cell setDelegate:self];
	}
    
	switch (indexPath.row) {
		case 0: {
			[cell.textField setPlaceholder:@"Email"];
			[cell.textField setSecureTextEntry:NO];
			[cell.textField setKeyboardType:UIKeyboardTypeEmailAddress];
			break;
		}
		case 1: {
			[cell.textField setPlaceholder:@"Password"];
			[cell.textField setSecureTextEntry:YES];
			[cell.textField setKeyboardType:UIKeyboardTypeASCIICapable];
			break;
		}
		case 2: {
			[cell.textField setPlaceholder:@"Name"];
			[cell.textField setSecureTextEntry:NO];
			[cell.textField setKeyboardType:UIKeyboardTypeASCIICapable];
			break;
		}
	}
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
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
			[_postData setObject:value forKey:kEmailKey];
			
			break;
		}
		case 1: {
			[_postData setObject:value forKey:kPasswordKey];
			
			break;
		}
		case 2: {
			[_postData setObject:value forKey:kNameKey];
			
			break;
		}
	}
	
	[self.navigationItem.rightBarButtonItem setEnabled:[self isFormValid]];
}

- (void)editableTableViewCellDidClear:(EditableTableViewCell *)cell {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	
	switch (indexPath.row) {
		case 0: {
			[_postData removeObjectForKey:kEmailKey];
			
			break;
		}
		case 1: {
			[_postData removeObjectForKey:kPasswordKey];
			
			break;
		}
		case 2: {
			[_postData removeObjectForKey:kNameKey];
			
			break;
		}
	}
	
	[self.navigationItem.rightBarButtonItem setEnabled:[self isFormValid]];
}

- (void)editableTableViewCellDidReturn:(EditableTableViewCell *)cell {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	
	switch (indexPath.row) {
		case 0: {
			[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] 
										animated:NO 
								  scrollPosition:UITableViewScrollPositionNone];
			break;
		}
		case 1: {
			switch (_currentMode) {
				case LoginRegisterViewControllerModeLogin:
					[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] 
												animated:NO 
										  scrollPosition:UITableViewScrollPositionNone];
					break;
				case LoginRegisterViewControllerModeRegister:
					[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] 
												animated:NO 
										  scrollPosition:UITableViewScrollPositionNone];
					break;
			}
			break;
		}
		case 2: {
			[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] 
										animated:NO 
								  scrollPosition:UITableViewScrollPositionNone];
			break;
		}
	}
}

#pragma mark -
#pragma mark Form methods

- (BOOL)isFormValid {
	NSString *email = [_postData objectForKey:@"email"];
	NSString *password = [_postData objectForKey:@"password"];
	NSString *name = [_postData objectForKey:@"name"];
	
	if (email == nil || [email isEqualToString:@""] || password == nil || [password isEqualToString:@""]) {
		return NO;
	}
	
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kEmailRegex];
	
	if (![emailTest evaluateWithObject:email]) {
		return NO;
	}
	
	if (_currentMode == LoginRegisterViewControllerModeRegister) {
		if (name == nil || [name isEqualToString:@""]) {
			return NO;
		}
	}
	
	return YES;
}

- (void)submitForm {
	if ([self isFormValid]) {
		
	} else {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Validation Error" 
															 message:@"Please make sure all fields are populated." 
															delegate:nil 
												   cancelButtonTitle:@"OK" 
												   otherButtonTitles:nil];
		
		[errorAlert show];
		[errorAlert release];
	}

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
	[_postData release];
	
    [super dealloc];
}

@end

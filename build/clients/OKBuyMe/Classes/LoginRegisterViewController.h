//
//  LoginRegisterViewController.h
//  OKBuyMe
//
//  Created by Taylan Pince on 11-01-22.
//  Copyright 2011 Hippo Foundry. All rights reserved.
//

#import "EditableTableViewCell.h"


typedef enum {
	LoginRegisterViewControllerModeLogin,
	LoginRegisterViewControllerModeRegister,
} LoginRegisterViewControllerMode;


@interface LoginRegisterViewController : UITableViewController <EditableTableViewCellDelegate> {
@private
	NSMutableDictionary *_postData;
	LoginRegisterViewControllerMode _currentMode;
}

@end

//
//  EditableTableViewCell.h
//  Atomic
//
//  Created by Taylan Pince on 10-06-02.
//  Copyright 2010 Hippo Foundry. All rights reserved.
//


@protocol EditableTableViewCellDelegate;

@interface EditableTableViewCell : UITableViewCell <UITextFieldDelegate> {
@private
	UITextField *_textField;
	
	id <EditableTableViewCellDelegate> delegate;
}

@property (nonatomic, retain, readonly) UITextField *textField;
@property (nonatomic, assign) id <EditableTableViewCellDelegate> delegate;

@end


@protocol EditableTableViewCellDelegate <NSObject>
@optional
- (void)editableTableViewCell:(EditableTableViewCell *)cell didChangeValue:(NSString *)value;
- (void)editableTableViewCellDidBeginEditing:(EditableTableViewCell *)cell;
- (void)editableTableViewCellDidEndEditing:(EditableTableViewCell *)cell;
- (void)editableTableViewCellDidReturn:(EditableTableViewCell *)cell;
- (void)editableTableViewCellDidClear:(EditableTableViewCell *)cell;
@end

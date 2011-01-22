//
//  EditableTableViewCell.m
//  Atomic
//
//  Created by Taylan Pince on 10-06-02.
//  Copyright 2010 Hippo Foundry. All rights reserved.
//

#import "EditableTableViewCell.h"


@implementation EditableTableViewCell

@synthesize delegate;
@synthesize textField = _textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _textField = [[UITextField alloc] initWithFrame:CGRectInset(self.contentView.bounds, 10.0, 4.0)];
		
		[_textField setDelegate:self];
		[_textField setFont:[UIFont systemFontOfSize:16.0]];
		[_textField setTextColor:[UIColor blackColor]];
		[_textField setAutocorrectionType:UITextAutocorrectionTypeNo];
		[_textField setEnablesReturnKeyAutomatically:YES];
		[_textField setBackgroundColor:self.contentView.backgroundColor];
		[_textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
		[_textField setReturnKeyType:UIReturnKeyNext];
		[_textField setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
		
        [self.contentView addSubview:_textField];
    }
	
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	if (selected) {
		[_textField becomeFirstResponder];
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)field {
	if ([delegate respondsToSelector:@selector(editableTableViewCellDidBeginEditing:)]) {
		[delegate editableTableViewCellDidBeginEditing:self];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)field {
	if ([delegate respondsToSelector:@selector(editableTableViewCellDidEndEditing:)]) {
		[delegate editableTableViewCellDidEndEditing:self];
	}
}

- (BOOL)textFieldShouldClear:(UITextField *)field {
	if ([delegate respondsToSelector:@selector(editableTableViewCellDidClear:)]) {
		[delegate editableTableViewCellDidClear:self];
	}

	return YES;
}

- (BOOL)textField:(UITextField *)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSMutableString *replacedString = [NSMutableString stringWithString:field.text];
	
	[replacedString replaceCharactersInRange:range withString:string];
	
	if ([delegate respondsToSelector:@selector(editableTableViewCell:didChangeValue:)]) {
		[delegate editableTableViewCell:self didChangeValue:replacedString];
	}
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)field {
	if ([delegate respondsToSelector:@selector(editableTableViewCellDidReturn:)]) {
		[delegate editableTableViewCellDidReturn:self];
	}
	
	return YES;
}

- (void)dealloc {
	[_textField release];

    [super dealloc];
}

@end

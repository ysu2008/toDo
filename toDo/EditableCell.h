//
//  EditableCell.h
//  toDo
//
//  Created by Yang Su on 1/26/14.
//  Copyright (c) 2014 Yang Su. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditableCellDelegate;

@interface EditableCell : UITableViewCell<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *todoString;
@property (nonatomic, readwrite, strong) id<EditableCellDelegate> delegate;

@end

@protocol EditableCellDelegate

- (void)cellWasEdited:(EditableCell *)cell;

@end

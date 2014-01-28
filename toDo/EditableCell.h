//
//  EditableCell.h
//  toDo
//
//  Created by Yang Su on 1/26/14.
//  Copyright (c) 2014 Yang Su. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditableCellDelegate;

@interface EditableCell : UITableViewCell<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *todoString;
@property (nonatomic, readwrite, strong) id<EditableCellDelegate> delegate;

@end

@protocol EditableCellDelegate

- (void)cellTextChanged:(EditableCell *)cell;

@end

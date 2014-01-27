//
//  ToDoViewController.m
//  toDo
//
//  Created by Yang Su on 1/26/14.
//  Copyright (c) 2014 Yang Su. All rights reserved.
//

#import "ToDoViewController.h"

@interface ToDoViewController ()

@property (nonatomic, readwrite, strong) NSMutableArray *todoStrings;

- (IBAction)cellWasEdited:(id)sender;
- (IBAction)newTodoButtonPressed:(id)sender;
- (IBAction)onTap:(id)sender;

@end

@implementation ToDoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]){
        //stuff
        [self setup];
    }
    return self;
}

- (void)setup {
    _todoStrings = [NSMutableArray array];
}

# pragma mark - table view methods
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_todoStrings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditableCell"];
    
    [cell setDelegate:self];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newTodoButtonPressed:(id)sender {
    [self.todoStrings addObject:[NSString stringWithFormat:@""]];
    [self.tableView reloadData];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - editable cell delegate method

- (void)cellWasEdited:(EditableCell *)cell {
    [self.todoStrings replaceObjectAtIndex:[[self.tableView indexPathForCell:cell] row] withObject:cell.todoString.text];
}
@end

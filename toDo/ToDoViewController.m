//
//  ToDoViewController.m
//  toDo
//
//  Created by Yang Su on 1/26/14.
//  Copyright (c) 2014 Yang Su. All rights reserved.
//

#import "ToDoViewController.h"

#define todoListKey @"todoListStrings"

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
    self.title = @"To Do List";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _todoStrings = [NSMutableArray arrayWithArray:[defaults objectForKey:todoListKey]];
}

- (void)persistToDoList {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.todoStrings forKey:todoListKey];
}

# pragma mark - table view methods
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_todoStrings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditableCell"];
    [cell.todoString setText:[self.todoStrings objectAtIndex:[indexPath row]]];
    [cell setDelegate:self];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.todoStrings removeObjectAtIndex:[indexPath row]];
    [self persistToDoList];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
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
    [self.todoStrings insertObject:[NSString stringWithFormat:@""] atIndex:0];
    [self persistToDoList];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    //[self.tableView reloadData];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - editable cell delegate method

- (void)cellWasEdited:(EditableCell *)cell {
    [self.todoStrings replaceObjectAtIndex:[[self.tableView indexPathForCell:cell] row] withObject:cell.todoString.text];
    [self persistToDoList];
}
@end

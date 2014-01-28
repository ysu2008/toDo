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
@property (nonatomic, readwrite, assign) CGFloat test;

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
    
    //set up navigation bar touch
    UITapGestureRecognizer* tapRecon = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(navigationBarTap)];
    tapRecon.numberOfTapsRequired = 1;
    [self.navigationController.navigationBar addGestureRecognizer:tapRecon];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _todoStrings = [NSMutableArray arrayWithArray:[defaults objectForKey:todoListKey]];
    self.test = 0;
}

- (void)navigationBarTap {
    [self.view endEditing:YES];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self.todoStrings removeObjectAtIndex:[indexPath row]];
        [self persistToDoList];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (CGFloat)rowHeightForString:(NSString *)string {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:20]};
    CGRect sizeRect = [string boundingRectWithSize:CGSizeMake(280.0f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
    
    return sizeRect.size.height + 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *myString = [self.todoStrings objectAtIndex:indexPath.row];
    self.test = [self rowHeightForString:myString];
    return self.test;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *temp = [self.todoStrings objectAtIndex:sourceIndexPath.row];
    [self.todoStrings replaceObjectAtIndex:sourceIndexPath.row withObject:[self.todoStrings objectAtIndex:destinationIndexPath.row]];
    [self.todoStrings replaceObjectAtIndex:destinationIndexPath.row withObject:temp];
    [self persistToDoList];
}

- (void)editButton:(id)sender
{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [self.tableView setEditing:NO animated:NO];
        [self.tableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style: UIBarButtonItemStyleBordered target:self action:@selector(editButton:)];
    [self.navigationItem setLeftBarButtonItem:editButton];
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
}

- (void)cellTextChanged:(EditableCell *)cell {
    [self.todoStrings replaceObjectAtIndex:[[self.tableView indexPathForCell:cell] row] withObject:cell.todoString.text];
    [self persistToDoList];
    self.test = [self rowHeightForString:cell.todoString.text];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
@end

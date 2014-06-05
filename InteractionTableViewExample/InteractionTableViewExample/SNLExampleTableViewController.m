#import "SNLExampleTableViewController.h"
#import "SNLInteractionTableView.h"
#import "SNLExampleTableViewCell.h"

@interface SNLExampleTableViewController ()

@end


@implementation SNLExampleTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.itemList = [[NSMutableArray alloc] initWithObjects:@"Test 1", @"Test 2", @"Test 3", @"Test 4", @"Test 5", @"Test 6", @"Test 7", @"Test 8", @"Test 9", @"Test 10", nil];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to disable toolbar.
    // [(SNInteractionTableView *)self.tableView setToolbarEnabled:NO];
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.itemList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SNLExampleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // change colors, otherwise they are guessed by colors from storyboard
    // can also be set in your custom tableViewCell, see SNIETableViewCell.m
    /*
    [cell setColorBackground:[UIColor grayColor]];
    [cell setColorContainer:[UIColor whiteColor]];
    [cell setColorSelected:[UIColor greenColor]];
    [cell setColorToolbarBarTint:[UIColor blueColor]];
    [cell setColorToolbarTint:[UIColor greenColor]];
    [cell setColorIndicator:[UIColor redColor]];
    [cell setColorIndicatorSuccess:[UIColor greenColor]];
    */
    
    // setup custom separator on top and/or bottom of cell
    cell.colorCustomSeparatorTop = [UIColor whiteColor];
    [cell setColorContainer:[UIColor lightTextColor]];
    cell.colorCustomSeparatorBottom = [UIColor grayColor];
    
    
    // setup pan gestures
    // can also be set in your custom tableViewCell, see SNIETableViewCell.m
    [cell setIndicatorImageLeft:[UIImage imageNamed:@"indicator"]];
    [cell setIndicatorImageRight:[UIImage imageNamed:@"indicator"]];
    [cell setIndicatorImageSuccessLeft:[UIImage imageNamed:@"indicator_success"]];
    [cell setIndicatorImageSuccessRight:[UIImage imageNamed:@"indicator_success"]];
    [cell setPanSuccesAnimationLeft:SNICellPanSuccessAnimationBounce];
    [cell setPanSuccesAnimationRight:SNICellPanSuccessAnimationOut];
    
    // setup pan gesture callback methods
    // has to be set here if it needs to call a controller method, otherwise it can be set in the cell initialization as well
	
	SNLExampleTableViewController * __weak weakSelf = self;
    [cell setPanSuccessActionLeft:^(SNLExampleTableViewCell *cell){
        [weakSelf panSuccessActionLeftOnCell:cell];
    }];
    [cell setPanSuccessActionRight:^(SNLExampleTableViewCell *cell){
        [weakSelf panSuccessActionRightOnCell:cell];
    }];
    
    // setup toolbar, if toolbar is enabled (default), to disable see viewDidLoad.
    // has to be set here if it needs to call a controller method, otherwise it can be set in the cell initialization as well
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *a = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(buttonA:)];
    [cell setToolbarButtons: [NSArray arrayWithObjects:flexibleItem, a, flexibleItem, nil]];
    

    
    // configure content of your cell
    [cell.label setText:[self.itemList objectAtIndex:indexPath.row]];
    
    return cell;
}



#pragma mark - SNLInteractionTableView Reorder

- (void)startedReorderAtIndexPath:(NSIndexPath *)indexPath {
	// additional setup when reordering starts
	NSLog(@"Reordering started");
}

// Update your data source when a cell is draged to a new position. This method is called every time 2 cells switch positions.
- (void)moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	// update DataSource when cells are switched
    NSLog(@"Switched Cells");
	
    /*
     * Reorder example:
     */
    id object = [self.itemList objectAtIndex:fromIndexPath.row];
    [self.itemList removeObjectAtIndex:fromIndexPath.row];
    [self.itemList insertObject:object atIndex:toIndexPath.row];
}

- (void)finishedReorderAtIndexPath:(NSIndexPath *)indexPath; {
	// additional cleanup when reordering ended
    NSLog(@"Reordering ended");
}



#pragma mark - Interaction

- (void)buttonA:(id)sender {
    NSLog(@"Button");
}

- (void)panSuccessActionLeftOnCell:(SNLExampleTableViewCell *)cell {
    NSLog(@"Left");
}

- (void)panSuccessActionRightOnCell:(SNLExampleTableViewCell *)cell {
    NSLog(@"Right");
    [self performSegueWithIdentifier:@"detail" sender:self];
}


@end

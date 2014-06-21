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

	self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Uncomment the following line to disable the toolbar.
    // [(SNLInteractionTableView *)self.tableView setToolbarEnabled:NO];
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
	
	// set cells delegate to connect swipe action method
	cell.delegate = self;
	
	// initialize colors, images and toolbar in your SNLInteractionCell subclass
	// see SNLExampleTableViewCell.m
	
    // configure example content
    [cell.label setText:[self.itemList objectAtIndex:indexPath.row]];
    
    return cell;
}

/* Uncomment to disable reordering
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
*/



#pragma mark - SNLInteractionTableView delegate - Reorder

- (void)startedReorderAtIndexPath:(NSIndexPath *)indexPath {
	// additional setup when reordering starts
	NSLog(@"Reordering started");
}

// Update your data source when a cell is draged to a new position. This method is called every time 2 cells switch positions.
- (void)moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	// update DataSource when cells are switched
    NSLog(@"Switched Cells");
	
    // Reorder example:
    id object = [self.itemList objectAtIndex:fromIndexPath.row];
    [self.itemList removeObjectAtIndex:fromIndexPath.row];
    [self.itemList insertObject:object atIndex:toIndexPath.row];
}

- (void)finishedReorderAtIndexPath:(NSIndexPath *)indexPath; {
	// additional cleanup when reordering ended
    NSLog(@"Reordering ended");
}



#pragma mark - SNLInteractionCell delegate

- (void)swipeAction:(SNLSwipeSide)swipeSide onCell:(SNLExampleTableViewCell *)cell {
	// implement actions on successfull swipe gesture
	if (swipeSide == SNLSwipeSideLeft) {
		NSLog(@"Left on '%@'", cell.label.text);
	}
	else if (swipeSide == SNLSwipeSideRight) {
		NSLog(@"Right on '%@'", cell.label.text);
		[self performSegueWithIdentifier:@"detail" sender:self];
	}
}

- (void)buttonActionWithTag:(NSInteger)tag onCell:(SNLExampleTableViewCell *)cell {
	if (tag == 1) {
		NSLog(@"First Button on '%@'", cell.label.text);
	}
	else if (tag == 2) {
		NSLog(@"Second Button on '%@'", cell.label.text);
	}
}


@end

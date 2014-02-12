//
//  SNIETableViewController.m
//  InteractionTableViewExample
//
//  Created by Simon Nickel on 06.02.14.
//  Copyright (c) 2014 simonnickel. All rights reserved.
//

#import "SNIETableViewController.h"
#import "SNInteractionTableView.h"
#import "SNIETableViewCell.h"

@interface SNIETableViewController ()

@end


@implementation SNIETableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.itemList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    SNIETableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
    if (cell == nil) {
        cell = [[SNIETableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // change colors, otherwise they are guessed by colors from storyboard
    /*
    [cell setColorBackground:[UIColor grayColor]];
    [cell setColorContainer:[UIColor whiteColor]];
    [cell setColorSelected:[UIColor greenColor]];
    [cell setColorToolbarBarTint:[UIColor blueColor]];
    [cell setColorToolbarTint:[UIColor greenColor]];
    [cell setColorIndicator:[UIColor redColor]];
    [cell setColorIndicatorSuccess:[UIColor greenColor]];
    */
    
    // setup toolbar, if toolbar is enabled (default), to disable see viewDidLoad.
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *a = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(buttonA:)];
    [cell setToolbarButtons: [NSArray arrayWithObjects:flexibleItem, a, flexibleItem, nil]];
    
    // setup pan gestures
    [cell setIndicatorImageLeft:[UIImage imageNamed:@"indicator"]];
    [cell setIndicatorImageRight:[UIImage imageNamed:@"indicator"]];
    [cell setIndicatorImageSuccessLeft:[UIImage imageNamed:@"indicator_success"]];
    [cell setIndicatorImageSuccessRight:[UIImage imageNamed:@"indicator_success"]];
    [cell setPanSuccesAnimationLeft:SNICellPanSuccessAnimationBounce];
    [cell setPanSuccessActionLeft:^(SNIETableViewCell *cell){
        [self panSuccessActionLeftOnCell:cell];
    }];
    
    [cell setPanSuccesAnimationRight:SNICellPanSuccessAnimationOut];
    [cell setPanSuccessActionRight:^(SNIETableViewCell *cell){
        [self panSuccessActionRightOnCell:cell];
    }];
    
    // configure content of your cell
    [cell.label setText:[self.itemList objectAtIndex:indexPath.row]];
    
    return cell;
}


/*
 *  Reorder functions
 */

// Update your data source when a cell is draged to a new position. This method is called every time 2 cells switch positions.
- (void)moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    /*
     * Reorder example:
     */
    id object = [self.itemList objectAtIndex:fromIndexPath.row];
    [self.itemList removeObjectAtIndex:fromIndexPath.row];
    [self.itemList insertObject:object atIndex:toIndexPath.row];
}

/*  Uncomment this function if you need additional setup when reordering starts.
- (void)startedReorderAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Reordering started");
}
*/
/*  Uncomment this function if you need additional cleanup when reordering ended.
 - (void)finishedReorderAtIndexPath:(NSIndexPath *)indexPath; {
    NSLog(@"Reordering ended");
 }
*/




- (void)buttonA:(id)sender {
    NSLog(@"A");
}

- (void)panSuccessActionLeftOnCell:(SNIETableViewCell *)cell {
    NSLog(@"left");
}
- (void)panSuccessActionRightOnCell:(SNIETableViewCell *)cell {
    NSLog(@"right");
    [self performSegueWithIdentifier:@"detail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender {
    /*
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self.activeCell];
    
    if ([[segue identifier] isEqualToString:@"detail"]) {
        ItemDetailViewController *detailVC = [segue destinationViewController];
        
        id object = [self.itemList objectAtIndex:indexPath.row];
        
        [detailVC setObject:object];
    }
     */
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"detail" ]) {
        return YES;
    }
    return NO;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end

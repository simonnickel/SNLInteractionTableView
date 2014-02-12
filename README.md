SNInteractionTableView
======================

TableViewController, TableView and TableViewCell for more interaction: swipe, selection, reorder. Using AutoLayout and UIDynamics.

Takes your UITableViewCell layouted in Storyboard and extends it with:

* Swipe - with Bounce or Slide out animation
* Select - with toolbar
* Reorder - by press and hold

Reordering is inspired/rebuild/copied by [BVReorderTableView](https://github.com/bvogelzang/BVReorderTableView) by Ben Vogelzang. If you just want reordering: use his code!


![Example](https://github.com/simonnickel/SNInteractionTableView/blob/master/example.gif?raw=true)


## Usage

See example project in InteractionTableViewExample for more details.

1. Copy SNInteractionTableView folder into your project (Controller, TableView and TableViewCell).
2. Change classes of Controller, TableView and TableViewCell in your Storyboard to related SNInteraction-class or make your existing custom classes subclasses of related SNInteraction-class.
3. Configure cell in tableView:cellForRowAtIndexPath: of your TableViewController.
4. Add moveRowFromIndexPath:toIndexPath: to your TableViewController to update your data store when reordering.


```objective-c
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
}


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

```

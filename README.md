SNInteractionTableView
======================

TableViewController, TableView and TableViewCell for more interaction: swipe, selection, reorder. Using AutoLayout and UIDynamics.

Takes your UITableViewCell layouted in Storyboard and extends it with:

* Swipe - with Bounce or Slide out animation
* Select - with toolbar
* Reorder - by press and hold

You can use this code completely free without any restrictions for whatever you want. Even to print it, if you really want. If you do so (using, not printing) it would be great to hear from you. Just tweet [@simonnickel](https://twitter.com/simonnickel) or send me an email (see profile).

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

```

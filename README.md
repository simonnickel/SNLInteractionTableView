SNInteractionTableView
======================

SNInteractionTableView provides a complete tableView (controller, tableView and cell) to easily add more interaction  to your tableView. It uses AutoLayout and extends an existing tableViewCell layout from your Storyboard with the following functionality:

* Swipe - with bounce or fade-out animation
* Selection - with toolbar
* Reordering - by long press

This repo contains the SNInteractionTableView and an example project to see how you can use it. For a detailed description see this <a href="http://simonnickel.de/devlog/projects/sninteractiontableview/how-to-use" title="How to use">instruction</a> or the usage section below.

You can use this code completely free without any restrictions for whatever you want. Even to print it, if you really want. If you do so (using, not printing) it would be great to hear from you. Just tweet [@simonnickel](https://twitter.com/simonnickel) or send me an email (see profile).

The reordering functionality is inspired/rebuild/copied by [BVReorderTableView](https://github.com/bvogelzang/BVReorderTableView) by Ben Vogelzang. If you just want reordering: use his code!


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
    [cell setPanSuccessActionLeft:^(SNIETableViewCell *cell){
        [self panSuccessActionLeftOnCell:cell];
    }];
    [cell setPanSuccessActionRight:^(SNIETableViewCell *cell){
        [self panSuccessActionRightOnCell:cell];
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

```

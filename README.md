SNInteractionTableView
======================

SNInteractionTableView provides a complete tableView stack (controller, tableView and cell) to easily add more interaction to your tableView. It uses AutoLayout and extends an existing tableViewCell layout from your Storyboard with the following functionality:

* Swipe Action - left and right, with bounce, slide-back or slide-out animation
* Selection - with toolbar
* Reordering - by long press

This repo contains the SNInteractionTableView and an example project to see how you can use it. For a detailed description see this <a href="http://simonnickel.de/devlog/projects/sninteractiontableview/how-to-use" title="How to use">instruction</a> or the usage section below.

You can use this code completely free without any restrictions for whatever you want. Even to print it, if you really want. If you do so (using, not printing) it would be great to hear from you. Just tweet [@simonnickel](https://twitter.com/simonnickel) or send me an email (see profile).

The reordering functionality is inspired/rebuild/copied by [BVReorderTableView](https://github.com/bvogelzang/BVReorderTableView) by Ben Vogelzang. If you just want reordering: use his code!


![Example](https://github.com/simonnickel/SNInteractionTableView/blob/master/example.gif?raw=true)


## Usage

See example project in InteractionTableViewExample for more details.

1. Copy SNInteractionTableView directory into your project (Controller, TableView and TableViewCell).
2. Change classes of Controller, TableView and TableViewCell in your Storyboard to related SNInteraction-class or make your existing custom classes subclasses of related SNInteraction-class.
3. Set cell delegate in tableView:cellForRowAtIndexPath: of your TableViewController.
4. Configure your TableViewController to support reordering and cell actions.
5. Configure cell in your SNLInteractionCell subclass.


### 3. + 4. Configure TableViewController
```objective-c
#pragma mark - Table view data source

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
```

### 5. Cell initialization
```objective-c
    /*
    // to override default/storyboard colors use:
    self.colorBackground = [UIColor grayColor];
    self.colorContainer = [UIColor whiteColor];
    self.colorSelected = [UIColor greenColor];
    self.colorToolbarBarTint = [UIColor blueColor];
    self.colorToolbarTint = [UIColor greenColor];
    self.colorIndicator = [UIColor redColor];
    self.colorIndicatorSuccess = [UIColor greenColor];
    self.colorCustomSeparatorTop = [UIColor whiteColor];
    self.colorCustomSeparatorBottom = [UIColor grayColor];
    */
    
    
    // configure left and right swipe indicator
    [self configureSwipeOn:SNLSwipeSideLeft
       withCancelAnimation:SNLSwipeAnimationDefault
       andSuccessAnimation:SNLSwipeAnimationSlideBack
                  andImage:[UIImage imageNamed:@"indicator"]
         andImageOnSuccess:[UIImage imageNamed:@"indicator_success"]];
    
    [self configureSwipeOn:SNLSwipeSideRight
       withCancelAnimation:SNLSwipeAnimationDefault
       andSuccessAnimation:SNLSwipeAnimationSlideOut
                  andImage:[UIImage imageNamed:@"indicator"]
         andImageOnSuccess:[UIImage imageNamed:@"indicator_success"]];

    
    // setup toolbar, if toolbar is enabled (default)
    UIBarButtonItem *buttonA = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(buttonPressed:)];
    buttonA.tag = 1;
    
    UIBarButtonItem *buttonB = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(buttonPressed:)];
    buttonB.tag = 2;
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [self setToolbarButtons: [NSArray arrayWithObjects:flexibleItem, buttonA, flexibleItem, buttonB, flexibleItem, nil]];
```

//
//  SNInteractionTableViewController.h
//  InteractionTableViewExample
//
//  Created by Simon Nickel on 08.02.14.
//  Copyright (c) 2014 simonnickel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SNInteractionTableViewDelegate <UITableViewDelegate>

- (void)startedReorderAtIndexPath:(NSIndexPath *)indexPath;

- (void)moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

- (void)finishedReorderAtIndexPath:(NSIndexPath *)indexPath;

- (void)toggleCellVisibility:(BOOL)visibility AtIndexPath:(NSIndexPath *)indexPath;

@end


@interface SNInteractionTableViewController : UITableViewController <SNInteractionTableViewDelegate, UITableViewDelegate, UITableViewDataSource>

@end

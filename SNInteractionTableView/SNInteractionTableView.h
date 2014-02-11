//
//  SNInteractionTableView.h
//  InteractionTableViewExample
//
//  Created by Simon Nickel on 06.02.14.
//  Copyright (c) 2014 simonnickel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNInteractionTableViewController.h"

@interface SNInteractionTableView : UITableView

@property (nonatomic, assign) id <SNInteractionTableViewDelegate> delegate;
@property (nonatomic) BOOL toolbarEnabled;

- (void)deselectSelectedRow;

@end

//
//  SNInteractionTableViewController.m
//  InteractionTableViewExample
//
//  Created by Simon Nickel on 08.02.14.
//  Copyright (c) 2014 simonnickel. All rights reserved.
//

#import "SNInteractionTableViewController.h"
#import "SNInteractionTableView.h"
#import "SNInteractionCell.h"

@interface SNInteractionTableViewController ()

@end

@implementation SNInteractionTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    for (NSIndexPath *indexPath in [self.tableView indexPathsForVisibleRows]) {
        SNInteractionCell *cell = (SNInteractionCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell prepareForReuse];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView indexPathForSelectedRow] && indexPath.row == [tableView indexPathForSelectedRow].row) {
        return self.tableView.rowHeight + actionPanelHeight;
    }
    else
        return self.tableView.rowHeight;
}

/*
 *  Toggle selection and resize cell.
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}
- (NSIndexPath *)tableView:(SNInteractionTableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SNInteractionCell *cell = (SNInteractionCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell isSelected]) {
        [tableView deselectSelectedRow];
        return nil;
    }
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}


/*
 *  Editing functions
 */
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  UITableViewCellEditingStyleNone;
}
-(BOOL)tableView:(UITableView*)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath*)indexPath {
    return NO;
}


/*
 * Reorder functions
 */
- (void)toggleCellVisibility:(BOOL)visibility AtIndexPath:(NSIndexPath *)indexPath {
    SNInteractionCell *cell = (SNInteractionCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell toggleVisibility:visibility];
}
- (void)moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {

}

 - (void)startedReorderAtIndexPath:(NSIndexPath *)indexPath {

 }

 - (void)finishedReorderAtIndexPath:(NSIndexPath *)indexPath; {

 }


@end

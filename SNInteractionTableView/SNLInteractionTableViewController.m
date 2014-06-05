//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "SNLInteractionTableViewController.h"
#import "SNLInteractionTableView.h"
#import "SNLInteractionCell.h"

@interface SNLInteractionTableViewController ()

@end

@implementation SNLInteractionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to disable toolbar.
    [(SNLInteractionTableView *)self.tableView setToolbarEnabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    for (NSIndexPath *indexPath in [self.tableView indexPathsForVisibleRows]) {
        SNLInteractionCell *cell = (SNLInteractionCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell prepareForReuse];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(SNLInteractionTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView toolbarEnabled] &&
        [tableView indexPathForSelectedRow] &&
        indexPath.row == [tableView indexPathForSelectedRow].row
    ) {
        return self.tableView.rowHeight + toolbarHeight;
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
- (NSIndexPath *)tableView:(SNLInteractionTableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SNLInteractionCell *cell = (SNLInteractionCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isSelected]) {
        [tableView deselectSelectedRow];
        return nil;
    }
    else if (tableView.toolbarEnabled) {
        cell.hasToolbar = YES;
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
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
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
- (void)toggleCellVisibility:(BOOL)visibility forIndexPath:(NSIndexPath *)indexPath {
    SNLInteractionCell *cell = (SNLInteractionCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell toggleVisibility:visibility];
}
- (void)moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {

}

 - (void)startedReorderAtIndexPath:(NSIndexPath *)indexPath {

 }

 - (void)finishedReorderAtIndexPath:(NSIndexPath *)indexPath; {

 }


@end

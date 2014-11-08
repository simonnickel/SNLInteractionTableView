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

typedef NS_ENUM(NSInteger, SNLCustomSeparatorPosition){
	SNLCustomSeparatorPositionTop,
    SNLCustomSeparatorPositionBottom
};


@interface SNLInteractionTableViewController ()

@end

@implementation SNLInteractionTableViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    for (NSIndexPath *indexPath in [self.tableView indexPathsForVisibleRows]) {
        SNLInteractionCell *cell = (SNLInteractionCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell prepareForReuse];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
	if (self.clearsSelectionOnViewWillAppear) {
		[((SNLInteractionTableView *)self.tableView) deselectSelectedRow];
	}
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(SNLInteractionTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView toolbarEnabled] &&
        [tableView indexPathForSelectedRow] &&
        indexPath.row == [tableView indexPathForSelectedRow].row
    ) {
        return self.tableView.rowHeight + SNLToolbarHeight;
    }
    else
        return self.tableView.rowHeight;
}

- (void)tableView:(SNLInteractionTableView *)tableView willDisplayCell:(SNLInteractionCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
		
	// custom separator
	if (tableView.customSeparatorEnabled) {
		[self setupCustomSeparator:SNLCustomSeparatorPositionTop forView:cell];
		[self setupCustomSeparator:SNLCustomSeparatorPositionBottom forView:cell];
	}
}

- (void)setupCustomSeparator:(SNLCustomSeparatorPosition)position forView:(SNLInteractionCell *)cell {
	if ([cell isKindOfClass:[SNLInteractionCell class]]) {
		UIView *view = [[UIView alloc] init];
		[cell addSubview:view];
		[view setTranslatesAutoresizingMaskIntoConstraints:NO];
		
		NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];
		NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.f];
		NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeLeft multiplier:1.0f constant:self.tableView.separatorInset.left];
		NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRight multiplier:1.0f constant: - self.tableView.separatorInset.right];
		NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant: 0.5f];
		
		[cell addConstraints:@[right, left, height]];
		
		if (position == SNLCustomSeparatorPositionTop) {
			[cell addConstraint:top];
			cell.customSeparatorTop = view;
		}
		else if (position == SNLCustomSeparatorPositionBottom) {
			[cell addConstraint:bottom];
			cell.customSeparatorBottom = view;
		}
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (NSIndexPath *)tableView:(SNLInteractionTableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SNLInteractionCell *cell = (SNLInteractionCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isSelected]) {
		[tableView deselectSelectedRow];
        return nil;
    }

    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}


#pragma mark - Table view data source - Editing

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView*)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath*)indexPath {
    return NO;
}


#pragma mark - SNLInteractionTableView delegate - Reorder

- (void)startedReorderAtIndexPath:(NSIndexPath *)indexPath {
	// implement additional setup when reordering starts in subclass
}

- (void)moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	// update your DataSource when cells are switched in subclass
}

 - (void)finishedReorderAtIndexPath:(NSIndexPath *)indexPath; {
	// implement additional cleanup when reordering ended in subclass
}


#pragma mark - SNLInteractionCell delegate

- (void)swipeAction:(SNLSwipeSide)swipeAction onCell:(SNLInteractionCell *)cell {
	// implement action for swipeAction == SNLSwipeSideLeft/SNLSwipeSideLeft in subclass
	/*
	if (swipeAction == SNLSwipeSideLeft) {
	
	}
	else if (swipeAction == SNLSwipeSideRight) {
	
	}
	*/
}

- (void)buttonActionWithTag:(NSInteger)tag onCell:(SNLInteractionCell *)cell {
	// implement action for buttonTap in subclass
}


@end

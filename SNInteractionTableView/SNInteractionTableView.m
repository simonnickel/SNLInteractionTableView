//
//  SNInteractionTableView.m
//  InteractionTableViewExample
//
//  Created by Simon Nickel on 06.02.14.
//  Copyright (c) 2014 simonnickel. All rights reserved.
//

#import "SNInteractionTableView.h"

@implementation SNInteractionTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setAllowsMultipleSelection:NO];
        [self setAllowsSelection:YES];
    }
    return self;
}

/*
 * Selection Functions
 */
- (void)deselectSelectedRow {
    NSIndexPath *selected = [self indexPathForSelectedRow];
    if (selected) {
        [self.delegate tableView:self willDeselectRowAtIndexPath:selected];
        [self deselectRowAtIndexPath:selected animated:YES];
        [self.delegate tableView:self didDeselectRowAtIndexPath:selected];
    }
}


@end

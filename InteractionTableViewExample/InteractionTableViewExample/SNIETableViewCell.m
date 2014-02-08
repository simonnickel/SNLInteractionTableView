//
//  SNIETableViewCell.m
//  InteractionTableViewExample
//
//  Created by Simon Nickel on 06.02.14.
//  Copyright (c) 2014 simonnickel. All rights reserved.
//

#import "SNIETableViewCell.h"

@implementation SNIETableViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    //self.colorBackground = self.backgroundColor;
    //self.colorContainer = self.contentView.backgroundColor;
    //self.colorContainerSelected = self.contentView.backgroundColor;
    
    [super layoutSubviews];    
    
    [self setBackgroundColor:[UIColor grayColor]];
    [self setColorContainer:[UIColor whiteColor]];
    [self setColorContainerSelected:[UIColor greenColor]];
//    [self.container setBackgroundColor:[UIColor whiteColor]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end

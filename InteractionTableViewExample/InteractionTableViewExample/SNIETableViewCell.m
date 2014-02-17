//
//  SNIETableViewCell.m
//  InteractionTableViewExample
//
//  Created by Simon Nickel on 06.02.14.
//  Copyright (c) 2014 simonnickel. All rights reserved.
//

#import "SNIETableViewCell.h"

@implementation SNIETableViewCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize {
    // change colors, otherwise they are guessed by colors from storyboard
    /*
    [self setColorBackground:[UIColor grayColor]];
    [self setColorContainer:[UIColor whiteColor]];
    [self setColorSelected:[UIColor greenColor]];
    [self setColorToolbarBarTint:[UIColor blueColor]];
    [self setColorToolbarTint:[UIColor greenColor]];
    [self setColorIndicator:[UIColor redColor]];
    [self setColorIndicatorSuccess:[UIColor greenColor]];
     */
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

//
//  SNInteractionCell.h
//  InteractionTableViewExample
//
//  Created by Simon Nickel on 06.02.14.
//  Copyright (c) 2014 simonnickel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNInteractionCell : UITableViewCell <UIDynamicAnimatorDelegate>

extern const double actionPanelHeight;

@property (nonatomic) UIView *container;

@property (nonatomic) UIColor *colorBackground;
@property (nonatomic) UIColor *colorContainer;
@property (nonatomic) UIColor *colorSelected;

@end

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
extern const double seperatorHeight;

@property (nonatomic) UIView *container;
@property (nonatomic) UIToolbar *actionPanel;

@property (nonatomic) UIColor *colorBackground;
@property (nonatomic) UIColor *colorContainer;
@property (nonatomic) UIColor *colorSelected;
@property (nonatomic) UIColor *colorActionPanel;

- (void)setupActionPanelWithButtons:(NSArray *)buttons;
- (void)toggleVisibility:(BOOL)visibility;

@end

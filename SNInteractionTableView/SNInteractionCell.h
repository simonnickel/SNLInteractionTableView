//
//  SNInteractionCell.h
//  InteractionTableViewExample
//
//  Created by Simon Nickel on 06.02.14.
//  Copyright (c) 2014 simonnickel. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SNICellPanSuccessAnimationDefault [NSNumber numberWithInt:0]
#define SNICellPanSuccessAnimationBounce [NSNumber numberWithInt:0]
#define SNICellPanSuccessAnimationOut [NSNumber numberWithInt:1]

#define panStateOff [NSNumber numberWithInt:0]
#define panStateNone [NSNumber numberWithInt:1]
#define panStateIncrease [NSNumber numberWithInt:2]
#define panStateDecrease [NSNumber numberWithInt:3]
#define panStateEdit [NSNumber numberWithInt:4]

@interface SNInteractionCell : UITableViewCell <UIDynamicAnimatorDelegate>

extern const double toolbarHeight;
extern const double seperatorHeight;

@property (nonatomic) UIView *container;
@property (nonatomic) BOOL hasToolbar;
@property (nonatomic) UIToolbar *toolbar;
@property (nonatomic) NSArray *toolbarButtons;

@property (nonatomic) UIView *indicatorLeft;
@property (nonatomic) UIView *indicatorRight;
@property (nonatomic) NSNumber *indicatorWidth;
@property (nonatomic) UIImage *indicatorImageLeft;
@property (nonatomic) UIImage *indicatorImageRight;
@property (nonatomic) UIImage *indicatorImageSuccessLeft;
@property (nonatomic) UIImage *indicatorImageSuccessRight;
@property (nonatomic) NSNumber *panSuccesAnimationLeft;
@property (nonatomic) NSNumber *panSuccesAnimationRight;
@property (strong, nonatomic) void(^panSuccessActionLeft)();
@property (strong, nonatomic) void(^panSuccessActionRight)();

@property (nonatomic) BOOL panSuccesLeft;
@property (nonatomic) BOOL panSuccesRight;

@property (nonatomic) UIColor *colorBackground;
@property (nonatomic) UIColor *colorContainer;
@property (nonatomic) UIColor *colorSelected;
@property (nonatomic) UIColor *colorToolbarBarTint;
@property (nonatomic) UIColor *colorToolbarTint;
@property (nonatomic) UIColor *colorIndicator;
@property (nonatomic) UIColor *colorIndicatorSuccess;

- (void)toggleVisibility:(BOOL)visibility;

@end

//
//  SNInteractionCell.m
//  InteractionTableViewExample
//
//  Created by Simon Nickel on 06.02.14.
//  Copyright (c) 2014 simonnickel. All rights reserved.
//

#import "SNInteractionCell.h"

@interface SNInteractionCell ()

@property (nonatomic) UIView *container;
@property BOOL isContainerSetUp;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UICollisionBehavior *collision;
@property (nonatomic, strong) UIGravityBehavior *gravity;

@end

@implementation SNInteractionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];

    // wrap subviews of contentView in container
    if (self.isContainerSetUp != YES) {
        [self setupContainer];
        self.isContainerSetUp = YES;
    }
}

/*
 *  Wrap subviews of contentView in container.
 *  Maintain constraints and settings.
 *  Setup PanGesture.
 */
- (void)setupContainer {
    self.container = [[UIView alloc] init];
    NSMutableArray *newConstraints = [[NSMutableArray alloc] init];
    
    // maintain constraints
    NSArray *constraints = self.contentView.constraints;
    for (NSLayoutConstraint *constraint in constraints) {
        // replace constraints to contentView with container
        if (constraint.firstItem == self.contentView ||
            constraint.secondItem == self.contentView
            ) {
            NSLayoutConstraint *newConstraint;
            if (constraint.firstItem == self.contentView)
                newConstraint = [NSLayoutConstraint constraintWithItem:self.container attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:constraint.secondItem attribute:constraint.secondAttribute multiplier:constraint.multiplier constant:constraint.constant];
            else newConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:self.container attribute:constraint.secondAttribute multiplier:constraint.multiplier constant:constraint.constant];
            [newConstraints addObject:newConstraint];
            [self.contentView removeConstraint:constraint];
        }
        // move other constraints into container
        else {
            [newConstraints addObject:constraint];
            [self.contentView removeConstraint:constraint];
        }
    }
    
    // remove subviews from contentView and add them to container
    NSArray *contentViews = self.contentView.subviews;
    for (UIView *view in contentViews) {
        [view removeFromSuperview];
        [self.container addSubview:view];
    }
    [self.container addConstraints:newConstraints];
    [self.contentView addSubview:self.container];
    
    
    // layout container to fill contentView
    [self.container setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.f];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.f];
    [self.contentView addConstraints:@[top, right, left, bottom]];
    
    
    // copy settings of contentView
    self.container.backgroundColor = self.contentView.backgroundColor;
    self.container.tintColor = self.contentView.tintColor;
    self.container.alpha = self.contentView.alpha;
    /* copy these settings too, if needed
     self.container.clearsContextBeforeDrawing = self.contentView.clearsContextBeforeDrawing;
     self.container.opaque = self.contentView.opaque;
     self.container.hidden = self.contentView.hidden;
     self.container.clipsToBounds = self.contentView.clipsToBounds;
     self.container.autoresizesSubviews = self.contentView.autoresizesSubviews;
     */
    
    self.contentView.backgroundColor = [UIColor blackColor];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panRecognizer setDelegate:self];
    [self.container addGestureRecognizer:panRecognizer];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.contentView];
    [self.animator setDelegate:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
 * Gesture functions
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.contentView];
        
        // only pan if movement is horizontal
        return fabs(translation.y) < fabs(translation.x);
    }
    else {
        return YES;
    }
}
// panGesture to swipe a cell to trigger actions
- (void)handlePanGesture:(UIPanGestureRecognizer*)gestureRecognizer {
    float distance =  (float) (gestureRecognizer.view.center.x - self.contentView.center.x);
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){

    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // translate pan movement
        CGPoint translatedPoint = [gestureRecognizer translationInView:gestureRecognizer.view];
        gestureRecognizer.view.center = CGPointMake(gestureRecognizer.view.center.x+translatedPoint.x, gestureRecognizer.view.center.y);
        [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:gestureRecognizer.view.superview];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // set UIDynamics to get the container back in position
        UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.container]];
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.container]];
        UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc] initWithItems:@[self.container]];
        item.elasticity = 0.3f;
        [self.animator addBehavior:collision];
        [self.animator addBehavior:gravity];
        [self.animator addBehavior:item];
        
        // set gravity and collision boundary depending on pan direction
        CGFloat space = - self.container.frame.size.width;
        if (distance < 0) {
            [gravity setGravityDirection:CGVectorMake(5, 0)];
            [collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(space, space, space, 0)];
        }
        else {
            [gravity setGravityDirection:CGVectorMake(-5, 0)];
            [collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(space, 0, space, space)];
        }
    }
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    [self.animator removeAllBehaviors];
    
    // reset weird 1/2px bounce rotation
    [self.container setNeedsLayout];
    [self.container layoutIfNeeded];
}


@end

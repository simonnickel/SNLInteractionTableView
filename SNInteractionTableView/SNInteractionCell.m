//
//  SNInteractionCell.m
//  InteractionTableViewExample
//
//  Created by Simon Nickel on 06.02.14.
//  Copyright (c) 2014 simonnickel. All rights reserved.
//

#import "SNInteractionCell.h"

@interface SNInteractionCell ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UICollisionBehavior *collision;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) NSLayoutConstraint *heightContainer;

@end

@implementation SNInteractionCell

const double actionPanelHeight = 44;
const double seperatorHeight = 0.5;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
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
    // wrap subviews of contentView in container
    [self setupContainer];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // set color
    self.contentView.backgroundColor = self.colorBackground;
    if (self.isSelected) {
        self.container.backgroundColor = self.colorSelected;
        self.heightContainer.constant = self.contentView.frame.size.height - actionPanelHeight;
    }
    else
        self.container.backgroundColor = self.colorContainer;

    // set action panel
    if (self.actionPanel) {
        [self.contentView addSubview:self.actionPanel];
        [self setupActionPanelConstraints];
    }
}
- (void)toggleVisibility:(BOOL)visible {
    self.hidden = !visible;
}
// reset animations for segues etc.
- (void)reset {
    self.container.hidden = NO;
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
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant: - seperatorHeight];
    //NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-1.f];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.f];
    
    self.heightContainer = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant: self.contentView.frame.size.height];

    [self.contentView addConstraints:@[top, right, left, self.heightContainer]];
    
    // copy settings of contentView
    if (! self.colorBackground) {
        self.colorBackground = self.backgroundColor;
    }
    if (! self.colorContainer) {
        self.colorContainer = self.contentView.backgroundColor;
    }
    if (! self.colorSelected) {
        self.colorSelected = [UIColor whiteColor];
    }
    if (! self.colorActionPanel) {
        self.colorSelected = self.backgroundColor;
    }
    /* more settings to copy, if needed
     self.container.tintColor = self.contentView.tintColor;
     self.container.alpha = self.contentView.alpha;
     self.container.clearsContextBeforeDrawing = self.contentView.clearsContextBeforeDrawing;
     self.container.opaque = self.contentView.opaque;
     self.container.hidden = self.contentView.hidden;
     self.container.clipsToBounds = self.contentView.clipsToBounds;
     self.container.autoresizesSubviews = self.contentView.autoresizesSubviews;
     */
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panRecognizer setDelegate:self];
    [self.container addGestureRecognizer:panRecognizer];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.contentView];
    [self.animator setDelegate:self];
}

- (void)setupActionPanelWithButtons:(NSArray *)buttons {
    UIToolbar *actionPanel = [[UIToolbar alloc] init];
    [actionPanel setTranslatesAutoresizingMaskIntoConstraints:NO];

    actionPanel.items = buttons;

    actionPanel.backgroundColor = self.colorBackground;
    actionPanel.barTintColor = self.colorActionPanel;

    self.actionPanel = actionPanel;
    
}
- (void)setupActionPanelConstraints {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.actionPanel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:self.heightContainer.constant];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.actionPanel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.actionPanel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.f];
   NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.actionPanel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant: actionPanelHeight];
    
    [self.contentView addConstraints:@[top, right, left, height]];
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
    float panDistance =  (float) (gestureRecognizer.view.center.x - self.contentView.center.x);
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        [self.animator removeAllBehaviors];
        [self setPanSuccesLeft:NO];
        [self setPanSuccesRight:NO];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // translate pan movement
        CGPoint translatedPoint = [gestureRecognizer translationInView:gestureRecognizer.view];
        self.container.center = CGPointMake(gestureRecognizer.view.center.x+translatedPoint.x, gestureRecognizer.view.center.y);
        [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:gestureRecognizer.view.superview];
        
        
        NSNumber *panSuccesDistanceLeft = [NSNumber numberWithInt:50];
        NSNumber *panSuccesDistanceRight = [NSNumber numberWithInt:50];
        
        if (panDistance > [panSuccesDistanceLeft floatValue])
            [self setPanSuccesLeft:YES];
        else
            [self setPanSuccesLeft:NO];
        
        if (panDistance < - [panSuccesDistanceRight floatValue])
            [self setPanSuccesRight:YES];
        else
            [self setPanSuccesRight:NO];
        
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // slide out
        if ((self.panSuccesLeft &&
            [self.panSuccesAnimationLeft intValue] == [SNICellPanSuccessAnimationOut intValue]) ||
            (self.panSuccesRight &&
             [self.panSuccesAnimationRight intValue] == [SNICellPanSuccessAnimationOut intValue])
        ) {
            CGPoint outside;
            if (self.panSuccesLeft)
                outside = CGPointMake(self.contentView.frame.size.width/2, self.contentView.center.y);
            else
                outside = CGPointMake(-self.contentView.frame.size.width/2, self.contentView.center.y);
                
            [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 [gestureRecognizer.view setCenter:outside];
                             } completion:^(BOOL completed){
                                 [self.container setHidden:YES];
                                 //[gestureRecognizer.view setCenter:centerReset];
                                 if (self.panSuccesLeft)
                                     self.panSuccessActionLeft(self);
                                 else if (self.panSuccesRight)
                                     self.panSuccessActionRight(self);
                             }];
        }
        // view has to bounce back
        else {
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
            if (panDistance < 0) {
                [gravity setGravityDirection:CGVectorMake(5, 0)];
                [collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(space, space, space, 0)];
            }
            else {
                [gravity setGravityDirection:CGVectorMake(-5, 0)];
                [collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(space, 0, space, space)];
            }
            
            if (self.panSuccesLeft)
                self.panSuccessActionLeft(self);
            else if (self.panSuccesRight)
                self.panSuccessActionRight(self);
   
        }
    }
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    [self.animator removeAllBehaviors];
    
    /*reset weird 1/2px bounce rotation if seperator exists
    [self.container setNeedsLayout];
    [self.container layoutIfNeeded];
    */
}


@end

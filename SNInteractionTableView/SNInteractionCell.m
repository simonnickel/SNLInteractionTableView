//
//  SNInteractionCell.m
//  InteractionTableViewExample
//
//  Created by Simon Nickel on 06.02.14.
//
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

#import "SNInteractionCell.h"

@interface SNInteractionCell ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UICollisionBehavior *collision;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) NSLayoutConstraint *heightContainer;

@end

@implementation SNInteractionCell

const double toolbarHeight = 44;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self SNInteractionCellInitialize];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self SNInteractionCellInitialize];
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self SNInteractionCellInitialize];
    }
    return self;
}
- (void)SNInteractionCellInitialize {
	self.clipsToBounds = YES;
    // wrap subviews of contentView in container
    [self setupContainer];
    
    self.indicatorWidth = [NSNumber numberWithInt:50];
    [self setupIndicatorLeft];
    [self setupIndicatorRight];
    
    [self setupCustomSeparator];
    
    [self setupToolbar];
}
- (void)prepareForReuse {
    self.container.hidden = NO;
    [self toggleVisibility:YES];
}
- (void)layoutSubviews {
    [super layoutSubviews];

    // set color
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = self.colorBackground;
    if (self.isSelected) {
        self.container.backgroundColor = self.colorSelected;
        if (self.hasToolbar)
            self.heightContainer.constant = self.contentView.frame.size.height - toolbarHeight;
    }
    else
        self.container.backgroundColor = self.colorContainer;
    
	self.toolbar.backgroundColor = self.colorToolbarBarTint;
    self.toolbar.barTintColor = self.colorToolbarBarTint;
    self.toolbar.tintColor = self.colorToolbarTint;
    self.indicatorLeft.backgroundColor = self.colorIndicator;
    self.indicatorRight.backgroundColor = self.colorIndicator;
    
    self.customSeparatorTop.backgroundColor = self.colorCustomSeparatorTop;
    self.customSeparatorBottom.backgroundColor = self.colorCustomSeparatorBottom;
}

- (void)toggleVisibility:(BOOL)visible {
    self.hidden = !visible;
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
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant: 0.f];
    //NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-1.f];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.f];
    
    self.heightContainer = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant: self.contentView.frame.size.height];
    
    [self.contentView addConstraints:@[top, right, left, self.heightContainer]];
    
    // copy settings of contentView
    self.colorBackground = self.backgroundColor;
    self.colorContainer = self.contentView.backgroundColor;
    self.colorSelected = self.contentView.tintColor;
    self.colorToolbarBarTint = self.backgroundColor;
    self.colorToolbarTint = self.tintColor;
    self.colorIndicator = self.colorContainer;
    self.colorIndicatorSuccess = self.tintColor;
    self.colorCustomSeparatorTop = self.backgroundColor;
    self.colorCustomSeparatorBottom = self.backgroundColor;
    
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

/*
 *  Setup additional view elements: toolbar, indicatorLeft/Right
 */

- (void)setupToolbar {
    self.toolbar = [[UIToolbar alloc] init];
    [self.contentView addSubview:self.toolbar];
    [self.toolbar setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.toolbar.clipsToBounds = YES;
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:self.heightContainer.constant];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.f];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant: toolbarHeight];
    
    [self.contentView addConstraints:@[top, right, left, height]];
}

- (void)setToolbarButtons:(NSArray *)toolbarButtons {
    _toolbarButtons = toolbarButtons;
    [self.toolbar setItems:toolbarButtons];
}

- (void)setupCustomSeparator {
    self.customSeparatorTop = [self customSeparator:YES forView:self.container];
    self.customSeparatorBottom = [self customSeparator:NO forView:self.container];
}
- (UIView *)customSeparator:(BOOL)isTop forView:(UIView *)targetView {
    UIView *view = [[UIView alloc] init];
    [targetView addSubview:view];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:targetView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:targetView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.f];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:targetView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:targetView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.f];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant: 0.5f];
    
    [targetView addConstraints:@[right, left, height]];
    
    if (isTop)
        [targetView addConstraint:top];
    else
        [targetView addConstraint:bottom];
    
    return view;
}

- (void)setupIndicatorLeft {
    [self setupIndicatorLeft:YES];
}
- (void)setupIndicatorRight {
    [self setupIndicatorLeft:NO];
}
- (void)setupIndicatorLeft:(BOOL)isLeft {
    UIView *indicator = [[UIView alloc] init];
    [indicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant: - [self.indicatorWidth floatValue]];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:[self.indicatorWidth floatValue]];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.f];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:[self.indicatorWidth floatValue]];

    UIImageView *image;
    
    if (isLeft) {
        self.indicatorImageViewLeft = [[UIImageView alloc] init];
        image = self.indicatorImageViewLeft;
        
        self.indicatorLeft = indicator;
        [self.contentView addSubview:self.indicatorLeft];
        
        [self.contentView addConstraints:@[top, left, height, width]];
    }
    else {
        self.indicatorImageViewRight = [[UIImageView alloc] init];
        image = self.indicatorImageViewRight;
        
        self.indicatorRight = indicator;
        [self.contentView addSubview:self.indicatorRight];
        [self.contentView addConstraints:@[top, right, height, width]];
    }
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:indicator attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.f];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:image attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:indicator attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.f];

    [image setTranslatesAutoresizingMaskIntoConstraints:NO];

    [indicator addSubview:image];
    [indicator addConstraints:@[centerX, centerY]];
}

- (void)resetIndicatorLeft:(BOOL)isLeft withDelay:(BOOL)withDelay {
    float delay = 0.0;
    if (withDelay)
        delay = 0.7;
    
    [UIView animateWithDuration:0.3 delay:delay usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         if (isLeft)
                             self.indicatorLeft.center = CGPointMake(- self.indicatorLeft.frame.size.width/2, self.container.center.y);
                         else
                             self.indicatorRight.center = CGPointMake(self.contentView.frame.size.width + self.indicatorRight.frame.size.width/2, self.container.center.y);
                     } completion:^(BOOL completed){}];
}

- (void)setIndicatorImageLeft:(UIImage *)indicatorImageLeft {
    _indicatorImageLeft = indicatorImageLeft;
	// should be set on initialisation to work with dis-/enabling
    //[self.indicatorImageViewLeft setImage:self.indicatorImageLeft];
}
- (void)setIndicatorImageRight:(UIImage *)indicatorImageRight {
    _indicatorImageRight = indicatorImageRight;
	// should be set on initialisation to work with dis-/enabling
    //[self.indicatorImageViewRight setImage:self.indicatorImageRight];
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
        [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:gestureRecognizer.view.superview];

        float panFactor = 0.7;
        NSNumber *panSuccesDistanceLeft = [NSNumber numberWithInt:50 * (1/panFactor)];
        NSNumber *panSuccesDistanceRight = [NSNumber numberWithInt: - 50 * (1/panFactor)];
        
        // pan container
        self.container.center = CGPointMake(gestureRecognizer.view.center.x+translatedPoint.x, gestureRecognizer.view.center.y);
        
        // pan left indicator
        if (panDistance < [panSuccesDistanceLeft floatValue])
            self.indicatorLeft.center = CGPointMake(self.indicatorLeft.center.x+translatedPoint.x*panFactor, gestureRecognizer.view.center.y);
        else
            self.indicatorLeft.center = CGPointMake(self.indicatorLeft.frame.size.width/2, gestureRecognizer.view.center.y);
        
        // pan right indicator
        if (panDistance > [panSuccesDistanceRight floatValue])
            self.indicatorRight.center = CGPointMake(self.indicatorRight.center.x+translatedPoint.x*panFactor, gestureRecognizer.view.center.y);
        else
            self.indicatorRight.center = CGPointMake(self.contentView.frame.size.width - self.indicatorRight.frame.size.width/2, gestureRecognizer.view.center.y);
        
        // trigger actions
        if (panDistance > [panSuccesDistanceLeft floatValue])
            [self setPanSuccesLeft:YES];
        else
            [self setPanSuccesLeft:NO];
        
        if (panDistance < [panSuccesDistanceRight floatValue])
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
                outside = CGPointMake(self.contentView.frame.size.width/2, self.container.center.y);
            else
                outside = CGPointMake(-self.contentView.frame.size.width/2, self.container.center.y);
                
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
            item.elasticity = 0.4f;
            [self.animator addBehavior:collision];
            [self.animator addBehavior:gravity];
            [self.animator addBehavior:item];
            
            // set gravity and collision boundary depending on pan direction
            CGFloat space = - self.container.frame.size.width;
            if (panDistance < 0) {
                [gravity setGravityDirection:CGVectorMake(3, 0)];
                [collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(0, space, 0, 0)];
            }
            else {
                [gravity setGravityDirection:CGVectorMake(-3, 0)];
                [collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(0, 0, 0, space)];
            }
            
            // handle left action
            if (self.panSuccesLeft) {
                self.panSuccessActionLeft(self);
                [self resetIndicatorLeft:YES withDelay:YES];
            }
            else {
                [self resetIndicatorLeft:YES withDelay:NO];
            }
            
            // handle right action
            if (self.panSuccesRight) {
                self.panSuccessActionRight(self);
                [self resetIndicatorLeft:NO withDelay:YES];
            }
            else {
                [self resetIndicatorLeft:NO withDelay:NO];
            }
        }
    }
}

- (void)setPanSuccesLeft:(BOOL)panSuccess {
    _panSuccesLeft = panSuccess;
    
    // re/set success color if existing
    if (panSuccess)
        self.indicatorLeft.backgroundColor = self.colorIndicatorSuccess;
    else
        self.indicatorLeft.backgroundColor = self.colorIndicator;
    
    // re/set success image if existing
    if (panSuccess && self.indicatorImageSuccessLeft)
        [self.indicatorImageViewLeft setImage:self.indicatorImageSuccessLeft];
    else
        [self.indicatorImageViewLeft setImage:self.indicatorImageLeft];
}
- (void)setPanSuccesRight:(BOOL)panSuccess {
    _panSuccesRight = panSuccess;
    
    // re/set success color if existing
    if (panSuccess)
        self.indicatorRight.backgroundColor = self.colorIndicatorSuccess;
    else
        self.indicatorRight.backgroundColor = self.colorIndicator;
    
    // re/set success image if existing
    if (panSuccess && self.indicatorImageSuccessRight)
        [self.indicatorImageViewRight setImage:self.indicatorImageSuccessRight];
    else
        [self.indicatorImageViewRight setImage:self.indicatorImageRight];
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    [self.animator removeAllBehaviors];
    
    //reset weird 1/2px bounce rotation if seperator exists
    [self.container setNeedsLayout];
    [self.container layoutIfNeeded];
}

@end

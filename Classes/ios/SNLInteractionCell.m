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

#import "SNLInteractionCell.h"

@interface SNLInteractionCell ()

@property (nonatomic) UIView *container;
@property (nonatomic) NSLayoutConstraint *heightContainer;

@property (nonatomic) NSNumber *indicatorWidth;
@property (nonatomic) UIView *indicatorLeft;
@property (nonatomic) UIView *indicatorRight;

@property (nonatomic) UIImageView *indicatorImageViewLeft;
@property (nonatomic) UIImageView *indicatorImageViewRight;
@property (nonatomic) UIImage *indicatorImageLeft;
@property (nonatomic) UIImage *indicatorImageRight;
@property (nonatomic) UIImage *indicatorImageSuccessLeft;
@property (nonatomic) UIImage *indicatorImageSuccessRight;
@property (nonatomic) UIImage *indicatorImageDisabledLeft;
@property (nonatomic) UIImage *indicatorImageDisabledRight;

@property (nonatomic) BOOL swipeSuccessLeft;
@property (nonatomic) BOOL swipeSuccessRight;
@property (nonatomic) SNLSwipeAnimation swipeAnimationCancelLeft;
@property (nonatomic) SNLSwipeAnimation swipeAnimationCancelRight;
@property (nonatomic) SNLSwipeAnimation swipeAnimationSuccessLeft;
@property (nonatomic) SNLSwipeAnimation swipeAnimationSuccessRight;

@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UICollisionBehavior *collision;
@property (nonatomic) UIGravityBehavior *gravity;

@end

@implementation SNLInteractionCell

const double SNLToolbarHeight = 44;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self SNLInteractionCellInitialize];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self SNLInteractionCellInitialize];
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self SNLInteractionCellInitialize];
    }
    return self;
}
- (void)SNLInteractionCellInitialize {
	self.clipsToBounds = YES;
    // wrap subviews of contentView in container
    [self setupContainer];
    
    self.indicatorWidth = [NSNumber numberWithInt:50];
    [self setupIndicator:SNLSwipeSideBoth];
	
	[self setupToolbar];
}

- (void)configureSwipeOn:(SNLSwipeSide)side withCancelAnimation:(SNLSwipeAnimation)animationCancel successAnimation:(SNLSwipeAnimation)animationSuccess image:(UIImage *)image imageOnSuccess:(UIImage *)imageSuccess imageInactive:(UIImage *)imageDisabled {
	if (side == SNLSwipeSideLeft || side == SNLSwipeSideBoth) {
		self.swipeAnimationCancelLeft = animationCancel;
		self.swipeAnimationSuccessLeft = animationSuccess;
		self.indicatorImageLeft = image;
		self.indicatorImageSuccessLeft = imageSuccess;
		self.indicatorImageDisabledLeft = imageDisabled;
	}
	if (side == SNLSwipeSideRight || side == SNLSwipeSideBoth) {
		self.swipeAnimationCancelRight = animationCancel;
		self.swipeAnimationSuccessRight = animationSuccess;
		self.indicatorImageRight = image;
		self.indicatorImageSuccessRight = imageSuccess;
		self.indicatorImageDisabledRight = imageDisabled;
	}
}


#pragma mark - Lifecycle

- (void)layoutSubviews {
    [super layoutSubviews];
	
    // set color
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = self.colorBackground;
    if (self.isSelected) {
        self.container.backgroundColor = self.colorSelected;
    }
    else
        self.container.backgroundColor = self.colorContainer;
    
	self.toolbar.backgroundColor = self.colorToolbarBarTint;
    self.toolbar.barTintColor = self.colorToolbarBarTint;
    self.toolbar.tintColor = self.colorToolbarTint;
    
    self.customSeparatorTop.backgroundColor = self.colorCustomSeparatorTop;
    self.customSeparatorBottom.backgroundColor = self.colorCustomSeparatorBottom;
	
	[self updateIndicatorStyle:SNLSwipeSideBoth forSuccess:NO];
}

- (void)prepareForReuse {
    self.container.hidden = NO;
	self.hidden = NO;
}

- (void)updateIndicatorStyle:(SNLSwipeSide)side forSuccess:(BOOL)success {
	if (side == SNLSwipeSideLeft || side == SNLSwipeSideBoth) {
		self.indicatorLeft.backgroundColor = success ? self.colorIndicatorSuccess : self.colorIndicator;
		self.indicatorImageViewLeft.image = self.swipeActiveLeft ?
			(success && self.indicatorImageSuccessLeft) ? self.indicatorImageSuccessLeft : self.indicatorImageLeft
			: self.indicatorImageDisabledLeft;
	}
	if (side == SNLSwipeSideRight || side == SNLSwipeSideBoth) {
		self.indicatorRight.backgroundColor = success ? self.colorIndicatorSuccess : self.colorIndicator;
		self.indicatorImageViewRight.image = self.swipeActiveRight ?
			(success && self.indicatorImageSuccessRight) ? self.indicatorImageSuccessRight : self.indicatorImageRight
			: self.indicatorImageDisabledRight;
	}
}


#pragma mark - Setter and Getter

- (void)setToolbarButtons:(NSArray *)toolbarButtons {
    _toolbarButtons = toolbarButtons;
    [self.toolbar setItems:toolbarButtons];
}

- (void)setSwipeSuccessLeft:(BOOL)success {
	if (success != _swipeSuccessLeft && self.swipeActiveLeft) {
		[self updateIndicatorStyle:SNLSwipeSideLeft forSuccess:success];
	}
    _swipeSuccessLeft = success && self.swipeActiveLeft;
}
- (void)setSwipeSuccessRight:(BOOL)success {
	if (success != _swipeSuccessRight && self.swipeActiveRight) {
		[self updateIndicatorStyle:SNLSwipeSideRight forSuccess:success];
	}
    _swipeSuccessRight = success && self.swipeActiveRight;
}

- (void)setSwipeActiveLeft:(BOOL)indicatorEnabledLeft {
	_swipeActiveLeft = indicatorEnabledLeft;
	[self updateIndicatorStyle:SNLSwipeSideLeft forSuccess:NO];
}
- (void)setSwipeActiveRight:(BOOL)indicatorEnabledRight {
	_swipeActiveRight = indicatorEnabledRight;
	[self updateIndicatorStyle:SNLSwipeSideRight forSuccess:NO];
}

#pragma mark - Setup Helper

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
    
    self.heightContainer = [NSLayoutConstraint constraintWithItem:self.container attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:self.contentView.frame.size.height];
    
    [self.contentView addConstraints:@[top, right, left, self.heightContainer]];
    
    // copy settings of contentView
    self.colorBackground = self.backgroundColor;
    self.colorContainer = self.contentView.backgroundColor;
    self.colorSelected = self.contentView.tintColor;
    self.colorToolbarBarTint = self.backgroundColor;
    self.colorToolbarTint = self.tintColor;
    self.colorIndicator = self.colorContainer;
    self.colorIndicatorSuccess = self.tintColor;
    self.colorCustomSeparatorTop = self.contentView.backgroundColor;
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

- (void)setupIndicator:(SNLSwipeSide)side {
	if (side == SNLSwipeSideBoth) {
		[self setupIndicator:SNLSwipeSideLeft];
		[self setupIndicator:SNLSwipeSideRight];
	}
	else {
		UIView *indicator = [[UIView alloc] init];
		[indicator setTranslatesAutoresizingMaskIntoConstraints:NO];
		
		NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];
		NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant: - [self.indicatorWidth floatValue]];
		NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:[self.indicatorWidth floatValue]];
		NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.f];
		NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:[self.indicatorWidth floatValue]];
		
		UIImageView *image;
		
		if (side == SNLSwipeSideLeft) {
			self.swipeActiveLeft = YES;
			self.indicatorImageViewLeft = [[UIImageView alloc] init];
			image = self.indicatorImageViewLeft;
			
			self.indicatorLeft = indicator;
			[self.contentView addSubview:self.indicatorLeft];
			
			[self.contentView addConstraints:@[top, left, height, width]];
		}
		else if (side == SNLSwipeSideRight) {
			self.swipeActiveRight = YES;
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
}

- (void)setupToolbar {
    self.toolbar = [[UIToolbar alloc] init];
    [self.contentView addSubview:self.toolbar];
    [self.toolbar setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.toolbar.clipsToBounds = YES;
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:self.heightContainer.constant];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.f];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.f];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant: SNLToolbarHeight];
    
    [self.contentView addConstraints:@[top, right, left, height]];
}


#pragma mark - Interaction

- (void)buttonPressed:(UIButton *)sender {
	[self.delegate buttonActionWithTag:sender.tag onCell:self];
}

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
    float panDistance = (float) (gestureRecognizer.view.center.x - self.contentView.center.x);
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        [self.animator removeAllBehaviors];
        [self setSwipeSuccessLeft:NO];
        [self setSwipeSuccessRight:NO];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // translate pan movement
        CGPoint translatedPoint = [gestureRecognizer translationInView:gestureRecognizer.view];
        [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:gestureRecognizer.view.superview];
		
        float panFactor = 0.7;
        NSNumber *swipeSuccessDistanceLeft = [NSNumber numberWithInt:50 * (1/panFactor)];
        NSNumber *swipeSuccessDistanceRight = [NSNumber numberWithInt: - 50 * (1/panFactor)];
        
        // pan container
        self.container.center = CGPointMake(gestureRecognizer.view.center.x+translatedPoint.x, gestureRecognizer.view.center.y);
        
        // pan left indicator
        if (panDistance < [swipeSuccessDistanceLeft floatValue])
            self.indicatorLeft.center = CGPointMake(self.indicatorLeft.center.x+translatedPoint.x*panFactor, gestureRecognizer.view.center.y);
        else
            self.indicatorLeft.center = CGPointMake(self.indicatorLeft.frame.size.width/2, gestureRecognizer.view.center.y);
        
        // pan right indicator
        if (panDistance > [swipeSuccessDistanceRight floatValue])
            self.indicatorRight.center = CGPointMake(self.indicatorRight.center.x+translatedPoint.x*panFactor, gestureRecognizer.view.center.y);
        else
            self.indicatorRight.center = CGPointMake(self.contentView.frame.size.width - self.indicatorRight.frame.size.width/2, gestureRecognizer.view.center.y);
        
        // trigger actions
		[self setSwipeSuccessLeft:panDistance > [swipeSuccessDistanceLeft floatValue]];
		[self setSwipeSuccessRight:panDistance < [swipeSuccessDistanceRight floatValue]];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
		SNLSwipeAnimation animation = SNLSwipeAnimationDefault;
		if (panDistance > 0) { // swipe to right
			animation = self.swipeSuccessLeft ? self.swipeAnimationSuccessLeft : self.swipeAnimationCancelLeft;
		}
		else { // swipe to left
			animation = self.swipeSuccessRight ? self.swipeAnimationSuccessRight : self.swipeAnimationCancelRight;
		}
		
		// slide out
        if (animation == SNLSwipeAnimationSlideOut) {
            CGPoint outside;
            if (self.swipeSuccessLeft)
                outside = CGPointMake(self.contentView.frame.size.width/2, self.container.center.y);
            else
                outside = CGPointMake(-self.contentView.frame.size.width/2, self.container.center.y);
			
            [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
							 animations:^{
								 [gestureRecognizer.view setCenter:outside];
							 } completion:^(BOOL completed){
								 [self.container setHidden:YES];
								 [self performSwipeSuccessDelayAnimation:NO];
							 }];
        }
		// slide back
		else if (animation == SNLSwipeAnimationSlideBack) {
			[UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
							 animations:^{
								 CGPoint center = CGPointMake(self.center.x, self.container.center.y);
								 [gestureRecognizer.view setCenter:center];
							 } completion:^(BOOL completed){
								 [self performSwipeSuccessDelayAnimation:NO];
							 }];
		}
		// bounce back
        else { // if (animation == SNLSwipeAnimationBounce || animation == SNLSwipeAnimationDefault)
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
            
			[self performSwipeSuccessDelayAnimation:(self.swipeSuccessLeft || self.swipeSuccessRight)];
        }
    }
}

- (void)performSwipeSuccessDelayAnimation:(BOOL)animationDelayed {
	if (self.swipeSuccessLeft && self.swipeActiveLeft) {
		[self.delegate swipeAction:SNLSwipeSideLeft onCell:self];
	}
	else if (self.swipeSuccessRight && self.swipeActiveRight) {
		[self.delegate swipeAction:SNLSwipeSideRight onCell:self];
	}
	[self resetIndicator:SNLSwipeSideBoth delayed:animationDelayed];
}

- (void)resetIndicator:(SNLSwipeSide)side delayed:(BOOL)delayed {
    [UIView animateWithDuration:0.3
						  delay:(delayed ? 0.7 : 0.0)
		 usingSpringWithDamping:1.0f
		  initialSpringVelocity:1.0f
						options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 if (side == SNLSwipeSideLeft || side == SNLSwipeSideBoth) {
							 self.indicatorLeft.center = CGPointMake(- self.indicatorLeft.frame.size.width/2, self.container.center.y);
						 }
						 if (side == SNLSwipeSideRight || side == SNLSwipeSideBoth) {
							 self.indicatorRight.center = CGPointMake(self.contentView.frame.size.width + self.indicatorRight.frame.size.width/2, self.container.center.y);
						 }
					 }
					 completion:^(BOOL completed){}];
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    [self.animator removeAllBehaviors];
    
    //reset weird 1/2px bounce rotation if seperator exists
    //[self.container setNeedsLayout];
    //[self.container layoutIfNeeded];
}

@end

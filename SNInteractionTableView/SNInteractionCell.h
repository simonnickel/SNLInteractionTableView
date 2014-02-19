//
//  SNInteractionCell.h
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

#import <UIKit/UIKit.h>

#define SNICellPanSuccessAnimationDefault [NSNumber numberWithInt:0]
#define SNICellPanSuccessAnimationBounce [NSNumber numberWithInt:0]
#define SNICellPanSuccessAnimationOut [NSNumber numberWithInt:1]

@interface SNInteractionCell : UITableViewCell <UIDynamicAnimatorDelegate>

extern const double toolbarHeight;

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

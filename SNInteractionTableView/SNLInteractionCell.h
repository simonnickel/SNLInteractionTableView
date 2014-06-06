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

@class SNLInteractionCell;

typedef NS_ENUM(NSInteger, SNLSwipeSide){
	SNLSwipeSideBoth,
    SNLSwipeSideLeft,
	SNLSwipeSideRight
};

typedef NS_ENUM(NSInteger, SNLSwipeAnimation){
	SNLSwipeAnimationDefault,
    SNLSwipeAnimationBounce,
	SNLSwipeAnimationSlideOut,
	SNLSwipeAnimationSlideBack
};

typedef NS_ENUM(NSInteger, SNLCustomSeparatorPosition){
	SNLCustomSeparatorPositionTop,
    SNLCustomSeparatorPositionBottom
};

/**
 *  Delegate protocol to handle cell swipe actions.
 */
@protocol SNLInteractionCellActionDelegate <NSObject>

- (void)swipeAction:(SNLSwipeSide)swipeAction onCell:(SNLInteractionCell *)cell;

- (void)buttonActionWithTag:(NSInteger)tag onCell:(SNLInteractionCell *)cell;

@end



@interface SNLInteractionCell : UITableViewCell <UIDynamicAnimatorDelegate>

extern const double SNLToolbarHeight;

/**
 *  Cells delegate to handle swipe actions.
 */
@property (nonatomic, weak) id <SNLInteractionCellActionDelegate> delegate;

/**
 *  Toolbar.
 */
@property (nonatomic) BOOL hasToolbar;
@property (nonatomic) UIToolbar *toolbar;
@property (nonatomic) NSArray *toolbarButtons;


/**
 *  Colors for all elements of the cell.
 */
@property (nonatomic) UIColor *colorContainer;				// default: contentView.backgroundColor
@property (nonatomic) UIColor *colorBackground;				// default: cell.backgroundColor
@property (nonatomic) UIColor *colorSelected;				// default: contentView.tintColor
@property (nonatomic) UIColor *colorToolbarBarTint;			// default: cell.backgroundColor
@property (nonatomic) UIColor *colorToolbarTint;			// default: cell.tintColor
@property (nonatomic) UIColor *colorIndicator;				// default: contentView.backgroundColor
@property (nonatomic) UIColor *colorIndicatorSuccess;		// default: cell.tintColor
@property (nonatomic) UIColor *colorCustomSeparatorTop;		// default: contentView.backgroundColor
@property (nonatomic) UIColor *colorCustomSeparatorBottom;	// default: cell.backgroundColor

/**
 *	Helper function to configure left and right swipe behaviour.
 */
- (void)configureSwipeOn:(SNLSwipeSide)side withAnimation:(SNLSwipeAnimation)animation andImage:(UIImage *)image andImageOnSuccess:(UIImage *)imageSuccess;

/**
 *	Called when a toolbar button is pressed.
 */
- (void)buttonPressed:(UIButton *)sender;

@end

#import "SNLExampleTableViewCell.h"

@implementation SNLExampleTableViewCell

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
     
    
    [self setIndicatorImageLeft:[UIImage imageNamed:@"indicator"]];
    [self setIndicatorImageRight:[UIImage imageNamed:@"indicator"]];
    [self setIndicatorImageSuccessLeft:[UIImage imageNamed:@"indicator_success"]];
    [self setIndicatorImageSuccessRight:[UIImage imageNamed:@"indicator_success"]];
    [self setPanSuccesAnimationLeft:SNICellPanSuccessAnimationBounce];
    [self setPanSuccesAnimationRight:SNICellPanSuccessAnimationOut];
     
     */
}


@end
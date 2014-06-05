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
     */
	
	// configure left and right swipe indicator
	[self configureSwipeOn:SNLSwipeActionLeft withAnimation:SNLSwipeAnimationBounce andImage:[UIImage imageNamed:@"indicator"] andImageOnSuccess:[UIImage imageNamed:@"indicator_success"]];
	
	[self configureSwipeOn:SNLSwipeActionRight withAnimation:SNLSwipeAnimationSlide andImage:[UIImage imageNamed:@"indicator"] andImageOnSuccess:[UIImage imageNamed:@"indicator_success"]];
	
	// setup custom separator on top and/or bottom of cell
    self.colorCustomSeparatorTop = [UIColor whiteColor];
	self.colorContainer = [UIColor lightTextColor];
    self.colorCustomSeparatorBottom = [UIColor grayColor];
	
	// setup toolbar, if toolbar is enabled (default)
    UIBarButtonItem *buttonA = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(buttonPressed:)];
	buttonA.tag = 1;
	
    UIBarButtonItem *buttonB = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(buttonPressed:)];
	buttonB.tag = 2;
	
	UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [self setToolbarButtons: [NSArray arrayWithObjects:flexibleItem, buttonA, flexibleItem, buttonB, flexibleItem, nil]];
}


@end

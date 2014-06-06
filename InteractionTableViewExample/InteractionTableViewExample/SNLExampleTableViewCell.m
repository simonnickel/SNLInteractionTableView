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
	/*
	// to override default/storyboard colors use:
	self.colorBackground = [UIColor grayColor];
	self.colorContainer = [UIColor whiteColor];
	self.colorSelected = [UIColor greenColor];
	self.colorToolbarBarTint = [UIColor blueColor];
	self.colorToolbarTint = [UIColor greenColor];
	self.colorIndicator = [UIColor redColor];
	self.colorIndicatorSuccess = [UIColor greenColor];
	self.colorCustomSeparatorTop = [UIColor whiteColor];
	self.colorCustomSeparatorBottom = [UIColor grayColor];
	*/
	
	// setup custom separator on top and/or bottom of cell
    
	
	
	
	// configure left and right swipe indicator
	[self configureSwipeOn:SNLSwipeSideLeft withAnimation:SNLSwipeAnimationBounce andImage:[UIImage imageNamed:@"indicator"] andImageOnSuccess:[UIImage imageNamed:@"indicator_success"]];
	
	[self configureSwipeOn:SNLSwipeSideRight withAnimation:SNLSwipeAnimationSlide andImage:[UIImage imageNamed:@"indicator"] andImageOnSuccess:[UIImage imageNamed:@"indicator_success"]];

	
	// setup toolbar, if toolbar is enabled (default)
    UIBarButtonItem *buttonA = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(buttonPressed:)];
	buttonA.tag = 1;
	
    UIBarButtonItem *buttonB = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(buttonPressed:)];
	buttonB.tag = 2;
	
	UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [self setToolbarButtons: [NSArray arrayWithObjects:flexibleItem, buttonA, flexibleItem, buttonB, flexibleItem, nil]];
}


@end

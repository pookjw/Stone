//
//  CardBacksViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/4/23.
//

#import "CardBacksViewController.hpp"
#import "CardBacksOptionsViewController.hpp"

__attribute__((objc_direct_members))
@interface CardBacksViewController () {
    UISplitViewController *_childSplitViewController;
    CardBacksOptionsViewController *_cardBacksOptionsViewController;
}
@property (retain, nonatomic) UISplitViewController *childSplitViewController;
@property (retain, nonatomic) CardBacksOptionsViewController *cardBacksOptionsViewController;
@end

@implementation CardBacksViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit_CardBacksViewController];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit_CardBacksViewController];
    }
    
    return self;
}

- (void)dealloc {
    [_childSplitViewController release];
    [_cardBacksOptionsViewController release];
    [super dealloc];
}

- (void)commonInit_CardBacksViewController __attribute__((objc_direct)) {
    [self setupTabBarItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildSplitViewController];
    [self setupCardBacksOptionsViewController];
}

- (UIContainerBackgroundStyle)preferredContainerBackgroundStyle {
    return UIContainerBackgroundStyleHidden;
}

- (void)setupTabBarItem __attribute__((objc_direct)) {
    UITabBarItem *tabBarItem = self.tabBarItem;
    tabBarItem.title = @"Card Backs";
    tabBarItem.image = [UIImage systemImageNamed:@"book.closed"];
}

- (void)setupChildSplitViewController __attribute__((objc_direct)) {
    UISplitViewController *childSplitViewController = self.childSplitViewController;
    UIView *contentView = childSplitViewController.view;
    
    [self addChildViewController:childSplitViewController];
    
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:contentView];
    [NSLayoutConstraint activateConstraints:@[
        [contentView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [contentView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [contentView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [contentView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    [childSplitViewController didMoveToParentViewController:self];
}

- (void)setupCardBacksOptionsViewController __attribute__((objc_direct)) {
    [self.childSplitViewController setViewController:self.cardBacksOptionsViewController forColumn:UISplitViewControllerColumnPrimary];
}

- (UISplitViewController *)childSplitViewController __attribute__((objc_direct)) {
    if (_childSplitViewController) return _childSplitViewController;
    
    UISplitViewController *childSplitViewController = [[UISplitViewController alloc] initWithStyle:UISplitViewControllerStyleDoubleColumn];
    childSplitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeOneBesideSecondary;
    childSplitViewController.preferredSplitBehavior = UISplitViewControllerSplitBehaviorTile;
    childSplitViewController.primaryBackgroundStyle = UISplitViewControllerBackgroundStyleSidebar;
    
    [_childSplitViewController release];
    _childSplitViewController = [childSplitViewController retain];
    return [childSplitViewController autorelease];
}

- (CardBacksOptionsViewController *)cardBacksOptionsViewController __attribute__((objc_direct)) {
    if (_cardBacksOptionsViewController) return _cardBacksOptionsViewController;
    
    CardBacksOptionsViewController *cardBacksOptionsViewController = [CardBacksOptionsViewController new];
    
    [_cardBacksOptionsViewController release];
    _cardBacksOptionsViewController = [cardBacksOptionsViewController retain];
    return [cardBacksOptionsViewController autorelease];
}

@end

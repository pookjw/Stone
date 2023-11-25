//
//  CardBacksViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/4/23.
//

#import "CardBacksRootViewController.hpp"
#import "CardBacksOptionsViewController.hpp"
#import "CardBacksViewController.hpp"

__attribute__((objc_direct_members))
@interface CardBacksRootViewController () <CardBacksOptionsViewControllerDelegate> {
    UISplitViewController *_childSplitViewController;
    CardBacksOptionsViewController *_cardBacksOptionsViewController;
    CardBacksViewController *_cardBacksViewController;
}
@property (retain, nonatomic) UISplitViewController *childSplitViewController;
@property (retain, nonatomic) CardBacksOptionsViewController *cardBacksOptionsViewController;
@end

@implementation CardBacksRootViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit_CardBacksRootViewController];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit_CardBacksRootViewController];
    }
    
    return self;
}

- (void)dealloc {
    [_childSplitViewController release];
    [_cardBacksOptionsViewController release];
    [_cardBacksViewController release];
    [super dealloc];
}

- (void)commonInit_CardBacksRootViewController __attribute__((objc_direct)) {
    [self setupTabBarItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildSplitViewController];
    [self setupCardBacksOptionsViewController];
    [self setupCardBacksViewController];
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
    CardBacksOptionsViewController *cardBacksOptionsViewController = self.cardBacksOptionsViewController;
    [self.childSplitViewController setViewController:cardBacksOptionsViewController forColumn:UISplitViewControllerColumnPrimary];
    cardBacksOptionsViewController.navigationController.navigationBar.prefersLargeTitles = YES;
}

- (void)setupCardBacksViewController __attribute__((objc_direct)) {
    CardBacksViewController *cardBacksViewController = self.cardBacksViewController;
    [self.childSplitViewController setViewController:cardBacksViewController forColumn:UISplitViewControllerColumnSecondary];
}

- (UISplitViewController *)childSplitViewController {
    if (_childSplitViewController) return _childSplitViewController;
    
    UISplitViewController *childSplitViewController = [[UISplitViewController alloc] initWithStyle:UISplitViewControllerStyleDoubleColumn];
    childSplitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeOneBesideSecondary;
    childSplitViewController.preferredSplitBehavior = UISplitViewControllerSplitBehaviorTile;
    childSplitViewController.primaryBackgroundStyle = UISplitViewControllerBackgroundStyleSidebar;
    
    [_childSplitViewController release];
    _childSplitViewController = [childSplitViewController retain];
    return [childSplitViewController autorelease];
}

- (CardBacksOptionsViewController *)cardBacksOptionsViewController {
    if (_cardBacksOptionsViewController) return _cardBacksOptionsViewController;
    
    CardBacksOptionsViewController *cardBacksOptionsViewController = [CardBacksOptionsViewController new];
    cardBacksOptionsViewController.delegate = self;
    
    [_cardBacksOptionsViewController release];
    _cardBacksOptionsViewController = [cardBacksOptionsViewController retain];
    return [cardBacksOptionsViewController autorelease];
}

- (CardBacksViewController *)cardBacksViewController {
    if (_cardBacksViewController) return _cardBacksViewController;
    
    CardBacksViewController *cardBacksViewController = [CardBacksViewController new];
    
    [_cardBacksViewController release];
    _cardBacksViewController = [cardBacksViewController retain];
    return [cardBacksViewController autorelease];
}

#pragma mark - CardBacksOptionsViewControllerDelegate

- (void)cardBacksOptionsViewController:(CardBacksOptionsViewController *)viewController doneWithText:(NSString *)text cardBackCategorySlug:(NSString *)slug sort:(HSCardBacksSortRequest)sort {
    [_cardBacksViewController loadWithTextFilter:text cardBackCategorySlug:slug sort:sort];
}

@end

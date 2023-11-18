//
//  CardsViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 10/29/23.
//

#import "CardsViewController.hpp"
#import "CardOptionsViewController.hpp"

__attribute__((objc_direct_members))
@interface CardsViewController () {
    UISplitViewController *_childSplitViewController;
    CardOptionsViewController *_cardOptionsViewController;
}
@property (retain, nonatomic) UISplitViewController *childSplitViewController;
@property (retain, nonatomic) CardOptionsViewController *cardOptionsViewController;
@end

@implementation CardsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit_CardsViewController];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit_CardsViewController];
    }
    
    return self;
}

- (void)dealloc {
    [_childSplitViewController release];
    [_cardOptionsViewController release];
    [super dealloc];
}

- (void)commonInit_CardsViewController __attribute__((objc_direct)) {
    [self setupTabBarItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildSplitViewController];
    [self setupCardOptionsViewController];
}

- (UIContainerBackgroundStyle)preferredContainerBackgroundStyle {
    return UIContainerBackgroundStyleHidden;
}

- (void)setupTabBarItem __attribute__((objc_direct)) {
    UITabBarItem *tabBarItem = self.tabBarItem;
    tabBarItem.title = @"Cards";
    tabBarItem.image = [UIImage systemImageNamed:@"books.vertical"];
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

- (void)setupCardOptionsViewController __attribute__((objc_direct)) {
    [self.childSplitViewController setViewController:self.cardOptionsViewController forColumn:UISplitViewControllerColumnPrimary];
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

- (CardOptionsViewController *)cardOptionsViewController {
    if (_cardOptionsViewController) return _cardOptionsViewController;
    
    CardOptionsViewController *cardOptionsViewController = [CardOptionsViewController new];
    
    [_cardOptionsViewController release];
    _cardOptionsViewController = [cardOptionsViewController retain];
    return [cardOptionsViewController autorelease];
}

@end

//
//  SettingsRootViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 10/29/23.
//

#import "SettingsRootViewController.hpp"
#import "SettingsViewController.hpp"

__attribute__((objc_direct_members))
@interface SettingsRootViewController () {
    UISplitViewController *_childSplitViewController;
    SettingsViewController *_settingsViewController;
}
@property (retain, nonatomic) UISplitViewController *childSplitViewController;
@property (retain, nonatomic) SettingsViewController *settingsViewController;
@end

@implementation SettingsRootViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit_SettingsRootViewController];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit_SettingsRootViewController];
    }
    
    return self;
}

- (void)dealloc {
    [_childSplitViewController release];
    [_settingsViewController release];
    [super dealloc];
}

- (void)commonInit_SettingsRootViewController __attribute__((objc_direct)) {
    [self setupTabBarItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildSplitViewController];
    [self setupSettingsViewController];
}

- (void)setupTabBarItem __attribute__((objc_direct)) {
    UITabBarItem *tabBarItem = self.tabBarItem;
    tabBarItem.title = @"Settings";
    tabBarItem.image = [UIImage systemImageNamed:@"gearshape"];
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

- (void)setupSettingsViewController __attribute__((objc_direct)) {
    [self.childSplitViewController setViewController:self.settingsViewController forColumn:UISplitViewControllerColumnPrimary];
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

- (SettingsViewController *)settingsViewController __attribute__((objc_direct)) {
    if (_settingsViewController) return _settingsViewController;
    
    SettingsViewController *settingsViewController = [SettingsViewController new];
    
    [_settingsViewController release];
    _settingsViewController = [settingsViewController retain];
    return [settingsViewController autorelease];
}


@end

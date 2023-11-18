//
//  SettingsRootViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 10/29/23.
//

#import "SettingsRootViewController.hpp"
#import "SettingsViewController.hpp"
#import "SettingsLocaleViewController.hpp"
#import "SettingsRegionViewController.hpp"

__attribute__((objc_direct_members))
@interface SettingsRootViewController () <SettingsViewControllerDelegate> {
    UISplitViewController *_childSplitViewController;
    SettingsViewController *_settingsViewController;
    SettingsLocaleViewController *_settingsLocaleViewController;
    SettingsRegionViewController *_settingsRegionViewController;
}
@property (retain, readonly, nonatomic) UISplitViewController *childSplitViewController;
@property (retain, readonly, nonatomic) SettingsViewController *settingsViewController;
@property (retain, readonly, nonatomic) SettingsLocaleViewController *settingsLocaleViewController;
@property (retain, readonly, nonatomic) SettingsRegionViewController *settingsRegionViewController;
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
    [_settingsLocaleViewController release];
    [_settingsRegionViewController release];
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
    SettingsViewController *settingsViewController = self.settingsViewController;
    [self.childSplitViewController setViewController:settingsViewController forColumn:UISplitViewControllerColumnPrimary];
    settingsViewController.navigationController.navigationBar.prefersLargeTitles = YES;
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

- (SettingsViewController *)settingsViewController {
    if (_settingsViewController) return _settingsViewController;
    
    SettingsViewController *settingsViewController = [SettingsViewController new];
    settingsViewController.delegate = self;
    
    [_settingsViewController release];
    _settingsViewController = [settingsViewController retain];
    return [settingsViewController autorelease];
}

- (SettingsLocaleViewController *)settingsLocaleViewController {
    if (_settingsLocaleViewController) return _settingsLocaleViewController;
    
    SettingsLocaleViewController *settingsLocaleViewController = [SettingsLocaleViewController new];
    
    [_settingsLocaleViewController release];
    _settingsLocaleViewController = [settingsLocaleViewController retain];
    return [settingsLocaleViewController autorelease];
}

- (SettingsRegionViewController *)settingsRegionViewController {
    if (_settingsRegionViewController) return _settingsRegionViewController;
    
    SettingsRegionViewController *settingsRegionViewController = [SettingsRegionViewController new];
    
    [_settingsRegionViewController release];
    _settingsRegionViewController = [settingsRegionViewController retain];
    return [settingsRegionViewController autorelease];
}

#pragma mark - SettingsViewControllerDelegate

- (void)settingsViewController:(SettingsViewController *)viewController didSelectItemModel:(SettingsItemModel *)itemModel {
    switch (itemModel.type) {
        case SettingsItemModelTypeLocale: {
            dispatch_async(dispatch_get_main_queue(), ^{
                SettingsLocaleViewController *settingsLocaleViewController = self.settingsLocaleViewController;
                [self.childSplitViewController setViewController:settingsLocaleViewController forColumn:UISplitViewControllerColumnSecondary];
                [settingsLocaleViewController.navigationController setViewControllers:@[settingsLocaleViewController] animated:NO];
            });
            break;
        }
        case SettingsItemModelTypeRegion: {
            dispatch_async(dispatch_get_main_queue(), ^{
                SettingsRegionViewController *settingsRegionViewController = self.settingsRegionViewController;
                [self.childSplitViewController setViewController:settingsRegionViewController forColumn:UISplitViewControllerColumnSecondary];
                [settingsRegionViewController.navigationController setViewControllers:@[settingsRegionViewController] animated:NO];
            });
            break;
        }
        default:
            break;
    }
}

@end

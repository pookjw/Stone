//
//  RegularRootViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 10/28/23.
//

#import "RegularRootViewController.hpp"

__attribute__((objc_direct_members))
@interface RegularRootViewController () {
    UISplitViewController *_childSplitViewController;
}
@property (retain, nonatomic) UISplitViewController *childSplitViewController;
@end

@implementation RegularRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [UILabel new];
    label.text = @"Regular";
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:label];
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
    [label release];
}

- (UIContainerBackgroundStyle)preferredContainerBackgroundStyle {
    return UIContainerBackgroundStyleGlass;
}

- (UISplitViewController *)childSplitViewController __attribute__((objc_direct)) {
    if (_childSplitViewController) return _childSplitViewController;
    
    UISplitViewController *childSplitViewController = [[UISplitViewController alloc] initWithStyle:UISplitViewControllerStyleDoubleColumn];
    childSplitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeOneBesideSecondary;
    childSplitViewController.preferredSplitBehavior = UISplitViewControllerSplitBehaviorTile;
    childSplitViewController.primaryBackgroundStyle = UISplitViewControllerBackgroundStyleSidebar;
    
    _childSplitViewController = [childSplitViewController retain];
    return [childSplitViewController autorelease];
}

@end

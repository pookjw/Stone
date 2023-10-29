//
//  RootViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 10/27/23.
//

#import "RootViewController.hpp"
#import "CompactRootViewController.hpp"
#import "RegularRootViewController.hpp"
#import <objc/message.h>
#import <cmath>

@interface TextViewController : UIViewController
@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleLargeTitle];
    label.text = @"Ornament!";
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:label];
    [NSLayoutConstraint activateConstraints:@[
        [label.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [label.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [label.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [label.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    [label release];
}

- (UIContainerBackgroundStyle)preferredContainerBackgroundStyle {
    return UIContainerBackgroundStyleGlass;
}

@end

__attribute__((objc_direct_members))
@interface RootViewController () {
    CompactRootViewController * _Nullable _compactRootViewController;
    RegularRootViewController * _Nullable _regularRootViewController;
}
@property (retain, readonly, nonatomic) CompactRootViewController * _Nullable compactRootViewController;
@property (retain, readonly, nonatomic) RegularRootViewController * _Nullable regularRootViewController;
@property (retain, readonly, nonatomic) CompactRootViewController * _Nullable compactRootViewController_ifExists;
@property (retain, readonly, nonatomic) RegularRootViewController * _Nullable regularRootViewController_ifExists;
@property (assign, nonatomic) __kindof UIViewController * _Nullable contentViewController;
@property (readonly, nonatomic) UIUserInterfaceSizeClass internal_horizontalSizeClass;
@end

@implementation RootViewController

- (void)dealloc {
    [_compactRootViewController release];
    [_regularRootViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // MRUIOrnamentsItem
    id mrui_ornamentsItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, NSSelectorFromString(@"mrui_ornamentsItem"));
    
    TextViewController *textViewController = [TextViewController new];
    id ornament = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([NSClassFromString(@"MRUIPlatterOrnament") alloc], NSSelectorFromString(@"initWithViewController:"), textViewController);
    [textViewController release];
    reinterpret_cast<void (*)(id, SEL, CGSize)>(objc_msgSend)(ornament, NSSelectorFromString(@"setPreferredContentSize:"), CGSizeMake(400.f, 400.f));
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(mrui_ornamentsItem, NSSelectorFromString(@"setOrnaments:"), @[ornament]);
    
    [ornament release];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateContentViewController];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self updateContentViewControllerWithTransitionCoordinator:coordinator];
}

- (UIViewController *)childViewControllerForPreferredContainerBackgroundStyle {
    return self.contentViewController;
}

- (void)updateContentViewController __attribute__((objc_direct)) {
    [self updateContentViewControllerWithTransitionCoordinator:nil];
}

- (void)updateContentViewControllerWithTransitionCoordinator:(id<UIViewControllerTransitionCoordinator> _Nullable)coordinator __attribute__((objc_direct)) {
    auto horizontalSizeClass = self.internal_horizontalSizeClass;
    
    __kindof UIViewController * _Nullable newContentViewController;
    
    switch (horizontalSizeClass) {
        case UIUserInterfaceSizeClassUnspecified:
            newContentViewController = nil;
            break;
        case UIUserInterfaceSizeClassCompact:
            newContentViewController= self.compactRootViewController;
            break;
        case UIUserInterfaceSizeClassRegular:
            newContentViewController = self.regularRootViewController;
            break;
        default:
            newContentViewController = nil;
            break;
    }
    
    if (!newContentViewController) return;
    
    self.contentViewController = newContentViewController;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.view layoutIfNeeded];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

- (UIUserInterfaceSizeClass)internal_horizontalSizeClass __attribute__((objc_direct)) {
    CGFloat width = self.view.window.frame.size.width;
    
    if (std::islessequal(width, 0.f)) {
        return UIUserInterfaceSizeClassUnspecified;
    } else if (std::isless(self.view.window.frame.size.width, 600.f)) {
        return UIUserInterfaceSizeClassCompact;
    } else {
        return UIUserInterfaceSizeClassRegular;
    }
}

- (__kindof UIViewController *)contentViewController __attribute__((objc_direct)) {
    if ([self.compactRootViewController_ifExists.parentViewController isEqual:self]) {
        return self.compactRootViewController_ifExists;
    } else if ([self.regularRootViewController_ifExists.parentViewController isEqual:self]) {
        return self.regularRootViewController_ifExists;
    } else {
        return nil;
    }
}

- (CompactRootViewController *)compactRootViewController __attribute__((objc_direct)) {
    if (_compactRootViewController) return _compactRootViewController;
    
    CompactRootViewController *compactRootViewController = [CompactRootViewController new];
    _compactRootViewController = [compactRootViewController retain];
    return [compactRootViewController autorelease];
}

- (RegularRootViewController *)regularRootViewController __attribute__((objc_direct)) {
    if (_regularRootViewController) return _regularRootViewController;
    
    RegularRootViewController *regularRootViewController = [RegularRootViewController new];
    _regularRootViewController = [regularRootViewController retain];
    return [regularRootViewController autorelease];
}

- (CompactRootViewController *)compactRootViewController_ifExists __attribute__((objc_direct)) {
    return _compactRootViewController;
}

- (RegularRootViewController *)regularRootViewController_ifExists __attribute__((objc_direct)) {
    return _regularRootViewController;
}

- (void)setContentViewController:(__kindof UIViewController *)contentViewController __attribute__((objc_direct)) {
    auto oldContentViewController = self.contentViewController;
    
    if (oldContentViewController) {
        if ([oldContentViewController isEqual:contentViewController]) {
            return;
        } else {
            [oldContentViewController willMoveToParentViewController:nil];
            [oldContentViewController.view removeFromSuperview];
            [oldContentViewController removeFromParentViewController];
        }
    }
    
    if (contentViewController) {
        [self addChildViewController:contentViewController];
        
        UIView *contentView = contentViewController.view;
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:contentView];
        [NSLayoutConstraint activateConstraints:@[
            [contentView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [contentView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [contentView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [contentView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
        ]];
        
        [contentViewController didMoveToParentViewController:self];
    }
    
    [self setNeedsUpdateOfPreferredContainerBackgroundStyle];
}

@end

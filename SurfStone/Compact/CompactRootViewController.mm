//
//  CompactRootViewController.m
//  SurfStone
//
//  Created by Jinwoo Kim on 10/28/23.
//

#import "CompactRootViewController.hpp"

@interface CompactRootViewController ()

@end

@implementation CompactRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [UILabel new];
    label.text = @"Compact";
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

@end

//
//  SettingsViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 10/29/23.
//

#import "SettingsViewController.hpp"

__attribute__((objc_direct_members))
@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit_SettingsViewController];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit_SettingsViewController];
    }
    
    return self;
}

- (void)commonInit_SettingsViewController __attribute__((objc_direct)) {
    [self setupTabBarItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemGreenColor;
}

- (void)setupTabBarItem __attribute__((objc_direct)) {
    UITabBarItem *tabBarItem = self.tabBarItem;
    tabBarItem.title = @"Settings";
    tabBarItem.image = [UIImage systemImageNamed:@"gearshape"];
}

@end

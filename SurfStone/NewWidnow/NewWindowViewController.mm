//
//  NewWindowViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/19/23.
//

#import "NewWindowViewController.hpp"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NewWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIAction *primaryAction = [UIAction actionWithTitle:@"New Window"
                                                  image:[UIImage systemImageNamed:@"plus"]
                                             identifier:nil
                                                handler:^(__kindof UIAction * _Nonnull action) {
        UISceneSessionActivationRequest *request = [UISceneSessionActivationRequest requestWithRole:UIWindowSceneSessionRoleApplication];
        [UIApplication.sharedApplication activateSceneSessionForRequest:request errorHandler:^(NSError * _Nonnull error) {
            NSLog(@"%@", error); // not called - bug
        }];
    }];
    
    UIButton *button = [[UIButton alloc] initWithFrame:self.view.bounds primaryAction:primaryAction];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:button];
    [NSLayoutConstraint activateConstraints:@[
        [button.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [button.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [button.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [button.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    [button release];
    
    reinterpret_cast<void (*)(id, SEL, long)>(objc_msgSend)(self.view, NSSelectorFromString(@"sws_enablePlatter:"), 8);
}

@end

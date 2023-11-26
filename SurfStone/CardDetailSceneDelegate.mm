//
//  CardDetailSceneDelegate.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/25/23.
//

#import "CardDetailSceneDelegate.hpp"
#import "CardDetailsViewController.hpp"
#import <objc/message.h>

struct __MRUISize3D {
    CGFloat width;
    CGFloat height;
    CGFloat depth;
};

@implementation CardDetailSceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = static_cast<UIWindowScene *>(scene);
    
    // MRUISceneSizeRestrictions
    __kindof UISceneSizeRestrictions *sizeRestrictions = windowScene.sizeRestrictions;
    struct __MRUISize3D size {600.f, 1200.f, 600.f};
    reinterpret_cast<void (*)(id, SEL, __MRUISize3D)>(objc_msgSend)(sizeRestrictions, NSSelectorFromString(@"setMaximumSize3D:"), size);
    reinterpret_cast<void (*)(id, SEL, __MRUISize3D)>(objc_msgSend)(sizeRestrictions, NSSelectorFromString(@"setMinimumSize3D:"), size);
    
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:windowScene];
    CardDetailsViewController *rootViewController = [[CardDetailsViewController alloc] initWithUserActivities:connectionOptions.userActivities];
    window.rootViewController = rootViewController;
    [rootViewController release];
    [window makeKeyAndVisible];
    self.window = window;
    [window release];
}

@end

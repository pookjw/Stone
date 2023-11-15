//
//  SceneDelegate.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 10/27/23.
//

#import "SceneDelegate.hpp"
#import "CardsViewController.hpp"
#import "CardBacksViewController.hpp"
#import "SettingsRootViewController.hpp"
#import <objc/message.h>

@implementation SceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = static_cast<UIWindowScene *>(scene);
    
    windowScene.sizeRestrictions.minimumSize = CGSizeMake(100.f, 100.f);
    windowScene.sizeRestrictions.maximumSize = CGSizeMake(4000.f, 4000.f);
    
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:windowScene];
    
    UITabBarController *tabBarController = [UITabBarController new];
    CardsViewController *cardsViewController = [CardsViewController new];
    CardBacksViewController *cardBacksViewController = [CardBacksViewController new];
    SettingsRootViewController *settingsViewController = [SettingsRootViewController new];
    [tabBarController setViewControllers:@[cardsViewController, cardBacksViewController, settingsViewController] animated:NO];
    [cardsViewController release];
    [cardBacksViewController release];
    [settingsViewController release];
    
    window.rootViewController = tabBarController;
    [tabBarController release];
    [window makeKeyAndVisible];
    self.window = window;
    [window release];
}

@end

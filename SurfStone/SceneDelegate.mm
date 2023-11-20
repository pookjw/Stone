//
//  SceneDelegate.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 10/27/23.
//

#import "SceneDelegate.hpp"
#import "CardsViewController.hpp"
#import "CardBacksRootViewController.hpp"
#import "SettingsRootViewController.hpp"
#import "NewWindowViewController.hpp"
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
    CardBacksRootViewController *cardBacksViewController = [CardBacksRootViewController new];
    SettingsRootViewController *settingsViewController = [SettingsRootViewController new];
    [tabBarController setViewControllers:@[cardsViewController, cardBacksViewController, settingsViewController] animated:NO];
    [cardsViewController release];
    [cardBacksViewController release];
    [settingsViewController release];
    
    //
    
    id mrui_ornamentsItem = reinterpret_cast<id (*) (id, SEL)>(objc_msgSend) (tabBarController, NSSelectorFromString (@"mrui_ornamentsItem"));
    NewWindowViewController *newWindowViewController = [NewWindowViewController new];
    id ornament = reinterpret_cast<id (*) (id, SEL, id)>(objc_msgSend)([NSClassFromString(@"MRUIPlatterOrnament") alloc], NSSelectorFromString(@"initWithViewController:"), newWindowViewController);
    [newWindowViewController release];
    
    reinterpret_cast<void (*) (id, SEL, CGSize)>(objc_msgSend)(ornament, NSSelectorFromString(@"setPreferredContentSize:"), CGSizeMake(400.f, 400.f));
    reinterpret_cast<void (*) (id, SEL, CGPoint)>(objc_msgSend)(ornament, NSSelectorFromString(@"setContentAnchorPoint:"), CGPointMake(0.f, 0.5f));
    reinterpret_cast<void (*) (id, SEL, CGPoint)>(objc_msgSend)(ornament, NSSelectorFromString(@"setSceneAnchorPoint:"), CGPointMake(1.f, 0.5f));
    reinterpret_cast<void (*) (id, SEL, CGFloat)>(objc_msgSend)(ornament, NSSelectorFromString(@"_setZOffset:"), 100.f);
    reinterpret_cast<void (*) (id, SEL, id)>(objc_msgSend)(mrui_ornamentsItem, NSSelectorFromString(@"setOrnaments:"), @[ornament]);
    [ornament release];
    
    //
    
    window.rootViewController = tabBarController;
    [tabBarController release];
    [window makeKeyAndVisible];
    self.window = window;
    [window release];
}

@end

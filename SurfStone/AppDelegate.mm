//
//  AppDelegate.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 10/27/23.
//

#import "AppDelegate.hpp"
#import "SceneDelegate.hpp"
#import "CardDetailSceneDelegate.hpp"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    __block NSUserActivity * _Nullable cardDetailUserActivity = nil;
    
    [options.userActivities enumerateObjectsUsingBlock:^(NSUserActivity * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.activityType isEqualToString:@"com.pookjw.SurfStone.CardDetail"]) {
            cardDetailUserActivity = [[obj retain] autorelease];
            *stop = YES;
        }
    }];
    
    if (cardDetailUserActivity) {
        UISceneConfiguration *configuration = connectingSceneSession.configuration;
        configuration.delegateClass = CardDetailSceneDelegate.class;
        return configuration;
    } else {
        UISceneConfiguration *configuration = connectingSceneSession.configuration;
        configuration.delegateClass = SceneDelegate.class;
        return configuration;
    }
}

@end

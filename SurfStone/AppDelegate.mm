//
//  AppDelegate.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 10/27/23.
//

#import "AppDelegate.hpp"
#import "SceneDelegate.hpp"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    UISceneConfiguration *configuration = [[UISceneConfiguration alloc] initWithName:nil sessionRole:UIWindowSceneSessionRoleApplication];
    configuration.delegateClass = SceneDelegate.class;
    
    return [configuration autorelease];
}

@end

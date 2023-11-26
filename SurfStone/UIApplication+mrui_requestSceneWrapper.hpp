//
//  UIApplication+mrui_requestSceneWrapper.h
//  SurfStone
//
//  Created by Jinwoo Kim on 11/26/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (mrui_requestSceneWrapper)
- (void)mruiw_requestVolumetricSceneWithUserActivity:(NSUserActivity * _Nullable)userActivity completionHandler:(void (^)(NSError * _Nullable error))completionHandler;
- (void)mruiw_requestMixedImmersiveSceneWithUserActivity:(NSUserActivity * _Nullable)userActivity completionHandler:(void (^)(NSError * _Nullable error))completionHandler;
- (void)mruiw_requestProgressiveImmersiveSceneWithUserActivity:(NSUserActivity * _Nullable)userActivity completionHandler:(void (^)(NSError * _Nullable error))completionHandler;
- (void)mruiw_requestFullImmersiveSceneWithUserActivity:(NSUserActivity * _Nullable)userActivity completionHandler:(void (^)(NSError * _Nullable error))completionHandler;
@end

NS_ASSUME_NONNULL_END

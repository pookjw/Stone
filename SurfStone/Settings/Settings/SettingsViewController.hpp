//
//  SettingsViewController.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/16/23.
//

#import <UIKit/UIKit.h>
#import "SettingsItemModel.hpp"

NS_ASSUME_NONNULL_BEGIN

@class SettingsViewController;
@protocol SettingsViewControllerDelegate <NSObject>
@optional - (void)settingsViewController:(SettingsViewController *)viewController didSelectItemModel:(SettingsItemModel *)itemModel;
@end

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) id<SettingsViewControllerDelegate> _Nullable delegate;
@end

NS_ASSUME_NONNULL_END

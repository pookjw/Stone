//
//  SettingsSectionModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/16/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SettingsSectionModelType) {
    SettingsSectionModelTypeAPI
};

__attribute__((objc_direct_members))
@interface SettingsSectionModel : NSObject
@property (readonly, nonatomic) SettingsSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(SettingsSectionModelType)type NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END

//
//  SettingsLocaleSectionModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/19/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SettingsLocaleSectionModelType) {
    SettingsLocaleSectionModelTypeLocales
};

__attribute__((objc_direct_members))
@interface SettingsLocaleSectionModel : NSObject
@property (readonly, nonatomic) SettingsLocaleSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(SettingsLocaleSectionModelType)type NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END

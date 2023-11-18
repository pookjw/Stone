//
//  SettingsRegionSectionModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/18/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SettingsRegionSectionModelType) {
    SettingsRegionSectionModelTypeRegions
};

__attribute__((objc_direct_members))
@interface SettingsRegionSectionModel : NSObject
@property (readonly, nonatomic) SettingsRegionSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(SettingsRegionSectionModelType)type NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END

//
//  SettingsRegionSectionModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/18/23.
//

#import <Foundation/Foundation.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

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

NS_HEADER_AUDIT_END(nullability, sendability)

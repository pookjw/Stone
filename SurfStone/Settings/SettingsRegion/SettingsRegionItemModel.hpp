//
//  SettingsRegionItemModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/18/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SettingsRegionItemModelType) {
    SettingsRegionItemModelTypeRegion
};

extern NSString * const SettingsRegionItemModelRegionIdentifierKey;
extern NSString * const SettingsRegionItemModelIsSelectedKey;

__attribute__((objc_direct_members))
@interface SettingsRegionItemModel : NSObject
@property (readonly, nonatomic) SettingsRegionItemModelType type;
@property (copy) NSDictionary *userInfo;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(SettingsRegionItemModelType)type;
@end

NS_ASSUME_NONNULL_END

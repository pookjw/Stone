//
//  SettingsItemModel.h
//  SurfStone
//
//  Created by Jinwoo Kim on 11/16/23.
//

#import <Foundation/Foundation.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

typedef NS_ENUM(NSUInteger, SettingsItemModelType) {
    SettingsItemModelTypeRegion,
    SettingsItemModelTypeLocale
};

extern NSString * const SettingsItemModelSelectedRegionIdentifierKey;
extern NSString * const SettingsItemModelSelectedLocaleKey;

__attribute__((objc_direct_members))
@interface SettingsItemModel : NSObject
@property (readonly, nonatomic) SettingsItemModelType type;
@property (copy) NSDictionary *userInfo;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(SettingsItemModelType)type;
@end

NS_HEADER_AUDIT_END(nullability, sendability)

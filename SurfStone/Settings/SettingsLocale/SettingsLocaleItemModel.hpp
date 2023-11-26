//
//  SettingsLocaleItemModel.h
//  SurfStone
//
//  Created by Jinwoo Kim on 11/19/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SettingsLocaleItemModelType) {
    SettingsLocaleItemModelTypeLocale
};

extern NSString * const SettingsLocaleItemModelLocaleKey;
extern NSString * const SettingsLocaleItemModelIsSelectedKey;

__attribute__((objc_direct_members))
@interface SettingsLocaleItemModel : NSObject
@property (readonly, nonatomic) SettingsLocaleItemModelType type;
@property (copy) NSDictionary * _Nullable userInfo;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(SettingsLocaleItemModelType)type NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END

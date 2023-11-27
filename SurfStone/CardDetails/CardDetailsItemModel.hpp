//
//  CardDetailsItemModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/27/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardDetailsItemModelType) {
    CardDetailsItemModelTypeText
};

extern NSString * const CardDetailsItemModelTextKey;
extern NSString * const CardDetailsItemModelNameKey;

__attribute__((objc_direct_members))
@interface CardDetailsItemModel : NSObject
@property (readonly, nonatomic) CardDetailsItemModelType type;
@property (copy) NSDictionary * _Nullable userInfo;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(CardDetailsItemModelType)type NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END

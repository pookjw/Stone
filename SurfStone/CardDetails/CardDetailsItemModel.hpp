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

__attribute__((objc_direct_members))
@interface CardDetailsItemModel : NSObject
@property (copy) NSDictionary * _Nullable userInfo;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
// TODO
@end

NS_ASSUME_NONNULL_END

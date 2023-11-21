//
//  CardBacksItemModel.h
//  SurfStone
//
//  Created by Jinwoo Kim on 11/21/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardBacksItemModelType) {
    CardBacksItemModelTypeCardBack
};

extern NSString * const CardBacksItemModelHSCardBackResponseKey;

__attribute__((objc_direct_members))
@interface CardBacksItemModel : NSObject
@property (readonly, nonatomic) CardBacksItemModelType type;
@property (copy) NSDictionary * _Nullable userInfo;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(CardBacksItemModelType)type NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END

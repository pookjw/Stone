//
//  CardBacksOptionsItemModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/19/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardBacksOptionsItemModelType) {
    CardBacksOptionsItemModelTypeTextFilter,
    CardBacksOptionsItemModelTypeCardBackCategory,
    CardBacksOptionsItemModelTypeSort
};

extern NSString * const CardBacksItemModelTextFilterKey;

extern NSString * const CardBacksItemModelSelectedCardBackCategoryKey;
extern NSString * const CardBacksItemModelCardBackCategoriesKey;

extern NSString * const CardBacksItemModelSelectedSortKey;
extern NSString * const CardBacksItemModelSortsKey;

__attribute__((objc_direct_members))
@interface CardBacksOptionsItemModel : NSObject
@property (readonly, nonatomic) CardBacksOptionsItemModelType type;
@property (copy) NSDictionary * _Nullable userInfo;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(CardBacksOptionsItemModelType)type NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END

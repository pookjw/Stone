//
//  CardBacksItemModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/19/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardBacksItemModelType) {
    CardBacksItemModelTypeTextFilter,
    CardBacksItemModelTypeCardBackCategory,
    CardBacksItemModelTypeSort
};

extern NSString * const CardBacksItemModelTextFilterKey;

extern NSString * const CardBacksItemModelSelectedCardBackCategoryKey;
extern NSString * const CardBacksItemModelCardBackCategoriesKey;

extern NSString * const CardBacksItemModelSelectedSortKey;
extern NSString * const CardBacksItemModelSortsKey;

@interface CardBacksItemModel : NSObject
@property (readonly, nonatomic) CardBacksItemModelType type;
@property (copy) NSDictionary * _Nullable userInfo;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(CardBacksItemModelType)type;
@end

NS_ASSUME_NONNULL_END

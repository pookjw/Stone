//
//  CardBacksItemModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/19/23.
//

#import "CardBacksItemModel.hpp"

NSString * const CardBacksItemModelTextFilterKey = @"CardBacksItemModelTextFilterKey";
NSString * const CardBacksItemModelSelectedCardBackCategoryKey = @"CardBacksItemModelSelectedCardBackCategoryKey";
NSString * const CardBacksItemModelCardBackCategoriesKey = @"CardBacksItemModelCardBackCategoriesKey";
NSString * const CardBacksItemModelSelectedSortKey = @"CardBacksItemModelSelectedSortKey";
NSString * const CardBacksItemModelSortsKey = @"CardBacksItemModelSortsKey";

__attribute__((objc_direct_members))
@interface CardBacksItemModel () {
    CardBacksItemModelType _type;
}
@end

@implementation CardBacksItemModel

- (instancetype)initWithType:(CardBacksItemModelType)type {
    if (self = [super init]) {
        _type = type;
    }
    
    return self;
}

- (void)dealloc {
    [_userInfo release];
    [super dealloc];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        auto toCompare = static_cast<CardBacksItemModel *>(other);
        return toCompare->_type == _type;
    }
}

- (NSUInteger)hash {
    return _type;
}

@end

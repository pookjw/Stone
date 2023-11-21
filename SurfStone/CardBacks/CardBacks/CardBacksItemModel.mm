//
//  CardBacksItemModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/21/23.
//

#import "CardBacksItemModel.hpp"

NSString * const CardBacksItemModelHSCardBackResponseKey = @"CardBacksItemModelHSCardBackResponseKey";

__attribute__((objc_direct_members))
@interface CardBacksItemModel ()
@end

@implementation CardBacksItemModel

@synthesize type = _type;

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

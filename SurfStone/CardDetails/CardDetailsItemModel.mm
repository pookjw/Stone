//
//  CardDetailsItemModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/27/23.
//

#import "CardDetailsItemModel.hpp"

NSString * const CardDetailsItemModelTextKey = @"CardDetailsItemModelTextKey";;
NSString * const CardDetailsItemModelNameKey = @"CardDetailsItemModelNameKey";

__attribute__((objc_direct_members))
@interface CardDetailsItemModel ()
@end

@implementation CardDetailsItemModel

@synthesize type = _type;

- (instancetype)initWithType:(CardDetailsItemModelType)type {
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
        auto toCompare = static_cast<CardDetailsItemModel *>(other);
        return toCompare->_type == _type;
    }
}

- (NSUInteger)hash {
    return _type;
}

@end

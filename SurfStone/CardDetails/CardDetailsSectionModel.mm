//
//  CardDetailsSectionModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/27/23.
//

#import "CardDetailsSectionModel.hpp"

__attribute__((objc_direct_members))
@interface CardDetailsSectionModel ()
@end

@implementation CardDetailsSectionModel

@synthesize type = _type;

- (instancetype)initWithType:(CardDetailsSectionModelType)type {
    if (self = [super init]) {
        _type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        auto toCompare = static_cast<CardDetailsSectionModel *>(other);
        return toCompare->_type == _type;
    }
}

- (NSUInteger)hash {
    return _type;
}
@end

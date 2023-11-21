//
//  CardBacksOptionsSectionModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/19/23.
//

#import "CardBacksOptionsSectionModel.hpp"

__attribute__((objc_direct_members))
@interface CardBacksOptionsSectionModel ()
@end

@implementation CardBacksOptionsSectionModel

@synthesize type = _type;

- (instancetype)initWithType:(CardBacksOptionsSectionModelType)type {
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
        auto toCompare = static_cast<CardBacksOptionsSectionModel *>(other);
        return toCompare->_type == _type;
    }
}

- (NSUInteger)hash {
    return _type;
}

@end

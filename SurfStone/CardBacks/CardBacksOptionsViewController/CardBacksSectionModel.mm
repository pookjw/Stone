//
//  CardBacksSectionModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/19/23.
//

#import "CardBacksSectionModel.hpp"

__attribute__((objc_direct_members))
@interface CardBacksSectionModel () {
    CardBacksSectionModelType _type;
}
@end

@implementation CardBacksSectionModel

- (instancetype)initWithType:(CardBacksSectionModelType)type {
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
        auto toCompare = static_cast<CardBacksSectionModel *>(other);
        return toCompare->_type == _type;
    }
}

- (NSUInteger)hash {
    return _type;
}

@end

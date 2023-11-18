//
//  SettingsLocaleSectionModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/19/23.
//

#import "SettingsLocaleSectionModel.hpp"

__attribute__((objc_direct_members))
@interface SettingsLocaleSectionModel () {
    SettingsLocaleSectionModelType _type;
}
@end

@implementation SettingsLocaleSectionModel

- (instancetype)initWithType:(SettingsLocaleSectionModelType)type {
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
        auto toCompare = static_cast<SettingsLocaleSectionModel *>(other);
        return toCompare->_type == _type;
    }
}

- (NSUInteger)hash {
    return _type;
}

@end

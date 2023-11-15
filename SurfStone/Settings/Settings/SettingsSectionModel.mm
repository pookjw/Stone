//
//  SettingsSectionModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/16/23.
//

#import "SettingsSectionModel.hpp"

__attribute__((objc_direct_members))
@interface SettingsSectionModel () {
    SettingsSectionModelType _type;
}
@end

@implementation SettingsSectionModel

- (instancetype)initWithType:(SettingsSectionModelType)type {
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
        auto toCompare = static_cast<SettingsSectionModel *>(other);
        return toCompare->_type == _type;
    }
}

- (NSUInteger)hash {
    return _type;
}

@end

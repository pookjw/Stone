//
//  SettingsRegionSectionModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/18/23.
//

#import "SettingsRegionSectionModel.hpp"

__attribute__((objc_direct_members))
@interface SettingsRegionSectionModel ()
@end

@implementation SettingsRegionSectionModel

@synthesize type = _type;

- (instancetype)initWithType:(SettingsRegionSectionModelType)type {
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
        auto toCompare = static_cast<SettingsRegionSectionModel *>(other);
        return toCompare->_type == _type;
    }
}

- (NSUInteger)hash {
    return _type;
}

@end

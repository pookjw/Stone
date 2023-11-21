//
//  SettingsItemModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/16/23.
//

#import "SettingsItemModel.hpp"

NSString * const SettingsItemModelSelectedRegionIdentifierKey = @"SettingsItemModelSelectedRegionIdentifierKey";
NSString * const SettingsItemModelSelectedLocaleKey = @"SettingsItemModelSelectedLocaleKey";

__attribute__((objc_direct_members))
@interface SettingsItemModel ()
@end

@implementation SettingsItemModel

@synthesize type = _type;

- (instancetype)initWithType:(SettingsItemModelType)type {
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
        auto toCompare = static_cast<SettingsItemModel *>(other);
        return toCompare->_type == _type;
    }
}

- (NSUInteger)hash {
    return _type;
}

@end

//
//  SettingsLocaleItemModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/19/23.
//

#import "SettingsLocaleItemModel.hpp"

NSString * const SettingsLocaleItemModelLocaleKey = @"SettingsLocaleItemModelLocaleKey";
NSString * const SettingsLocaleItemModelIsSelectedKey = @"SettingsLocaleItemModelIsSelectedKey";

__attribute__((objc_direct_members))
@interface SettingsLocaleItemModel () {
    SettingsLocaleItemModelType _type;
}
@end

@implementation SettingsLocaleItemModel

@synthesize type = _type;

- (instancetype)initWithType:(SettingsLocaleItemModelType)type {
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
        auto toCompare = static_cast<SettingsLocaleItemModel *>(other);
        return toCompare->_type == _type;
    }
}

- (NSUInteger)hash {
    return _type;
}

@end

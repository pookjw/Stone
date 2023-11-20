//
//  SettingsRegionItemModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/18/23.
//

#import "SettingsRegionItemModel.hpp"

NSString * const SettingsRegionItemModelRegionIdentifierKey = @"SettingsRegionItemModelRegionIdentifierKey";
NSString * const SettingsRegionItemModelIsSelectedKey = @"SettingsRegionItemModelIsSelectedKey";

__attribute__((objc_direct_members))
@interface SettingsRegionItemModel () {
    SettingsRegionItemModelType _type;
}
@end

@implementation SettingsRegionItemModel

@synthesize type = _type;

- (instancetype)initWithType:(SettingsRegionItemModelType)type {
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
        auto toCompare = static_cast<SettingsRegionItemModel *>(other);
        return toCompare->_type == _type;
    }
}

- (NSUInteger)hash {
    return _type;
}

@end

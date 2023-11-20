//
//  CardBacksOptionsSectionModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/19/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardBacksOptionsSectionModelType) {
    CardBacksOptionsSectionModelTypeOptions
};

__attribute__((objc_direct_members))
@interface CardBacksOptionsSectionModel : NSObject
@property (readonly, nonatomic) CardBacksOptionsSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(CardBacksOptionsSectionModelType)type NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END

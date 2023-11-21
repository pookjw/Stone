//
//  CardBacksSectionModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/21/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardBacksSectionModelType) {
    CardBacksSectionModelTypeCardBacks
};

__attribute__((objc_direct_members))
@interface CardBacksSectionModel : NSObject
@property (readonly, nonatomic) CardBacksSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(CardBacksSectionModelType)type NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END

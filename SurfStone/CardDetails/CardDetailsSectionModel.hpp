//
//  CardDetailsSectionModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/27/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardDetailsSectionModelType) {
    CardDetailsSectionModelTypeName,
    CardDetailsSectionModelTypeText
};

__attribute__((objc_direct_members))
@interface CardDetailsSectionModel : NSObject
@property (readonly, nonatomic) CardDetailsSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(CardDetailsSectionModelType)type;
@end

NS_ASSUME_NONNULL_END

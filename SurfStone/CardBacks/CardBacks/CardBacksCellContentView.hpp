//
//  CardBacksCellContentView.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/21/23.
//

#import <UIKit/UIKit.h>
@import StoneCore;

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_direct_members))
@interface CardBacksCellContentConfiguration : NSObject <UIContentConfiguration>
@property (assign, readonly, nonatomic) CGRect frame;
@property (retain, readonly, nonatomic) HSCardBackResponse *cardBackResponse;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame cardBackResponse:(HSCardBackResponse *)cardBackResponse;
@end

__attribute__((objc_direct_members))
@interface CardBacksCellContentView : UIView <UIContentView>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithConfiguration:(CardBacksCellContentConfiguration *)configuration;
@end

NS_ASSUME_NONNULL_END

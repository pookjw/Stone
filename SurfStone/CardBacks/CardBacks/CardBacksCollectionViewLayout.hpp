//
//  CardBacksCollectionViewLayout.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/21/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardBacksCollectionViewLayout : UICollectionViewCompositionalLayout
- (instancetype)initWithSection:(NSCollectionLayoutSection *)section NS_UNAVAILABLE;
- (instancetype)initWithSection:(NSCollectionLayoutSection *)section configuration:(UICollectionViewCompositionalLayoutConfiguration *)configuration NS_UNAVAILABLE;
- (instancetype)initWithSectionProvider:(UICollectionViewCompositionalLayoutSectionProvider)sectionProvider NS_UNAVAILABLE;
- (instancetype)initWithSectionProvider:(UICollectionViewCompositionalLayoutSectionProvider)sectionProvider configuration:(UICollectionViewCompositionalLayoutConfiguration *)configuration NS_UNAVAILABLE;
- (instancetype)init;
+ (instancetype)new;
@end

NS_ASSUME_NONNULL_END

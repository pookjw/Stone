//
//  CardBacksCollectionViewLayout.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/21/23.
//

#import "CardBacksCollectionViewLayout.hpp"
#import <cstdint>
#import <cmath>
#import <functional>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation CardBacksCollectionViewLayout
#pragma clang diagnostic pop

- (instancetype)init {
    return [self commonInit_CardBacksCollectionViewLayout];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    return [self commonInit_CardBacksCollectionViewLayout];
}

- (instancetype)commonInit_CardBacksCollectionViewLayout __attribute__((objc_direct, ns_returns_retained)) {
    UICollectionViewCompositionalLayoutConfiguration *configuration = [UICollectionViewCompositionalLayoutConfiguration new];
    configuration.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    id result = [super initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment>  _Nonnull layoutEnvironment) {
        NSLog(@"%@", layoutEnvironment);
        auto quotient = static_cast<std::uint8_t>(std::floorf(layoutEnvironment.container.effectiveContentSize.width / 200.f));
        auto count = std::less<std::uint8_t>()(quotient, 2) ? 2 : quotient;
        auto count_f = static_cast<CGFloat>(count);
        
        auto itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.f / count_f]
                                                       heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.f]];
        
        auto item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
        
        auto groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.f]
                                                        heightDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.5f / count_f]];
        
        auto group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize repeatingSubitem:item count:count];
        
        auto section = [NSCollectionLayoutSection sectionWithGroup:group];
        
        return section;
    }
                            configuration:configuration];
    
    [configuration release];
    
    return result;
}

@end

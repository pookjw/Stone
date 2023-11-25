//
//  CardBacksViewController.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/21/23.
//

#import <UIKit/UIKit.h>
@import StoneCore;

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_direct_members))
@interface CardBacksViewController : UIViewController
- (void)loadWithTextFilter:(NSString * _Nullable)textFilter cardBackCategorySlug:(NSString * _Nullable)slug sort:(HSCardBacksSortRequest)sort;
@end

NS_ASSUME_NONNULL_END

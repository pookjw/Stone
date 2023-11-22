//
//  CardBacksOptionsViewController.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/4/23.
//

#import <UIKit/UIKit.h>
@import StoneCore;

NS_ASSUME_NONNULL_BEGIN

@class CardBacksOptionsViewController;
@protocol CardBacksOptionsViewControllerDelegate <NSObject>
@optional - (void)cardBacksOptionsViewController:(CardBacksOptionsViewController *)viewController doneWithText:(NSString * _Nullable)text cardBackCategorySlug:(NSString * _Nullable)slug sort:(HSCardBacksSortRequest)sort;
@end

@interface CardBacksOptionsViewController : UIViewController
@property (weak, nonatomic) id<CardBacksOptionsViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

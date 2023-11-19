//
//  CardBacksOptionsViewModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/4/23.
//

#import <UIKit/UIKit.h>
#import <functional>
#import <mutex>
#import "CardBacksSectionModel.hpp"
#import "CardBacksItemModel.hpp"
@import StoneCore;

NS_ASSUME_NONNULL_BEGIN

class CardBacksOptionsViewModel {
    CardBacksOptionsViewModel();
    ~CardBacksOptionsViewModel();
    CardBacksOptionsViewModel(const CardBacksOptionsViewModel&) = delete;
    CardBacksOptionsViewModel& operator=(const CardBacksOptionsViewModel&) = delete;
    
    void load(std::function<void ()> completionHandler);
private:
    HearthstoneAPIService *_apiService;
    NSProgress * _Nullable _cardBackCategoriesMetadataProgress;
};

NS_ASSUME_NONNULL_END

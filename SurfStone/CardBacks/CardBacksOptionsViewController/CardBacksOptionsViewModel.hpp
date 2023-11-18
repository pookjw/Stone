//
//  CardBacksOptionsViewModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/4/23.
//

#import <UIKit/UIKit.h>
#import "HearthstoneAPIService+Macro.hpp"

NS_ASSUME_NONNULL_BEGIN

class CardBacksOptionsViewModel {
    CardBacksOptionsViewModel();
    ~CardBacksOptionsViewModel();
private:
    HearthstoneAPIService *apiService;
};

NS_ASSUME_NONNULL_END

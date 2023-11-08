//
//  CardBacksOptionsViewModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/4/23.
//

#import <UIKit/UIKit.h>
#import "HearthstoneAPIService+Macro.hpp"

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

class CardBacksOptionsViewModel {
    CardBacksOptionsViewModel();
    ~CardBacksOptionsViewModel();
private:
    HearthstoneAPIService *apiService;
};

NS_HEADER_AUDIT_END(nullability, sendability)

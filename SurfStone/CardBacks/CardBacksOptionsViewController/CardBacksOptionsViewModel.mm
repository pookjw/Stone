//
//  CardBacksOptionsViewModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/4/23.
//

#import "CardBacksOptionsViewModel.hpp"
#import "HearthstoneAPIService+Macro.hpp"

CardBacksOptionsViewModel::CardBacksOptionsViewModel() {
    
}

CardBacksOptionsViewModel::~CardBacksOptionsViewModel() {
    [_cardBackCategoriesMetadataProgress cancel];
    [_cardBackCategoriesMetadataProgress release];
    [_apiService release];
}

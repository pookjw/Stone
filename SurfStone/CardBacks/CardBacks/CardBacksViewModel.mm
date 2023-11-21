//
//  CardBacksViewModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/21/23.
//

#import "CardBacksViewModel.hpp"

CardBacksViewModel::CardBacksViewModel(UICollectionViewDiffableDataSource<CardBacksSectionModel *, CardBacksItemModel *> *dataSource) : _dataSource([dataSource retain]), _apiService([HearthstoneAPIService new]) {
    
}

CardBacksViewModel::~CardBacksViewModel() {
    dispatch_release(_queue);
    [_dataSource release];
    [_apiService release];
}

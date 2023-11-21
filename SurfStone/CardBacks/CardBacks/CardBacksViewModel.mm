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

//void CardBacksViewModel::load(std::function<void ()> completionHandler) -> NSProgress * {
//    auto currentRequestProgress = _requestProgress;
//    auto dataSource = _dataSource;
//    auto queue = _queue;
//    
//    dispatch_async(queue, ^{
//        [_requestProgress cancel];
//        [_]
//    });
//}

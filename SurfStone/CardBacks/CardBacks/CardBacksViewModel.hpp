//
//  CardBacksViewModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/21/23.
//

#import <UIKit/UIKit.h>
#import <memory>
#import "CardBacksSectionModel.hpp"
#import "CardBacksItemModel.hpp"
@import StoneCore;

NS_ASSUME_NONNULL_BEGIN

class CardBacksViewModel {
public:
    CardBacksViewModel(UICollectionViewDiffableDataSource<CardBacksSectionModel *, CardBacksItemModel *> *dataSource);
    ~CardBacksViewModel();
    CardBacksViewModel(const CardBacksViewModel&) = delete;
    CardBacksViewModel& operator=(const CardBacksViewModel&) = delete;
    
    NSProgress * load(std::shared_ptr<CardBacksViewModel> ref);
private:
    HearthstoneAPIService * const _apiService;
    UICollectionViewDiffableDataSource<CardBacksSectionModel *, CardBacksItemModel *> * const _dataSource;
    dispatch_queue_t _queue;
    
    void appendHSCardBacksResponse(HSCardBacksResponse *response);
};

NS_ASSUME_NONNULL_END

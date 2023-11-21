//
//  CardBacksViewModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/21/23.
//

#import <UIKit/UIKit.h>
#import <functional>
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
    
    void load(std::function<void ()> completionHandler);
private:
    HearthstoneAPIService * const _apiService;
    UICollectionViewDiffableDataSource<CardBacksSectionModel *, CardBacksItemModel *> * const _dataSource;
    dispatch_queue_t _queue;
};

NS_ASSUME_NONNULL_END

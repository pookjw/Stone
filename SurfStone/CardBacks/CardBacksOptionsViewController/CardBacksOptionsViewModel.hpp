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
public:
    CardBacksOptionsViewModel(UICollectionViewDiffableDataSource<CardBacksSectionModel *, CardBacksItemModel *> *dataSource);
    ~CardBacksOptionsViewModel();
    CardBacksOptionsViewModel(const CardBacksOptionsViewModel&) = delete;
    CardBacksOptionsViewModel& operator=(const CardBacksOptionsViewModel&) = delete;
    
    void load(std::function<void ()> completionHandler);
private:
    HearthstoneAPIService * const _apiService;
    NSProgress * _Nullable _cardBackCategoriesMetadataProgress;
    UICollectionViewDiffableDataSource<CardBacksSectionModel *, CardBacksItemModel *> * const _dataSource;
    dispatch_queue_t _queue;
    BOOL _isLoaded;
    std::mutex _mutex;
    
    static void setupInitialDataSource(UICollectionViewDiffableDataSource<CardBacksSectionModel *, CardBacksItemModel *> *dataSource);
    void requestCardBackCategoryResponses();
};

NS_ASSUME_NONNULL_END

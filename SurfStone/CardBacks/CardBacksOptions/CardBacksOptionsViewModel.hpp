//
//  CardBacksOptionsViewModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/4/23.
//

#import <UIKit/UIKit.h>
#import <memory>
#import "CardBacksOptionsSectionModel.hpp"
#import "CardBacksOptionsItemModel.hpp"
@import StoneCore;

NS_ASSUME_NONNULL_BEGIN

class CardBacksOptionsViewModel {
public:
    CardBacksOptionsViewModel(UICollectionViewDiffableDataSource<CardBacksOptionsSectionModel *, CardBacksOptionsItemModel *> *dataSource);
    ~CardBacksOptionsViewModel();
    CardBacksOptionsViewModel(const CardBacksOptionsViewModel&) = delete;
    CardBacksOptionsViewModel& operator=(const CardBacksOptionsViewModel&) = delete;
    
    NSProgress * load(std::shared_ptr<CardBacksOptionsViewModel> ref);
    void inputDataWithCompletionHandler(std::shared_ptr<CardBacksOptionsViewModel> ref, void (^)(NSString * _Nullable text, NSString * _Nullable categorySlug, HSCardBacksSortRequest sort));
private:
    HearthstoneAPIService * const _apiService;
    UICollectionViewDiffableDataSource<CardBacksOptionsSectionModel *, CardBacksOptionsItemModel *> * const _dataSource;
    dispatch_queue_t _queue;
    
    void setupInitialDataSource();
    NSProgress * requestCardBackCategoryResponses(std::shared_ptr<CardBacksOptionsViewModel> ref);
};

NS_ASSUME_NONNULL_END

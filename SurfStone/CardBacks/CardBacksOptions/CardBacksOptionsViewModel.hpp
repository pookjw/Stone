//
//  CardBacksOptionsViewModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/4/23.
//

#import <UIKit/UIKit.h>
#import <memory>
#import <functional>
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
    CardBacksOptionsItemModel * _Nullable unsafe_iteModelFromIndexPath(NSIndexPath *indexPath);
    void inputDataWithCompletionHandler(std::shared_ptr<CardBacksOptionsViewModel> ref, void (^)(NSString * _Nullable text, NSString * _Nullable categorySlug, HSCardBacksSortRequest sort));
    void textFilterWithCompletionHandler(std::shared_ptr<CardBacksOptionsViewModel> ref, void (^)(NSString * _Nullable text));
    
    void updateTextFilter(std::shared_ptr<CardBacksOptionsViewModel> ref, NSString * _Nullable text, std::function<void ()> completionHandler);
    void updateSelectedCardBackCategory(std::shared_ptr<CardBacksOptionsViewModel> ref, HSCardBackCategoryResponse * _Nullable response, std::function<void ()> completionHandler);
    void updateSelectedSortKey(std::shared_ptr<CardBacksOptionsViewModel> ref, HSCardBacksSortRequest sort, std::function<void ()> completionHandler);
private:
    HearthstoneAPIService * const _apiService;
    UICollectionViewDiffableDataSource<CardBacksOptionsSectionModel *, CardBacksOptionsItemModel *> * const _dataSource;
    dispatch_queue_t _queue;
    
    void setupInitialDataSource();
    NSProgress * requestCardBackCategoryResponses(std::shared_ptr<CardBacksOptionsViewModel> ref);
};

NS_ASSUME_NONNULL_END

//
//  SettingsLocaleViewModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/18/23.
//

#import <UIKit/UIKit.h>
#import <functional>
#import <memory>
#import "SettingsLocaleSectionModel.hpp"
#import "SettingsLocaleItemModel.hpp"

NS_ASSUME_NONNULL_BEGIN

class SettingsLocaleViewModel {
public:
    SettingsLocaleViewModel(UICollectionViewDiffableDataSource<SettingsLocaleSectionModel *, SettingsLocaleItemModel *> *dataSource);
    ~SettingsLocaleViewModel();
    SettingsLocaleViewModel(const SettingsLocaleViewModel&) = delete;
    SettingsLocaleViewModel& operator=(const SettingsLocaleViewModel&) = delete;
    
    void load(std::shared_ptr<SettingsLocaleViewModel> ref, std::function<void ()> completionHandler);
    void handleSelectionForIndexPath(NSIndexPath *indexPath, std::function<void ()> completionHandler);
private:
    UICollectionViewDiffableDataSource<SettingsLocaleSectionModel *, SettingsLocaleItemModel *> * const _dataSource;
    dispatch_queue_t _queue;
    id<NSObject> _localeForAPIObserver;
    
    void setupInitialDataSource();
    void reconfigureWithSelectedLocale(NSLocale * _Nullable selectedLocale);
    void startObserving(std::shared_ptr<SettingsLocaleViewModel> ref);
};

NS_ASSUME_NONNULL_END

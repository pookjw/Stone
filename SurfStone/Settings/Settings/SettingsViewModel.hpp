//
//  SettingsViewModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/16/23.
//

#import <UIKit/UIKit.h>
#import <functional>
#import <memory>
#import "SettingsSectionModel.hpp"
#import "SettingsItemModel.hpp"

NS_ASSUME_NONNULL_BEGIN

class SettingsViewModel {
public:
    SettingsViewModel(UICollectionViewDiffableDataSource<SettingsSectionModel *, SettingsItemModel *> *dataSource);
    ~SettingsViewModel();
    SettingsViewModel(const SettingsViewModel&) = delete;
    SettingsViewModel& operator=(const SettingsViewModel&) = delete;
    
    void load(std::shared_ptr<SettingsViewModel> ref, std::function<void ()> completionHandler);
    SettingsSectionModel * _Nullable unsafe_sectionModelFromIndexPath(NSIndexPath *indexPath);
    void itemModelFromIndexPath(NSIndexPath *indexPath, std::function<void (SettingsItemModel * _Nullable)> completionHandler);
private:
    UICollectionViewDiffableDataSource<SettingsSectionModel *, SettingsItemModel *> * const _dataSource;
    dispatch_queue_t _queue;
    id<NSObject> _regionIdentifierForAPIObserver;
    id<NSObject> _localeForAPIObserver;
    
    std::pair<SettingsSectionModel *, BOOL> appendSectionIntoSnapshotIfNeeded(SettingsSectionModelType type, NSDiffableDataSourceSnapshot<SettingsSectionModel *, SettingsItemModel *> *snapshot);
    SettingsItemModel * _Nullable itemFromSnapshotUsingType(SettingsItemModelType type, NSDiffableDataSourceSnapshot<SettingsSectionModel *, SettingsItemModel *> *snapshot);
    
    void setupInitialDataSource(std::function<void ()> completionHandler);
    void startObserving();
};

NS_ASSUME_NONNULL_END

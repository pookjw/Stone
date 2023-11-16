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

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

class SettingsViewModel {
public:
    SettingsViewModel(UICollectionViewDiffableDataSource<SettingsSectionModel *, SettingsItemModel *> *dataSource);
    ~SettingsViewModel();
    SettingsViewModel(const SettingsViewModel&) = delete;
    SettingsViewModel& operator=(const SettingsViewModel&) = delete;
    
    void load(std::function<void ()> completion);
private:
    UICollectionViewDiffableDataSource<SettingsSectionModel *, SettingsItemModel *> * const _dataSource;
    dispatch_queue_t _queue;
    id<NSObject> _regionIdentifierForAPIObserver;
    id<NSObject> _localeForAPIObserver;
    std::shared_ptr<BOOL> const _isLoaded;
    
    SettingsSectionModel * appendSectionIntoSnapshotIfNeeded(SettingsSectionModelType type,  NSDiffableDataSourceSnapshot<SettingsSectionModel *, SettingsItemModel *> *snapshot);
};

NS_HEADER_AUDIT_END(nullability, sendability)

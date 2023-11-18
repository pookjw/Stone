//
//  SettingsRegionViewModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/18/23.
//

#import <UIKit/UIKit.h>
#import <functional>
#import <memory>
#import "SettingsRegionSectionModel.hpp"
#import "SettingsRegionItemModel.hpp"

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

class SettingsRegionViewModel {
public:
    SettingsRegionViewModel(UICollectionViewDiffableDataSource<SettingsRegionSectionModel *, SettingsRegionItemModel *> *dataSource);
    ~SettingsRegionViewModel();
    SettingsRegionViewModel(const SettingsRegionViewModel&) = delete;
    SettingsRegionViewModel& operator=(const SettingsRegionViewModel&) = delete;
    
    void load(std::function<void ()> completionHandler);
private:
    UICollectionViewDiffableDataSource<SettingsRegionSectionModel *, SettingsRegionItemModel *> * const _dataSource;
    dispatch_queue_t _queue;
    id<NSObject> _regionIdentifierForAPIObserver;
    std::shared_ptr<BOOL> const _isLoaded;
};

NS_HEADER_AUDIT_END(nullability, sendability)

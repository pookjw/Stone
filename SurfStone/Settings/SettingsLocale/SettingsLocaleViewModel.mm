//
//  SettingsLocaleViewModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/18/23.
//

#import "SettingsLocaleViewModel.hpp"
@import StoneCore;

SettingsLocaleViewModel::SettingsLocaleViewModel(UICollectionViewDiffableDataSource<SettingsLocaleSectionModel *, SettingsLocaleItemModel *> *dataSource) : _dataSource([dataSource retain]), _isLoaded(std::make_shared<BOOL>(NO)) {
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, QOS_MIN_RELATIVE_PRIORITY);
    _queue = dispatch_queue_create("SettingsLocaleViewModel", attr);
}

SettingsLocaleViewModel::~SettingsLocaleViewModel() {
    dispatch_release(_queue);
    [_localeForAPIObserver release];
    [_dataSource release];
}

void SettingsLocaleViewModel::load(std::function<void ()> completionHandler) {
    auto settingsService = SettingsService.sharedInstance;
    auto dataSource = _dataSource;
    auto queue = _queue;
    auto isLoaded = _isLoaded;
    
    dispatch_async(queue, ^{
        if (*isLoaded.get()) return;
        
        //
        
//        auto snapshot = [NSDiffableDataSourceSnapshot<SettingsLocaleSectionModel *, SettingsLocaleItemModel *> new];
        
        *isLoaded.get() = YES;
    });
}

void SettingsLocaleViewModel::handleSelectionForIndexPath(NSIndexPath * _Nonnull indexPath, std::function<void ()> completionHandler) {
    
}

void SettingsLocaleViewModel::reconfigureWithSelectedLocale(NSString * _Nullable selectedRegionIdentifier, UICollectionViewDiffableDataSource<SettingsLocaleSectionModel *,SettingsLocaleItemModel *> * _Nonnull dataSource) {
    
}

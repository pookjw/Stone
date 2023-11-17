//
//  SettingsViewModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/16/23.
//

#import "SettingsViewModel.hpp"
@import StoneCore;

SettingsViewModel::SettingsViewModel(UICollectionViewDiffableDataSource<SettingsSectionModel *, SettingsItemModel *> *dataSource) : _dataSource([dataSource retain]), _isLoaded(std::make_shared<BOOL>(NO)) {
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, QOS_MIN_RELATIVE_PRIORITY);
    _queue = dispatch_queue_create("SettingsViewModel", attr);
}

SettingsViewModel::~SettingsViewModel() {
    [_regionIdentifierForAPIObserver release];
    [_localeForAPIObserver release];
    dispatch_release(_queue);
    [_dataSource release];
}

void SettingsViewModel::load(std::function<void ()> completion) {
    auto settingsService = SettingsService.sharedInstance;
    auto dataSource = _dataSource;
    auto queue = _queue;
    auto isLoaded = _isLoaded;
    
    // TODO: seperate with static methods
    
    dispatch_async(queue, ^{
        if (*isLoaded.get()) return;
        
        [settingsService regionIdentifierForAPIWithCompletionHandler:^(NSString * _Nullable result) {
            dispatch_async(queue, ^{
                NSDiffableDataSourceSnapshot<SettingsSectionModel *, SettingsItemModel *> *snapshot = [dataSource.snapshot copy];
                
                SettingsSectionModel *sectionModel = appendSectionIntoSnapshotIfNeeded(SettingsSectionModelTypeAPI, snapshot).first;
                
                SettingsItemModel *itemModel = [[SettingsItemModel alloc] initWithType:SettingsItemModelTypeRegion];
                
                id value;
                if (result) {
                    value = result;
                } else {
                    value = [NSNull null];
                }
                
                itemModel.userInfo = @{SettingsItemModelSelectedRegionIdentifierKey: value};
                
                [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
                [itemModel release];
                
                [dataSource applySnapshot:snapshot animatingDifferences:YES];
                [snapshot release];
            });
        }];
        
        [settingsService localeForAPIWithCompletionHandler:^(NSLocale * _Nullable result) {
            dispatch_async(queue, ^{
                NSDiffableDataSourceSnapshot<SettingsSectionModel *, SettingsItemModel *> *snapshot = [dataSource.snapshot copy];
                
                SettingsSectionModel *sectionModel = appendSectionIntoSnapshotIfNeeded(SettingsSectionModelTypeAPI, snapshot).first;
                
                SettingsItemModel *itemModel = [[SettingsItemModel alloc] initWithType:SettingsItemModelTypeLocale];
                
                id value;
                if (result) {
                    value = result;
                } else {
                    value = [NSNull null];
                }
                
                itemModel.userInfo = @{SettingsItemModelSelectedLocaleKey: value};
                
                [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
                [itemModel release];
                
                [dataSource applySnapshot:snapshot animatingDifferences:YES];
                [snapshot release];
            });
        }];
        
        NSOperationQueue *operationQueue = [NSOperationQueue new];
        operationQueue.underlyingQueue = queue;
        
        _regionIdentifierForAPIObserver = [[NSNotificationCenter.defaultCenter addObserverForName:SettingsService.regionIdentifierForAPIDidChangeNotification object:settingsService queue:operationQueue usingBlock:^(NSNotification * _Nonnull notification) {
            NSDiffableDataSourceSnapshot<SettingsSectionModel *, SettingsItemModel *> *snapshot = [dataSource.snapshot copy];
            auto itemModel = itemFromSnapshotUsingType(SettingsItemModelTypeRegion, snapshot);
            
            if (!itemModel) {
                [snapshot release];
                return;
            }
            
            id value = notification.userInfo[SettingsService.changedObjectKey];
            if (!value) {
                value = [NSNull null];
            }
            
            itemModel.userInfo = @{SettingsItemModelSelectedRegionIdentifierKey: value};
            [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
            
            [dataSource applySnapshot:snapshot animatingDifferences:YES];
            [snapshot release];
        }] retain];
        
        _localeForAPIObserver = [[NSNotificationCenter.defaultCenter addObserverForName:SettingsService.localeForAPIForAPIDidChangeNotification object:settingsService queue:operationQueue usingBlock:^(NSNotification * _Nonnull notification) {
            // TODO
        }] retain];
        
        *isLoaded.get() = YES;
    });
}

std::pair<SettingsSectionModel *, BOOL> SettingsViewModel::appendSectionIntoSnapshotIfNeeded(SettingsSectionModelType type, NSDiffableDataSourceSnapshot<SettingsSectionModel *,SettingsItemModel *> * _Nonnull snapshot) {
    __block SettingsSectionModel * _Nullable existing = nil;
    [snapshot.sectionIdentifiers enumerateObjectsUsingBlock:^(SettingsSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == type) {
            existing = obj;
            *stop = YES;
        }
    }];
    
    if (existing) {
        return {[[existing retain] autorelease], NO};
    }
    
    SettingsSectionModel *sectionModel = [[SettingsSectionModel alloc] initWithType:type];
    [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
    
    return {[sectionModel autorelease], YES};
}

SettingsItemModel * _Nullable SettingsViewModel::itemFromSnapshotUsingType(SettingsItemModelType type, NSDiffableDataSourceSnapshot<SettingsSectionModel *,SettingsItemModel *> * _Nonnull snapshot) {
    __block SettingsItemModel * _Nullable existing = nil;
    [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(SettingsItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == type) {
            existing = obj;
            *stop = YES;
        }
    }];
    
    return [[existing retain] autorelease];
}

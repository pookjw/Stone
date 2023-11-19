//
//  SettingsViewModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/16/23.
//

#import "SettingsViewModel.hpp"
@import StoneCore;

SettingsViewModel::SettingsViewModel(UICollectionViewDiffableDataSource<SettingsSectionModel *, SettingsItemModel *> *dataSource) : _dataSource([dataSource retain]), _isLoaded(NO) {
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, QOS_MIN_RELATIVE_PRIORITY);
    _queue = dispatch_queue_create("SettingsViewModel", attr);
}

SettingsViewModel::~SettingsViewModel() {
    dispatch_release(_queue);
    [_regionIdentifierForAPIObserver release];
    [_localeForAPIObserver release];
    [_dataSource release];
}

void SettingsViewModel::load(std::function<void ()> completionHandler) {
    _mutex.lock();
    
    if (_isLoaded) {
        _mutex.unlock();
        return;
    }
    
    auto dataSource = _dataSource;
    auto queue = _queue;
    
    dispatch_async(queue, ^{
        setupInitialDataSource(dataSource, queue, completionHandler);
    });
    
    startObserving();
    
    //
    
    _isLoaded = YES;
    _mutex.unlock();
}

SettingsSectionModel * _Nullable SettingsViewModel::unsafe_sectionModelFromIndexPath(NSIndexPath * _Nonnull indexPath) {
    return [_dataSource sectionIdentifierForIndex:indexPath.section];
}

void SettingsViewModel::itemModelFromIndexPath(NSIndexPath * _Nonnull indexPath, std::function<void (SettingsItemModel * _Nullable)> completionHandler) {
    auto dataSource = _dataSource;
    
    dispatch_async(_queue, ^{
        auto itemModel = [dataSource itemIdentifierForIndexPath:indexPath];
        completionHandler(itemModel);
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

void SettingsViewModel::setupInitialDataSource(UICollectionViewDiffableDataSource<SettingsSectionModel *,SettingsItemModel *> * _Nonnull dataSource, dispatch_queue_t  _Nonnull queue, std::function<void ()> completionHandler) {
    __block NSUInteger count = 0;
    
    [SettingsService.sharedInstance regionIdentifierForAPIWithCompletionHandler:^(NSString * _Nullable result) {
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
            
            if (++count == 2) {
                completionHandler();
            }
        });
    }];
    
    [SettingsService.sharedInstance localeForAPIWithCompletionHandler:^(NSLocale * _Nullable result) {
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
            
            if (++count == 2) {
                completionHandler();
            }
        });
    }];
}

void SettingsViewModel::startObserving() {
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    operationQueue.underlyingQueue = _queue;
    
    auto dataSource = _dataSource;
    
    id regionIdentifierForAPIObserver = [NSNotificationCenter.defaultCenter addObserverForName:SettingsService.regionIdentifierForAPIDidChangeNotification
                                                                                        object:SettingsService.sharedInstance
                                                                                         queue:operationQueue
                                                                                    usingBlock:^(NSNotification * _Nonnull notification) {
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
    }];
    
    id localeForAPIObserver = [[NSNotificationCenter.defaultCenter addObserverForName:SettingsService.localeForAPIForAPIDidChangeNotification
                                                                               object:SettingsService.sharedInstance
                                                                                queue:operationQueue
                                                                           usingBlock:^(NSNotification * _Nonnull notification) {
        NSDiffableDataSourceSnapshot<SettingsSectionModel *, SettingsItemModel *> *snapshot = [dataSource.snapshot copy];
        auto itemModel = itemFromSnapshotUsingType(SettingsItemModelTypeLocale, snapshot);
        
        if (!itemModel) {
            [snapshot release];
            return;
        }
        
        id value = notification.userInfo[SettingsService.changedObjectKey];
        if (!value) {
            value = [NSNull null];
        }
        
        itemModel.userInfo = @{SettingsItemModelSelectedLocaleKey: value};
        [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
        
        [dataSource applySnapshot:snapshot animatingDifferences:YES];
        [snapshot release];
    }] retain];
    
    //
    
    [_regionIdentifierForAPIObserver release];
    _regionIdentifierForAPIObserver = [regionIdentifierForAPIObserver retain];
    
    [_localeForAPIObserver release];
    _localeForAPIObserver = [localeForAPIObserver retain];
    
    [operationQueue release];
}

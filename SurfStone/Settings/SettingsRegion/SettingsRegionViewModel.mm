//
//  SettingsRegionViewModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/18/23.
//

#import "SettingsRegionViewModel.hpp"
@import StoneCore;

SettingsRegionViewModel::SettingsRegionViewModel(UICollectionViewDiffableDataSource<SettingsRegionSectionModel *, SettingsRegionItemModel *> *dataSource) : _dataSource([dataSource retain]), _isLoaded(std::make_shared<BOOL>(NO)) {
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, QOS_MIN_RELATIVE_PRIORITY);
    _queue = dispatch_queue_create("SettingsRegionViewModel", attr);
}

SettingsRegionViewModel::~SettingsRegionViewModel() {
    dispatch_release(_queue);
    [_regionIdentifierForAPIObserver release];
    [_dataSource release];
}

void SettingsRegionViewModel::load(std::function<void ()> completionHandler) {
    auto settingsService = SettingsService.sharedInstance;
    auto dataSource = _dataSource;
    auto queue = _queue;
    auto isLoaded = _isLoaded;
    
    dispatch_async(queue, ^{
        if (*isLoaded.get()) return;
        
        //
        
        auto snapshot = [NSDiffableDataSourceSnapshot<SettingsRegionSectionModel *, SettingsRegionItemModel *> new];
        
        SettingsRegionSectionModel *sectionModel = [[SettingsRegionSectionModel alloc] initWithType:SettingsRegionSectionModelTypeRegions];
        [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
        
        auto itemModels = [NSMutableArray<SettingsRegionItemModel *> new];
        [settingsService.availableRegionIdentifiersForAPI enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            SettingsRegionItemModel *itemModel = [[SettingsRegionItemModel alloc] initWithType:SettingsRegionItemModelTypeRegion];
            itemModel.userInfo = @{
                SettingsRegionItemModelRegionIdentifierKey: obj,
                SettingsRegionItemModelIsSelectedKey: @NO
            };
            
            [itemModels addObject:itemModel];
            [itemModel release];
        }];
        
        [snapshot appendItemsWithIdentifiers:itemModels intoSectionWithIdentifier:sectionModel];
        [sectionModel release];
        [itemModels release];
        
        [dataSource applySnapshot:snapshot animatingDifferences:YES];
        [snapshot release];
        
        //
        
        [settingsService regionIdentifierForAPIWithCompletionHandler:^(NSString * _Nullable result) {
            dispatch_async(queue, ^{
                reconfigureWithSelectedRegionIdentifier(result, dataSource);
                completionHandler();
            });
        }];
        
        //
        
        NSOperationQueue *operationQueue = [NSOperationQueue new];
        operationQueue.underlyingQueue = queue;
        
        _regionIdentifierForAPIObserver = [[NSNotificationCenter.defaultCenter addObserverForName:SettingsService.regionIdentifierForAPIDidChangeNotification object:settingsService queue:operationQueue usingBlock:^(NSNotification * _Nonnull notification) {
            id value = notification.userInfo[SettingsService.changedObjectKey];
            reconfigureWithSelectedRegionIdentifier(value, dataSource);
        }] retain];
        
        [operationQueue release];
        
        *isLoaded.get() = YES;
    });
}

void SettingsRegionViewModel::handleSelectionForIndexPath(NSIndexPath * _Nonnull indexPath, std::function<void ()> completionHandler) {
    auto dataSource = _dataSource;
    
    dispatch_async(_queue, ^{
        auto itemModel = [dataSource itemIdentifierForIndexPath:indexPath];
        if (!itemModel) return;
        
        auto regionIdentifier = static_cast<NSString *>(itemModel.userInfo[SettingsRegionItemModelRegionIdentifierKey]);
        [SettingsService.sharedInstance setWithRegionIdentifierForAPI:regionIdentifier completionHandler:^(){
            completionHandler();
        }];
    });
}

void SettingsRegionViewModel::reconfigureWithSelectedRegionIdentifier(NSString * _Nullable selectedRegionIdentifier, UICollectionViewDiffableDataSource<SettingsRegionSectionModel *, SettingsRegionItemModel *> *dataSource) {
    NSDiffableDataSourceSnapshot<SettingsRegionSectionModel *, SettingsRegionItemModel *> *snapshot = [dataSource.snapshot copy];
    
    auto itemModels = [NSMutableArray<SettingsRegionItemModel *> new];
    [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(SettingsRegionItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type != SettingsRegionItemModelTypeRegion) return;
        
        auto userInfo = static_cast<NSMutableDictionary *>([obj.userInfo mutableCopy]);
        
        auto regionIdentifier = static_cast<NSString *>(userInfo[SettingsRegionItemModelRegionIdentifierKey]);
        
        if ([regionIdentifier isEqualToString:selectedRegionIdentifier]) {
            userInfo[SettingsRegionItemModelIsSelectedKey] = @YES;
        } else {
            userInfo[SettingsRegionItemModelIsSelectedKey] = @NO;
        }
        
        obj.userInfo = userInfo;
        [userInfo release];
        [itemModels addObject:obj];
    }];
    
    [snapshot reconfigureItemsWithIdentifiers:itemModels];
    [itemModels release];
    
    [dataSource applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

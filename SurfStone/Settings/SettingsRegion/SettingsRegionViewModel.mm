//
//  SettingsRegionViewModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/18/23.
//

#import "SettingsRegionViewModel.hpp"
@import StoneCore;

SettingsRegionViewModel::SettingsRegionViewModel(UICollectionViewDiffableDataSource<SettingsRegionSectionModel *, SettingsRegionItemModel *> *dataSource) : _dataSource([dataSource retain]) {
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, QOS_MIN_RELATIVE_PRIORITY);
    _queue = dispatch_queue_create("SettingsRegionViewModel", attr);
}

SettingsRegionViewModel::~SettingsRegionViewModel() {
    dispatch_release(_queue);
    [_regionIdentifierForAPIObserver release];
    [_dataSource release];
}

void SettingsRegionViewModel::load(std::shared_ptr<SettingsRegionViewModel> ref, std::function<void ()> completionHandler) {
    assert(this == ref.get());
    
    dispatch_async(_queue, ^{
        [SettingsService.sharedInstance regionIdentifierForAPIWithCompletionHandler:^(NSString * _Nullable result) {
            dispatch_async(ref.get()->_queue, ^{
                ref.get()->reconfigureWithSelectedRegionIdentifier(result);
                completionHandler();
            });
        }];
        
        ref.get()->startObserving(ref);
        ref.get()->setupInitialDataSource();
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

void SettingsRegionViewModel::setupInitialDataSource() {
    auto snapshot = [NSDiffableDataSourceSnapshot<SettingsRegionSectionModel *, SettingsRegionItemModel *> new];
    
    SettingsRegionSectionModel *sectionModel = [[SettingsRegionSectionModel alloc] initWithType:SettingsRegionSectionModelTypeRegions];
    [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
    
    auto itemModels = [NSMutableArray<SettingsRegionItemModel *> new];
    [SettingsService.sharedInstance.availableRegionIdentifiersForAPI enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
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
    
    [_dataSource applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

void SettingsRegionViewModel::reconfigureWithSelectedRegionIdentifier(NSString * _Nullable selectedRegionIdentifier) {
    NSDiffableDataSourceSnapshot<SettingsRegionSectionModel *, SettingsRegionItemModel *> *snapshot = [_dataSource.snapshot copy];
    
    auto itemModels = [NSMutableArray<SettingsRegionItemModel *> new];
    [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(SettingsRegionItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type != SettingsRegionItemModelTypeRegion) return;
        
        auto regionIdentifier = static_cast<NSString *>(obj.userInfo[SettingsRegionItemModelRegionIdentifierKey]);
        BOOL newIsSelected = [regionIdentifier isEqualToString:selectedRegionIdentifier];
        BOOL oldIsSelected = static_cast<NSNumber *>(obj.userInfo[SettingsRegionItemModelIsSelectedKey]).boolValue;
        
        if (newIsSelected == oldIsSelected) return;
        
        auto mutableUserInfo = static_cast<NSMutableDictionary *>([obj.userInfo mutableCopy]);
        mutableUserInfo[SettingsRegionItemModelIsSelectedKey] = @(newIsSelected);
        
        obj.userInfo = mutableUserInfo;
        [mutableUserInfo release];
        [itemModels addObject:obj];
    }];
    
    [snapshot reconfigureItemsWithIdentifiers:itemModels];
    [itemModels release];
    
    [_dataSource applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

void SettingsRegionViewModel::startObserving(std::shared_ptr<SettingsRegionViewModel> ref) {
    assert(this == ref.get());
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    operationQueue.underlyingQueue = _queue;
    
    id regionIdentifierForAPIObserver = [NSNotificationCenter.defaultCenter addObserverForName:SettingsService.regionIdentifierForAPIDidChangeNotification
                                                                                        object:SettingsService.sharedInstance
                                                                                         queue:operationQueue usingBlock:^(NSNotification * _Nonnull notification) {
        id value = notification.userInfo[SettingsService.changedObjectKey];
        ref.get()->reconfigureWithSelectedRegionIdentifier(value);
    }];
    
    [_regionIdentifierForAPIObserver release];
    _regionIdentifierForAPIObserver = [regionIdentifierForAPIObserver retain];
    
    [operationQueue release];
}

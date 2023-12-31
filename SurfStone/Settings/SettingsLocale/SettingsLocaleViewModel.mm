//
//  SettingsLocaleViewModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/18/23.
//

#import "SettingsLocaleViewModel.hpp"
@import StoneCore;

SettingsLocaleViewModel::SettingsLocaleViewModel(UICollectionViewDiffableDataSource<SettingsLocaleSectionModel *, SettingsLocaleItemModel *> *dataSource) : _dataSource([dataSource retain]) {
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, QOS_MIN_RELATIVE_PRIORITY);
    _queue = dispatch_queue_create("SettingsLocaleViewModel", attr);
}

SettingsLocaleViewModel::~SettingsLocaleViewModel() {
    dispatch_release(_queue);
    [_localeForAPIObserver release];
    [_dataSource release];
}

void SettingsLocaleViewModel::load(std::shared_ptr<SettingsLocaleViewModel> ref, std::function<void ()> completionHandler) {
    dispatch_async(_queue, ^{
        [SettingsService.sharedInstance localeForAPIWithCompletionHandler:^(NSLocale * _Nullable result) {
            dispatch_async(ref.get()->_queue, ^{
                ref.get()->reconfigureWithSelectedLocale(result);
                completionHandler();
            });
        }];
        
        ref.get()->startObserving(ref);
        ref.get()->setupInitialDataSource();
    });
}

void SettingsLocaleViewModel::handleSelectionForIndexPath(NSIndexPath * _Nonnull indexPath, std::function<void ()> completionHandler) {
    auto dataSource = _dataSource;
    
    dispatch_async(_queue, ^{
        auto itemModel = [dataSource itemIdentifierForIndexPath:indexPath];
        if (!itemModel) return;
        
        auto locale = static_cast<NSLocale *>(itemModel.userInfo[SettingsLocaleItemModelLocaleKey]);
        [SettingsService.sharedInstance setLocaleForAPI:locale completionHandler:^(){
            completionHandler();
        }];
    });
}

void SettingsLocaleViewModel::setupInitialDataSource() {
    auto snapshot = [NSDiffableDataSourceSnapshot<SettingsLocaleSectionModel *, SettingsLocaleItemModel *> new];
    
    SettingsLocaleSectionModel *sectionModel = [[SettingsLocaleSectionModel alloc] initWithType:SettingsLocaleSectionModelTypeLocales];
    [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
    
    auto itemModels = [NSMutableArray<SettingsLocaleItemModel *> new];
    [SettingsService.sharedInstance.availableLocalesForAPI enumerateObjectsUsingBlock:^(NSLocale * _Nonnull obj, BOOL * _Nonnull stop) {
        SettingsLocaleItemModel *itemModel = [[SettingsLocaleItemModel alloc] initWithType:SettingsLocaleItemModelTypeLocale];
        itemModel.userInfo = @{
            SettingsLocaleItemModelLocaleKey: obj,
            SettingsLocaleItemModelIsSelectedKey: @NO
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

void SettingsLocaleViewModel::reconfigureWithSelectedLocale(NSLocale * _Nullable selectedLocale) {
    NSDiffableDataSourceSnapshot<SettingsLocaleSectionModel *, SettingsLocaleItemModel *> *snapshot = [_dataSource.snapshot copy];
    
    auto itemModels = [NSMutableArray<SettingsLocaleItemModel *> new];
    [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(SettingsLocaleItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type != SettingsLocaleItemModelTypeLocale) return;
        
        auto locale = static_cast<NSLocale *>(obj.userInfo[SettingsLocaleItemModelLocaleKey]);
        BOOL newIsSelected = [locale isEqual:selectedLocale];
        BOOL oldIsSelected = static_cast<NSNumber *>(obj.userInfo[SettingsLocaleItemModelIsSelectedKey]).boolValue;
        
        if (newIsSelected == oldIsSelected) return;
        
        auto mutableUserInfo = static_cast<NSMutableDictionary *>([obj.userInfo mutableCopy]);
        mutableUserInfo[SettingsLocaleItemModelIsSelectedKey] = @(newIsSelected);
        
        obj.userInfo = mutableUserInfo;
        [mutableUserInfo release];
        [itemModels addObject:obj];
    }];
    
    [snapshot reconfigureItemsWithIdentifiers:itemModels];
    [itemModels release];
    
    [_dataSource applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

void SettingsLocaleViewModel::startObserving(std::shared_ptr<SettingsLocaleViewModel> ref) {
    assert(this == ref.get());
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    operationQueue.underlyingQueue = _queue;
    
    id localeForAPIObserver = [NSNotificationCenter.defaultCenter addObserverForName:SettingsService.localeForAPIForAPIDidChangeNotification
                                                                              object:SettingsService.sharedInstance
                                                                               queue:operationQueue usingBlock:^(NSNotification * _Nonnull notification) {
        id value = notification.userInfo[SettingsService.changedObjectKey];
        ref.get()->reconfigureWithSelectedLocale(value);
    }];
    
    [_localeForAPIObserver release];
    _localeForAPIObserver = [localeForAPIObserver retain];
    
    [operationQueue release];
}

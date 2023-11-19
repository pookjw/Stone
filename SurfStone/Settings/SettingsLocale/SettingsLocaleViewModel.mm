//
//  SettingsLocaleViewModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/18/23.
//

#import "SettingsLocaleViewModel.hpp"
@import StoneCore;

SettingsLocaleViewModel::SettingsLocaleViewModel(UICollectionViewDiffableDataSource<SettingsLocaleSectionModel *, SettingsLocaleItemModel *> *dataSource) : _dataSource([dataSource retain]), _isLoaded(NO) {
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, QOS_MIN_RELATIVE_PRIORITY);
    _queue = dispatch_queue_create("SettingsLocaleViewModel", attr);
}

SettingsLocaleViewModel::~SettingsLocaleViewModel() {
    dispatch_release(_queue);
    [_localeForAPIObserver release];
    [_dataSource release];
}

void SettingsLocaleViewModel::load(std::function<void ()> completionHandler) {
    _mutex.lock();
    
    if (_isLoaded) {
        _mutex.unlock();
        return;
    }
    
    auto settingsService = SettingsService.sharedInstance;
    auto dataSource = _dataSource;
    auto queue = _queue;
    
    dispatch_async(queue, ^{
        auto snapshot = [NSDiffableDataSourceSnapshot<SettingsLocaleSectionModel *, SettingsLocaleItemModel *> new];
        
        SettingsLocaleSectionModel *sectionModel = [[SettingsLocaleSectionModel alloc] initWithType:SettingsLocaleSectionModelTypeLocales];
        [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
        
        auto itemModels = [NSMutableArray<SettingsLocaleItemModel *> new];
        [settingsService.availableLocalesForAPI enumerateObjectsUsingBlock:^(NSLocale * _Nonnull obj, BOOL * _Nonnull stop) {
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
        
        [dataSource applySnapshot:snapshot animatingDifferences:YES];
        [snapshot release];
        
        //
        
        [settingsService localeForAPIWithCompletionHandler:^(NSLocale * _Nullable result) {
            dispatch_async(queue, ^{
                reconfigureWithSelectedLocale(result, dataSource);
                completionHandler();
            });
        }];
    });
    
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    operationQueue.underlyingQueue = queue;
    
    _localeForAPIObserver = [[NSNotificationCenter.defaultCenter addObserverForName:SettingsService.localeForAPIForAPIDidChangeNotification object:settingsService queue:operationQueue usingBlock:^(NSNotification * _Nonnull notification) {
        id value = notification.userInfo[SettingsService.changedObjectKey];
        reconfigureWithSelectedLocale(value, dataSource);
    }] retain];
    
    [operationQueue release];
    
    //
    
    _isLoaded = YES;
    _mutex.unlock();
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

void SettingsLocaleViewModel::reconfigureWithSelectedLocale(NSLocale * _Nullable selectedLocale, UICollectionViewDiffableDataSource<SettingsLocaleSectionModel *,SettingsLocaleItemModel *> * _Nonnull dataSource) {
    NSDiffableDataSourceSnapshot<SettingsLocaleSectionModel *, SettingsLocaleItemModel *> *snapshot = [dataSource.snapshot copy];
    
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
    
    [dataSource applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

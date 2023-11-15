//
//  SettingsViewModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/16/23.
//

#import "SettingsViewModel.hpp"
@import StoneCore;

SettingsViewModel::SettingsViewModel(UICollectionViewDiffableDataSource<SettingsSectionModel *, SettingsItemModel *> *dataSource) : _dataSource([dataSource retain]) {
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, QOS_MIN_RELATIVE_PRIORITY);
    _queue = dispatch_queue_create("SettingsViewModel", attr);
}

SettingsViewModel::~SettingsViewModel() {
    dispatch_release(_queue);
    [_dataSource release];
}

void SettingsViewModel::load(std::function<void ()> completion) {
    auto settingsService = SettingsService.sharedInstance;
    auto dataSource = _dataSource;
    auto queue = _queue;
    
    dispatch_async(queue, ^{
        NSDiffableDataSourceSnapshot<SettingsSectionModel *, SettingsItemModel *> *snapshot = [NSDiffableDataSourceSnapshot<SettingsSectionModel *, SettingsItemModel *> new];
        
        SettingsSectionModel *apiSectionModel = [[SettingsSectionModel alloc] initWithType:SettingsSectionModelTypeAPI];
        
        [snapshot appendSectionsWithIdentifiers:@[apiSectionModel]];
        [dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
            
        }];
        
        [apiSectionModel release];
        [snapshot release];
    });
    
    [settingsService regionIdentifierForAPIWithCompletionHandler:^(NSString * _Nullable result) {
        dispatch_async(queue, ^{
            NSDiffableDataSourceSnapshot<SettingsSectionModel *, SettingsItemModel *> *snapshot = [dataSource.snapshot copy];
            
            SettingsSectionModel *sectionModel = appendSectionIntoSnapshotIfNeeded(SettingsSectionModelTypeAPI, snapshot);
            
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
            
            SettingsSectionModel *sectionModel = appendSectionIntoSnapshotIfNeeded(SettingsSectionModelTypeAPI, snapshot);
            
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
}

SettingsSectionModel * SettingsViewModel::appendSectionIntoSnapshotIfNeeded(SettingsSectionModelType type, NSDiffableDataSourceSnapshot<SettingsSectionModel *,SettingsItemModel *> * _Nonnull snapshot) {
    __block SettingsSectionModel *existing = nil;
    [snapshot.sectionIdentifiers enumerateObjectsUsingBlock:^(SettingsSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == type) {
            existing = obj;
            *stop = YES;
        }
    }];
    
    if (existing) {
        return [[existing retain] autorelease];
    }
    
    SettingsSectionModel *sectionModel = [[SettingsSectionModel alloc] initWithType:type];
    [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
    return [sectionModel autorelease];
}

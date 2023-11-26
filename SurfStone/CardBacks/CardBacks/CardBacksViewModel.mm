//
//  CardBacksViewModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/21/23.
//

#import "CardBacksViewModel.hpp"
#import "HearthstoneAPIService+Macro.hpp"

CardBacksViewModel::CardBacksViewModel(UICollectionViewDiffableDataSource<CardBacksSectionModel *, CardBacksItemModel *> *dataSource) : _dataSource([dataSource retain]), _apiService([HearthstoneAPIService new]) {
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, QOS_MIN_RELATIVE_PRIORITY);
    _queue = dispatch_queue_create("CardBacksOptionsViewModel", attr);
}

CardBacksViewModel::~CardBacksViewModel() {
    dispatch_release(_queue);
    [_dataSource release];
    [_apiService release];
}

NSProgress * CardBacksViewModel::load(std::shared_ptr<CardBacksViewModel> ref, NSString * _Nullable textFilter, NSString * _Nullable cardBackCategorySlug, HSCardBacksSortRequest sort) {
    assert(this == ref.get());
    NSProgress *progress = [NSProgress progressWithTotalUnitCount:2];
    
    dispatch_async(_queue, ^{
        auto snapshot = [NSDiffableDataSourceSnapshot<CardBacksSectionModel *, CardBacksItemModel *> new];
        [ref.get()->_dataSource applySnapshot:snapshot animatingDifferences:YES];
        [snapshot release];
        
        //
        
        NSProgress *requestProgress = [ref.get()->_apiService cardBacksWithCardBackCategory:cardBackCategorySlug
                                                   textFilter:textFilter
                                                         sort:sort
                                                         page:nil
                                                     pageSize:nil completion:^(HSCardBacksResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                if (error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled) {
                    NSLog(@"Cancelled");
                } else {
                    [NSException exceptionWithName:NSInternalInconsistencyException reason:error.localizedDescription userInfo:error.userInfo];
                }
            }
            
            ref.get()->appendHSCardBacksResponse(response);
        }];
        
        [progress addChild:requestProgress withPendingUnitCount:1];
        progress.completedUnitCount += 1;
    });
    
    return progress;
}

void CardBacksViewModel::itemModelFromIndexPath(std::shared_ptr<CardBacksViewModel> ref, NSIndexPath * _Nonnull indexPath, void (^completionHandler)(CardBacksItemModel * _Nullable itemModel)) {
    dispatch_async(_queue, ^{
        auto itemModel = [ref.get()->_dataSource itemIdentifierForIndexPath:indexPath];
        completionHandler(itemModel);
    });
}

void CardBacksViewModel::appendHSCardBacksResponse(HSCardBacksResponse * _Nonnull response) {
    auto snapshot = static_cast<NSDiffableDataSourceSnapshot<CardBacksSectionModel *, CardBacksItemModel *> *>([_dataSource.snapshot copy]);
    
    //
    
    __block CardBacksSectionModel * _Nullable __autoreleasing sectionModel = nil;
    [snapshot.sectionIdentifiers enumerateObjectsUsingBlock:^(CardBacksSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == CardBacksSectionModelTypeCardBacks) {
            sectionModel = [[obj retain] autorelease];
            *stop = YES;
        }
    }];
    
    if (!sectionModel) {
        sectionModel = [[[CardBacksSectionModel alloc] initWithType:CardBacksSectionModelTypeCardBacks] autorelease];
        [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
    }
    
    //
    
    auto itemModels = [NSMutableArray<CardBacksItemModel *> new];
    [response.cardBacks enumerateObjectsUsingBlock:^(HSCardBackResponse * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CardBacksItemModel *itemModel = [[CardBacksItemModel alloc] initWithType:CardBacksItemModelTypeCardBack];
        itemModel.userInfo = @{CardBacksItemModelHSCardBackResponseKey: obj};
        [itemModels addObject:itemModel];
        [itemModel release];
    }];
    
    [snapshot appendItemsWithIdentifiers:itemModels intoSectionWithIdentifier:sectionModel];
    [itemModels release];
    
    //
    
    [_dataSource applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

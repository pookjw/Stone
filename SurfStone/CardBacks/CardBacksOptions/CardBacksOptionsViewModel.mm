//
//  CardBacksOptionsViewModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/4/23.
//

#import "CardBacksOptionsViewModel.hpp"
#import "HearthstoneAPIService+Macro.hpp"

CardBacksOptionsViewModel::CardBacksOptionsViewModel(UICollectionViewDiffableDataSource<CardBacksOptionsSectionModel *, CardBacksOptionsItemModel *> *dataSource) : _dataSource([dataSource retain]), _apiService([HearthstoneAPIService new]) {
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, QOS_MIN_RELATIVE_PRIORITY);
    _queue = dispatch_queue_create("CardBacksOptionsViewModel", attr);
}

CardBacksOptionsViewModel::~CardBacksOptionsViewModel() {
    dispatch_release(_queue);
    [_apiService release];
    [_dataSource release];
}

NSProgress * CardBacksOptionsViewModel::load(std::shared_ptr<CardBacksOptionsViewModel> ref) {
    assert(this == ref.get());
    NSProgress *progress = [NSProgress progressWithTotalUnitCount:2];
    
    dispatch_async(_queue, ^{
        ref.get()->setupInitialDataSource();
        NSProgress *requestProgress = ref.get()->requestCardBackCategoryResponses(ref);
        [progress addChild:requestProgress withPendingUnitCount:1];
        progress.completedUnitCount += 1;
    });
    
    return progress;
}

CardBacksOptionsItemModel * _Nullable CardBacksOptionsViewModel::unsafe_iteModelFromIndexPath(NSIndexPath * _Nonnull indexPath) {
    return [_dataSource itemIdentifierForIndexPath:indexPath];
}

void CardBacksOptionsViewModel::inputDataWithCompletionHandler(std::shared_ptr<CardBacksOptionsViewModel> ref, void (^completionHandler)(NSString * _Nullable text, NSString * _Nullable categorySlug, HSCardBacksSortRequest sort)) {
    dispatch_async(_queue, ^{
        auto snapshot = ref.get()->_dataSource.snapshot;
        
        __block CardBacksOptionsItemModel * _Nullable textFilterItemModel = nil;
        __block CardBacksOptionsItemModel * _Nullable cardBackCategoryItemModel = nil;
        __block CardBacksOptionsItemModel * _Nullable sortItemModel = nil;
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(CardBacksOptionsItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            void (^stopIfNeeded)(BOOL *) = ^(BOOL *stop) {
                if (textFilterItemModel && cardBackCategoryItemModel && sortItemModel) {
                    *stop = YES;
                }
            };
            
            if (obj.type == CardBacksOptionsItemModelTypeTextFilter) {
                textFilterItemModel = [[obj retain] autorelease];
                stopIfNeeded(stop);
            } else if (obj.type == CardBacksOptionsItemModelTypeCardBackCategory) {
                cardBackCategoryItemModel = [[obj retain] autorelease];
                stopIfNeeded(stop);
            } else if (obj.type == CardBacksOptionsItemModelTypeSort) {
                sortItemModel = [[obj retain] autorelease];
                stopIfNeeded(stop);
            }
        }];
        
        //
        
        NSString * _Nullable text;
        id _Nullable textFilter = textFilterItemModel.userInfo[CardBacksItemModelTextFilterKey];
        if ([textFilter isKindOfClass:NSString.class]) {
            text = textFilter;
        } else {
            text = nil;
        }
        
        NSString * _Nullable categorySlug;
        id _Nullable selectedCardBackCategory = cardBackCategoryItemModel.userInfo[CardBacksItemModelSelectedCardBackCategoryKey];
        if ([selectedCardBackCategory isKindOfClass:HSCardBackCategoryResponse.class]) {
            categorySlug = static_cast<HSCardBackCategoryResponse *>(selectedCardBackCategory).slug;
        } else {
            categorySlug = nil;
        }
        
        HSCardBacksSortRequest sort;
        id _Nullable selectedSort = sortItemModel.userInfo[CardBacksItemModelSelectedSortKey];
        if ([selectedSort isKindOfClass:NSNumber.class]) {
            sort = static_cast<HSCardBacksSortRequest>(static_cast<NSNumber *>(selectedSort).unsignedIntegerValue);
        } else {
            sort = HSCardBacksSortRequestNone;
        }
        
        //
        
        completionHandler(text, categorySlug, sort);
    });
}

void CardBacksOptionsViewModel::textFilterWithCompletionHandler(std::shared_ptr<CardBacksOptionsViewModel> ref, void (^completionHandler)(NSString * _Nullable text)) {
    
    dispatch_async(_queue, ^{
        auto snapshot = ref.get()->_dataSource.snapshot;
        
        __block CardBacksOptionsItemModel * _Nullable textFilterItemModel = nil;
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(CardBacksOptionsItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.type == CardBacksOptionsItemModelTypeTextFilter) {
                textFilterItemModel = [[obj retain] autorelease];
                *stop = YES;
            }
        }];
        
        //
        
        NSString * _Nullable text;
        id _Nullable textFilter = textFilterItemModel.userInfo[CardBacksItemModelTextFilterKey];
        if ([textFilter isKindOfClass:NSString.class]) {
            text = textFilter;
        } else {
            text = nil;
        }
        
        //
        
        completionHandler(text);
    });
}

void CardBacksOptionsViewModel::updateTextFilter(std::shared_ptr<CardBacksOptionsViewModel> ref, NSString * _Nullable text, std::function<void ()> completionHandler) {
    dispatch_async(_queue, ^{
        auto snapshot = static_cast<NSDiffableDataSourceSnapshot<CardBacksOptionsSectionModel *, CardBacksOptionsItemModel *> *>([ref.get()->_dataSource.snapshot copy]);
        
        __block CardBacksOptionsItemModel * _Nullable textFilterItemModel = nil;
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(CardBacksOptionsItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.type == CardBacksOptionsItemModelTypeTextFilter) {
                textFilterItemModel = [[obj retain] autorelease];
                *stop = YES;
            }
        }];
        
        if (!textFilterItemModel) {
            NSLog(@"Not loaded yet");
            [snapshot release];
            completionHandler();
        }
        
        id textFilter;
        if (text) {
            textFilter = text;
        } else {
            textFilter = [NSNull null];
        }
        
        auto mutableUserInfo = static_cast<NSMutableDictionary *>([textFilterItemModel.userInfo mutableCopy]);
        mutableUserInfo[CardBacksItemModelTextFilterKey] = textFilter;
        textFilterItemModel.userInfo = mutableUserInfo;
        [mutableUserInfo release];
        
        [snapshot reconfigureItemsWithIdentifiers:@[textFilterItemModel]];
        [ref.get()->_dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
            completionHandler();
        }];
        [snapshot release];
    });
}

void CardBacksOptionsViewModel::updateSelectedCardBackCategory(std::shared_ptr<CardBacksOptionsViewModel> ref, HSCardBackCategoryResponse * _Nullable response, std::function<void ()> completionHandler) {
    dispatch_async(_queue, ^{
        auto snapshot = static_cast<NSDiffableDataSourceSnapshot<CardBacksOptionsSectionModel *, CardBacksOptionsItemModel *> *>([ref.get()->_dataSource.snapshot copy]);
        
        __block CardBacksOptionsItemModel * _Nullable cardBackCategoryItemModel = nil;
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(CardBacksOptionsItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.type == CardBacksOptionsItemModelTypeCardBackCategory) {
                cardBackCategoryItemModel = [[obj retain] autorelease];
                *stop = YES;
            }
        }];
        
        if (!cardBackCategoryItemModel) {
            NSLog(@"Not loaded yet");
            [snapshot release];
            completionHandler();
        }
        
        id selectedCardBackCategory;
        if (response) {
            selectedCardBackCategory = response;
        } else {
            selectedCardBackCategory = [NSNull null];
        }
        
        auto mutableUserInfo = static_cast<NSMutableDictionary *>([cardBackCategoryItemModel.userInfo mutableCopy]);
        mutableUserInfo[CardBacksItemModelSelectedCardBackCategoryKey] = selectedCardBackCategory;
        cardBackCategoryItemModel.userInfo = mutableUserInfo;
        [mutableUserInfo release];
        
        [snapshot reconfigureItemsWithIdentifiers:@[cardBackCategoryItemModel]];
        [ref.get()->_dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
            completionHandler();
        }];
        [snapshot release];
    });
}

void CardBacksOptionsViewModel::updateSelectedSortKey(std::shared_ptr<CardBacksOptionsViewModel> ref, HSCardBacksSortRequest sort, std::function<void ()> completionHandler) {
    dispatch_async(_queue, ^{
        auto snapshot = static_cast<NSDiffableDataSourceSnapshot<CardBacksOptionsSectionModel *, CardBacksOptionsItemModel *> *>([ref.get()->_dataSource.snapshot copy]);
        
        __block CardBacksOptionsItemModel * _Nullable sortItemModel = nil;
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(CardBacksOptionsItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.type == CardBacksOptionsItemModelTypeSort) {
                sortItemModel = [[obj retain] autorelease];
                *stop = YES;
            }
        }];
        
        if (!sortItemModel) {
            NSLog(@"Not loaded yet");
            [snapshot release];
            completionHandler();
        }
        
        auto mutableUserInfo = static_cast<NSMutableDictionary *>([sortItemModel.userInfo mutableCopy]);
        mutableUserInfo[CardBacksItemModelSelectedSortKey] = @(sort);
        sortItemModel.userInfo = mutableUserInfo;
        [mutableUserInfo release];
        
        [snapshot reconfigureItemsWithIdentifiers:@[sortItemModel]];
        [ref.get()->_dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
            completionHandler();
        }];
        [snapshot release];
    });
}

void CardBacksOptionsViewModel::setupInitialDataSource() {
    auto snapshot = [NSDiffableDataSourceSnapshot<CardBacksOptionsSectionModel *, CardBacksOptionsItemModel *> new];
    
    CardBacksOptionsSectionModel *sectionModel = [[CardBacksOptionsSectionModel alloc] initWithType:CardBacksOptionsSectionModelTypeOptions];
    [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
    
    //
    
    auto optionsItemModels = [NSMutableArray<CardBacksOptionsItemModel *> new];
    
    //
    
    CardBacksOptionsItemModel *textFilterItemModel = [[CardBacksOptionsItemModel alloc] initWithType:CardBacksOptionsItemModelTypeTextFilter];
    textFilterItemModel.userInfo = @{CardBacksItemModelTextFilterKey: [NSNull null]};
    [optionsItemModels addObject:textFilterItemModel];
    [textFilterItemModel release];
    
    //
    
    CardBacksOptionsItemModel *cardBackCategoryItemModel = [[CardBacksOptionsItemModel alloc] initWithType:CardBacksOptionsItemModelTypeCardBackCategory];
    cardBackCategoryItemModel.userInfo = @{
        CardBacksItemModelSelectedCardBackCategoryKey: [NSNull null],
        CardBacksItemModelCardBackCategoriesKey: [NSNull null]
    };
    [optionsItemModels addObject:cardBackCategoryItemModel];
    [cardBackCategoryItemModel release];
    
    //
    
    CardBacksOptionsItemModel *sortItemModel = [[CardBacksOptionsItemModel alloc] initWithType:CardBacksOptionsItemModelTypeSort];
    sortItemModel.userInfo = @{
        CardBacksItemModelSelectedSortKey: @(HSCardBacksSortRequestNone),
        CardBacksItemModelSortsKey: allHSCardBacksSortRequests()
    };
    [optionsItemModels addObject:sortItemModel];
    [sortItemModel release];
    
    //
    
    [snapshot appendItemsWithIdentifiers:optionsItemModels intoSectionWithIdentifier:sectionModel];
    [sectionModel release];
    [optionsItemModels release];
    
    [_dataSource applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

NSProgress * CardBacksOptionsViewModel::requestCardBackCategoryResponses(std::shared_ptr<CardBacksOptionsViewModel> ref) {
    assert(this == ref.get());
    
    NSProgress *progress = [_apiService cardBackCategoriesMetadataWithCompletion:^(NSArray<HSCardBackCategoryResponse *> * _Nullable responses, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        
        dispatch_async(ref.get()->_queue, ^{
            NSDiffableDataSourceSnapshot<CardBacksOptionsSectionModel *,CardBacksOptionsItemModel *> *snapshot = [ref.get()->_dataSource.snapshot copy];
            __block CardBacksOptionsItemModel * _Nullable itemModel = nil;
            [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(CardBacksOptionsItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.type == CardBacksOptionsItemModelTypeCardBackCategory) {
                    itemModel = obj;
                    *stop = YES;
                }
            }];
            
            assert(itemModel);
            if (!itemModel) {
                [snapshot release];
                return;
            }
            
            //
            
            NSMutableDictionary *mutableUserInfo = [itemModel.userInfo mutableCopy];
            mutableUserInfo[CardBacksItemModelCardBackCategoriesKey] = responses;
            itemModel.userInfo = mutableUserInfo;
            [mutableUserInfo release];
            
            [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
            [ref.get()->_dataSource applySnapshot:snapshot animatingDifferences:YES];
            [snapshot release];
        });
    }];
    
    return progress;
}

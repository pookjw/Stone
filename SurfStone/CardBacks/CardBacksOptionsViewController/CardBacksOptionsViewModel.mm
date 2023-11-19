//
//  CardBacksOptionsViewModel.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/4/23.
//

#import "CardBacksOptionsViewModel.hpp"
#import "HearthstoneAPIService+Macro.hpp"

CardBacksOptionsViewModel::CardBacksOptionsViewModel(UICollectionViewDiffableDataSource<CardBacksSectionModel *, CardBacksItemModel *> *dataSource) : _dataSource([dataSource retain]), _apiService([HearthstoneAPIService new]) {
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, QOS_MIN_RELATIVE_PRIORITY);
    _queue = dispatch_queue_create("CardBacksOptionsViewModel", attr);
}

CardBacksOptionsViewModel::~CardBacksOptionsViewModel() {
    dispatch_release(_queue);
    [_cardBackCategoriesMetadataProgress cancel];
    [_cardBackCategoriesMetadataProgress release];
    [_apiService release];
    [_dataSource release];
}

void CardBacksOptionsViewModel::load(std::function<void ()> completionHandler) {
    _mutex.lock();
    
    if (_isLoaded) {
        _mutex.unlock();
        return;
    }
    
    //
    
    auto dataSource = _dataSource;
    
    dispatch_async(_queue, ^{
        setupInitialDataSource(dataSource);
    });
    
    requestCardBackCategoryResponses();
    
    //
    
    _isLoaded = YES;
    _mutex.unlock();
}

void CardBacksOptionsViewModel::setupInitialDataSource(UICollectionViewDiffableDataSource<CardBacksSectionModel *,CardBacksItemModel *> * _Nonnull dataSource) {
    auto snapshot = [NSDiffableDataSourceSnapshot<CardBacksSectionModel *, CardBacksItemModel *> new];
    
    CardBacksSectionModel *sectionModel = [[CardBacksSectionModel alloc] initWithType:CardBacksSectionModelTypeOptions];
    [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
    
    //
    
    auto optionsItemModels = [NSMutableArray<CardBacksItemModel *> new];
    
    CardBacksItemModel *textFilterItemModel = [[CardBacksItemModel alloc] initWithType:CardBacksItemModelTypeTextFilter];
    textFilterItemModel.userInfo = @{CardBacksItemModelTextFilterKey: [NSNull null]};
    [optionsItemModels addObject:textFilterItemModel];
    [textFilterItemModel release];
    
    CardBacksItemModel *cardBackCategoryItemModel = [[CardBacksItemModel alloc] initWithType:CardBacksItemModelTypeCardBackCategory];
    cardBackCategoryItemModel.userInfo = @{
        CardBacksItemModelSelectedCardBackCategoryKey: [NSNull null],
        CardBacksItemModelCardBackCategoriesKey: [NSNull null]
    };
    [optionsItemModels addObject:cardBackCategoryItemModel];
    [cardBackCategoryItemModel release];
    
    CardBacksItemModel *sortItemModel = [[CardBacksItemModel alloc] initWithType:CardBacksItemModelTypeSort];
    cardBackCategoryItemModel.userInfo = @{
        CardBacksItemModelSelectedSortKey: [NSNull null],
        CardBacksItemModelSortsKey: [NSNull null]
    };
    [optionsItemModels addObject:sortItemModel];
    [sortItemModel release];
    
    //
    
    [snapshot appendItemsWithIdentifiers:optionsItemModels intoSectionWithIdentifier:sectionModel];
    [sectionModel release];
    [optionsItemModels release];
    
    [dataSource applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

void CardBacksOptionsViewModel::requestCardBackCategoryResponses() {
    auto queue = _queue;
    auto dataSource = _dataSource;
    
    NSProgress *cardBackCategoriesMetadataProgress = [_apiService cardBackCategoriesMetadataWithCompletion:^(NSArray<HSCardBackCategoryResponse *> * _Nullable responses, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        
        dispatch_async(queue, ^{
            NSDiffableDataSourceSnapshot<CardBacksSectionModel *,CardBacksItemModel *> *snapshot = [dataSource.snapshot copy];
            __block CardBacksItemModel * _Nullable itemModel = nil;
            [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(CardBacksItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.type == CardBacksItemModelTypeCardBackCategory) {
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
            [dataSource applySnapshot:snapshot animatingDifferences:YES];
            [snapshot release];
        });
    }];
    
    [_cardBackCategoriesMetadataProgress cancel];
    [_cardBackCategoriesMetadataProgress release];
    _cardBackCategoriesMetadataProgress = [cardBackCategoriesMetadataProgress retain];
}

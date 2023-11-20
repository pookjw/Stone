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

void CardBacksOptionsViewModel::setupInitialDataSource(UICollectionViewDiffableDataSource<CardBacksOptionsSectionModel *,CardBacksOptionsItemModel *> * _Nonnull dataSource) {
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
        CardBacksItemModelSelectedSortKey: [NSNull null],
        CardBacksItemModelSortsKey: allHSCardBacksSortRequests()
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
            NSDiffableDataSourceSnapshot<CardBacksOptionsSectionModel *,CardBacksOptionsItemModel *> *snapshot = [dataSource.snapshot copy];
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
            [dataSource applySnapshot:snapshot animatingDifferences:YES];
            [snapshot release];
        });
    }];
    
    [_cardBackCategoriesMetadataProgress cancel];
    [_cardBackCategoriesMetadataProgress release];
    _cardBackCategoriesMetadataProgress = [cardBackCategoriesMetadataProgress retain];
}

//
//  CardBacksOptionsViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/4/23.
//

#import "CardBacksOptionsViewController.hpp"
#import "CardBacksOptionsViewModel.hpp"
#import <objc/message.h>
#import <memory>
@import StoneCore;

__attribute__((objc_direct_members))
@interface CardBacksOptionsViewController () <UICollectionViewDelegate>
@property (retain, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) std::shared_ptr<CardBacksOptionsViewModel> viewModel;
@property (retain, nonatomic) NSProgress * _Nullable loadProgress;
@end

@implementation CardBacksOptionsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit_CardBacksOptionsViewController];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit_CardBacksOptionsViewController];
    }
    
    return self;
}

- (void)dealloc {
    [_loadProgress cancel];
    [_loadProgress release];
    [_collectionView release];
    [super dealloc];
}

- (void)commonInit_CardBacksOptionsViewController __attribute__((objc_direct)) {
    self.title = @"Options";
    
    NSMutableArray<UIBarButtonItemGroup *> *trailingItemGroups = [self.navigationItem.trailingItemGroups mutableCopy];
    
    __weak auto weakSelf = self;
    
    UIAction *fetchAction = [UIAction actionWithTitle:[NSString string] image:[UIImage systemImageNamed:@"arrowshape.right.fill"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        auto loaded = weakSelf;
        if (!loaded) return;
        
        auto viewModel = loaded->_viewModel;
        viewModel.get()->inputDataWithCompletionHandler(viewModel, ^(NSString * _Nullable text, NSString * _Nullable categorySlug, HSCardBacksSortRequest sort) {
            auto loaded = weakSelf;
            if (!loaded) return;
            auto delegate = loaded.delegate;
            
            if ([delegate respondsToSelector:@selector(cardBacksOptionsViewController:doneWithText:cardBackCategorySlug:sort:)]) {
                [delegate cardBacksOptionsViewController:loaded doneWithText:text cardBackCategorySlug:categorySlug sort:sort];
            }
        });
    }];
    UIBarButtonItem *fetchItem = [[UIBarButtonItem alloc] initWithPrimaryAction:fetchAction];
    UIBarButtonItemGroup *trailingGroup = [[UIBarButtonItemGroup alloc] initWithBarButtonItems:@[fetchItem] representativeItem:nil];
    [fetchItem release];
    
    [trailingItemGroups addObject:trailingGroup];
    [trailingGroup release];
    
    self.navigationItem.trailingItemGroups = trailingItemGroups;
    [trailingItemGroups release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self setupViewModel];
    
    self.loadProgress = _viewModel.get()->load(_viewModel);
}

- (void)setupCollectionView __attribute__((objc_direct)) {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceSidebar];
    
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:collectionViewLayout];
    
    collectionView.delegate = self;
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
    [collectionView release];
}

- (void)setupViewModel __attribute__((objc_direct)) {
    _viewModel = std::make_shared<CardBacksOptionsViewModel>([self makeDataSource]);
}

- (UICollectionViewDiffableDataSource<CardBacksOptionsSectionModel *, CardBacksOptionsItemModel *> *)makeDataSource __attribute__((objc_direct)) {
    auto cellRegistration = [self makeCellRegistration];
    
    auto dataSource = [[UICollectionViewDiffableDataSource<CardBacksOptionsSectionModel *, CardBacksOptionsItemModel *> alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
    }];
    
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)makeCellRegistration __attribute__((objc_direct)) {
    __weak auto weakSelf = self;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        auto itemModel = static_cast<CardBacksOptionsItemModel *>(item);
        
        switch (itemModel.type) {
            case CardBacksOptionsItemModelTypeTextFilter: {
                UIListContentConfiguration *contentConfiguration = cell.defaultContentConfiguration;
                contentConfiguration.text = @"Text";
                cell.contentConfiguration = contentConfiguration;
                
                id _Nullable textFilter = itemModel.userInfo[CardBacksItemModelTextFilterKey];
                NSString *text;
                if ([textFilter isKindOfClass:NSString.class]) {
                    text = static_cast<NSString *>(textFilter);
                } else {
                    text = @"";
                }
                
                UICellAccessoryLabel *label = [[UICellAccessoryLabel alloc] initWithText:text];
                cell.accessories = @[label];
                [label release];
                break;
            }
            case CardBacksOptionsItemModelTypeCardBackCategory: {
                UIListContentConfiguration *contentConfiguration = cell.defaultContentConfiguration;
                contentConfiguration.text = @"Category";
                cell.contentConfiguration = contentConfiguration;
                
                id selectedCardBackCategory = itemModel.userInfo[CardBacksItemModelSelectedCardBackCategoryKey];
                id categories = itemModel.userInfo[CardBacksItemModelCardBackCategoriesKey];
                
                if ([categories isKindOfClass:NSArray.class]) {
                    NSString *text;
                    if ([selectedCardBackCategory isKindOfClass:HSCardBackCategoryResponse.class]) {
                        text = static_cast<HSCardBackCategoryResponse *>(selectedCardBackCategory).name;
                    } else {
                        text = @"(none)";
                    }
                    
                    NSArray<HSCardBackCategoryResponse *> *_categories = categories;
                    auto children = [NSMutableArray<UIAction *> new];
                    
                    [_categories enumerateObjectsUsingBlock:^(HSCardBackCategoryResponse * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        UIAction *action = [UIAction actionWithTitle:obj.name image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            auto loaded = weakSelf;
                            if (!loaded) return;
                            auto viewModel = loaded->_viewModel;
                            
                            viewModel.get()->updateSelectedCardBackCategory(viewModel, obj, []() {});
                        }];
                        
                        action.subtitle = obj.slug;
                        
                        UIMenuElementState state;
                        if ([obj isEqual:selectedCardBackCategory]) {
                            state = UIMenuElementStateOn;
                        } else {
                            state = UIMenuElementStateOff;
                        }
                        
                        action.state = state;
                        
                        [children addObject:action];
                    }];
                    
                    UIMenu *menu = [UIMenu menuWithChildren:children];
                    [children release];
                    
                    UICellAccessoryPopUpMenu *popUpMenu = [[UICellAccessoryPopUpMenu alloc] initWithMenu:menu];
                    UICellAccessoryLabel *label = [[UICellAccessoryLabel alloc] initWithText:text];
                    cell.accessories = @[popUpMenu, label];
                    [popUpMenu release];
                    [label release];
                } else {
                    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
                    [indicator startAnimating];
                    UICellAccessoryCustomView *accessory = [[UICellAccessoryCustomView alloc] initWithCustomView:indicator placement:UICellAccessoryPlacementTrailing];
                    [indicator release];
                    cell.accessories = @[accessory];
                    [accessory release];
                }
                
                break;
            }
            case CardBacksOptionsItemModelTypeSort: {
                UIListContentConfiguration *contentConfiguration = cell.defaultContentConfiguration;
                contentConfiguration.text = @"Sort";
                cell.contentConfiguration = contentConfiguration;
                
                auto selectedSort = static_cast<HSCardBacksSortRequest>(static_cast<NSNumber *>(itemModel.userInfo[CardBacksItemModelSelectedSortKey]).unsignedIntegerValue);
                NSArray<NSNumber *> *sorts = itemModel.userInfo[CardBacksItemModelSortsKey];
                auto children = [NSMutableArray<UIAction *> new];
                
                [sorts enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    auto title = NSStringFromHSCardBacksSortRequest(static_cast<HSCardBacksSortRequest>(obj.unsignedIntegerValue));
                    if (!title) {
                        title = @"(none)";
                    }
                    
                    auto sort = static_cast<HSCardBacksSortRequest>(obj.unsignedIntegerValue);
                    UIAction *action = [UIAction actionWithTitle:title image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        auto loaded = weakSelf;
                        if (!loaded) return;
                        auto viewModel = loaded->_viewModel;
                        
                        viewModel.get()->updateSelectedSortKey(viewModel, sort, []() {});
                    }];
                    
                    UIMenuElementState state;
                    if (sort == selectedSort) {
                        state = UIMenuElementStateOn;
                    } else {
                        state = UIMenuElementStateOff;
                    }
                    
                    action.state = state;
                    
                    [children addObject:action];
                }];
                
                UIMenu *menu = [UIMenu menuWithChildren:children];
                [children release];
                
                UICellAccessoryPopUpMenu *popUpMenu = [[UICellAccessoryPopUpMenu alloc] initWithMenu:menu];
                
                auto text = NSStringFromHSCardBacksSortRequest(selectedSort);
                if (!text) {
                    text = @"(none)";
                }
                UICellAccessoryLabel *label = [[UICellAccessoryLabel alloc] initWithText:text];
                cell.accessories = @[popUpMenu, label];
                [popUpMenu release];
                [label release];
                
                break;
            }
            default:
                cell.contentConfiguration = nil;
                break;
        }
    }];
    
    return cellRegistration;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CardBacksOptionsItemModel * _Nullable itemModel = _viewModel.get()->unsafe_iteModelFromIndexPath(indexPath);
    
    if (!itemModel) return NO;
    
    switch (itemModel.type) {
        case CardBacksOptionsItemModelTypeTextFilter:
            return YES;
        default:
            return NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak auto weakSelf = self;
    _viewModel.get()->textFilterWithCompletionHandler(_viewModel, ^(NSString * _Nullable text) {
        dispatch_async(dispatch_get_main_queue(), ^{
            auto loaded = weakSelf;
            if (!loaded) return;
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Text Filter" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.text = text;
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                auto loaded = weakSelf;
                if (!loaded) return;
                
                auto viewModel = loaded->_viewModel;
                auto alertController = reinterpret_cast<UIAlertController * (*)(id, SEL)>(objc_msgSend)(action, NSSelectorFromString(@"_alertController"));
                auto text = alertController.textFields.firstObject.text;
                viewModel.get()->updateTextFilter(viewModel, text, []() {});
            }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:doneAction];
            
            [loaded presentViewController:alertController animated:YES completion:^{
                
            }];
        });
    });
}

@end

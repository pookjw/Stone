//
//  CardBacksOptionsViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/4/23.
//

#import "CardBacksOptionsViewController.hpp"
#import "CardBacksOptionsViewModel.hpp"
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
    [_collectionView release];
    [_loadProgress cancel];
    [_loadProgress release];
    [super dealloc];
}

- (void)commonInit_CardBacksOptionsViewController __attribute__((objc_direct)) {
    self.title = @"Options";
    
    NSMutableArray<UIBarButtonItemGroup *> *trailingItemGroups = [self.navigationItem.trailingItemGroups mutableCopy];
    
    __weak auto weakSelf = self;
    
    UIAction *fetchAction = [UIAction actionWithTitle:[NSString string] image:[UIImage systemImageNamed:@"arrowshape.right.fill"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        
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
    self.viewModel = std::make_shared<CardBacksOptionsViewModel>([self makeDataSource]);
}

- (UICollectionViewDiffableDataSource<CardBacksOptionsSectionModel *, CardBacksOptionsItemModel *> *)makeDataSource __attribute__((objc_direct)) {
    auto cellRegistration = [self makeCellRegistration];
    
    auto dataSource = [[UICollectionViewDiffableDataSource<CardBacksOptionsSectionModel *, CardBacksOptionsItemModel *> alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
    }];
    
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        auto itemModel = static_cast<CardBacksOptionsItemModel *>(item);
        
        switch (itemModel.type) {
            case CardBacksOptionsItemModelTypeTextFilter: {
                UIListContentConfiguration *contentConfiguration = cell.defaultContentConfiguration;
                contentConfiguration.text = @"Text";
                cell.contentConfiguration = contentConfiguration;
                
                UIAction *primaryAction = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    
                }];
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectNull primaryAction:primaryAction];
                textField.borderStyle = UITextBorderStyleRoundedRect;
                textField.textColor = UIColor.labelColor;
                [textField.widthAnchor constraintEqualToConstant:80.f].active = YES;
                UICellAccessoryCustomView *textFieldAccessory = [[UICellAccessoryCustomView alloc] initWithCustomView:textField placement:UICellAccessoryPlacementTrailing];
                [textField release];
//                textFieldAccessory.maintainsFixedSize = YES;
                cell.accessories = @[textFieldAccessory];
                [textFieldAccessory release];
                break;
            }
            case CardBacksOptionsItemModelTypeCardBackCategory: {
                UIListContentConfiguration *contentConfiguration = cell.defaultContentConfiguration;
                contentConfiguration.text = @"Category";
                cell.contentConfiguration = contentConfiguration;
                
                id categories = itemModel.userInfo[CardBacksItemModelCardBackCategoriesKey];
                if ([categories isKindOfClass:NSArray.class]) {
                    NSArray<HSCardBackCategoryResponse *> *_categories = categories;
                    auto children = [NSMutableArray<UIAction *> new];
                    
                    [_categories enumerateObjectsUsingBlock:^(HSCardBackCategoryResponse * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        UIAction *action = [UIAction actionWithTitle:obj.name image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            
                        }];
                        action.subtitle = obj.slug;
                        [children addObject:action];
                    }];
                    
                    UIMenu *menu = [UIMenu menuWithChildren:children];
                    [children release];
                    
                    UICellAccessoryPopUpMenu *popUpMenu = [[UICellAccessoryPopUpMenu alloc] initWithMenu:menu];
                    cell.accessories = @[popUpMenu];
                    [popUpMenu release];
                } else {
                    cell.accessories = @[];
                }
                
                break;
            }
            case CardBacksOptionsItemModelTypeSort: {
                UIListContentConfiguration *contentConfiguration = cell.defaultContentConfiguration;
                contentConfiguration.text = @"Sort";
                cell.contentConfiguration = contentConfiguration;
                
                NSArray<NSNumber *> *sorts = itemModel.userInfo[CardBacksItemModelSortsKey];
                auto children = [NSMutableArray<UIAction *> new];
                
                [sorts enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    UIAction *action = [UIAction actionWithTitle:obj.stringValue image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        
                    }];
//                    action.subtitle = obj.slug;
                    [children addObject:action];
                }];
                
                UIMenu *menu = [UIMenu menuWithChildren:children];
                [children release];
                
                UICellAccessoryPopUpMenu *popUpMenu = [[UICellAccessoryPopUpMenu alloc] initWithMenu:menu];
                cell.accessories = @[popUpMenu];
                [popUpMenu release];
                
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

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end

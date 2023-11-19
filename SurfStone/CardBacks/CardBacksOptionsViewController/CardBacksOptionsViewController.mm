//
//  CardBacksOptionsViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/4/23.
//

#import "CardBacksOptionsViewController.hpp"
#import "CardBacksOptionsViewModel.hpp"
#import <memory>

__attribute__((objc_direct_members))
@interface CardBacksOptionsViewController () <UICollectionViewDelegate>
@property (retain, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) std::shared_ptr<CardBacksOptionsViewModel> viewModel;
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
    
    self.viewModel.get()->load(^{
        NSLog(@"Done!");
    });
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

- (UICollectionViewDiffableDataSource<CardBacksSectionModel *, CardBacksItemModel *> *)makeDataSource __attribute__((objc_direct)) {
    auto cellRegistration = [self makeCellRegistration];
    
    auto dataSource = [[UICollectionViewDiffableDataSource<CardBacksSectionModel *, CardBacksItemModel *> alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
    }];
    
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        auto itemModel = static_cast<CardBacksItemModel *>(item);
        
        switch (itemModel.type) {
            case CardBacksItemModelTypeTextFilter: {
                UIListContentConfiguration *contentConfiguration = cell.defaultContentConfiguration;
                contentConfiguration.text = @"Text";
                cell.contentConfiguration = contentConfiguration;
                break;
            }
            case CardBacksItemModelTypeCardBackCategory: {
                UIListContentConfiguration *contentConfiguration = cell.defaultContentConfiguration;
                contentConfiguration.text = @"Category";
                cell.contentConfiguration = contentConfiguration;
                
                break;
            }
            case CardBacksItemModelTypeSort: {
                UIListContentConfiguration *contentConfiguration = cell.defaultContentConfiguration;
                contentConfiguration.text = @"Sort";
                cell.contentConfiguration = contentConfiguration;
                
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

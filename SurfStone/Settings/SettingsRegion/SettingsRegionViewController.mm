//
//  SettingsRegionViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/18/23.
//

#import "SettingsRegionViewController.hpp"
#import "SettingsRegionViewModel.hpp"
#import <memory>

__attribute__((objc_direct_members))
@interface SettingsRegionViewController () <UICollectionViewDelegate>
@property (retain, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) std::shared_ptr<SettingsRegionViewModel> viewModel;
@end

@implementation SettingsRegionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit_SettingsRegionViewController];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit_SettingsRegionViewController];
    }
    
    return self;
}

- (void)dealloc {
    [_collectionView release];
    [super dealloc];
}

- (void)commonInit_SettingsRegionViewController __attribute__((objc_direct)) {
    self.title = @"Server Location";
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.viewModel = std::make_shared<SettingsRegionViewModel>([self makeDataSource]);
}

- (UICollectionViewDiffableDataSource<SettingsRegionSectionModel *, SettingsRegionItemModel *> *)makeDataSource __attribute__((objc_direct)) {
    auto cellRegistration = [self makeCellRegistration];
    
    auto dataSource = [[UICollectionViewDiffableDataSource<SettingsRegionSectionModel *, SettingsRegionItemModel *> alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
    }];
    
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        auto itemModel = static_cast<SettingsRegionItemModel *>(item);
        
        switch (itemModel.type) {
            case SettingsRegionItemModelTypeRegion: {
                UIListContentConfiguration *contentConfiguration = cell.defaultContentConfiguration;
                contentConfiguration.text = itemModel.userInfo[SettingsRegionItemModelRegionIdentifierKey];
                cell.contentConfiguration = contentConfiguration;
                
                if (static_cast<NSNumber *>(itemModel.userInfo[SettingsRegionItemModelIsSelectedKey]).boolValue) {
                    UICellAccessoryCheckmark *checkmark = [UICellAccessoryCheckmark new];
                    cell.accessories = @[checkmark];
                    [checkmark release];
                } else {
                    cell.accessories = @[];
                }
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _viewModel.get()->handleSelectionForIndexPath(indexPath, ^(){});
}

@end

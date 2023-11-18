//
//  SettingsViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/16/23.
//

#import "SettingsViewController.hpp"
#import "SettingsViewModel.hpp"
#import <objc/runtime.h>
#import <memory>

__attribute__((objc_direct_members))
@interface SettingsViewController () <UICollectionViewDelegate>
@property (retain, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) std::shared_ptr<SettingsViewModel> viewModel;
@end

@implementation SettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit_SettingsViewController];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit_SettingsViewController];
    }
    
    return self;
}

- (void)dealloc {
    [_collectionView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAttributes];
    [self setupCollectionView];
    [self setupViewModel];
    
    self.viewModel.get()->load(^{
        NSLog(@"Done!");
    });
}

- (void)commonInit_SettingsViewController __attribute__((objc_direct)) {
    self.title = @"Settings";
}

- (void)setupAttributes __attribute__((objc_direct)) {
    
}

- (void)setupCollectionView __attribute__((objc_direct)) {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceSidebar];
    listConfiguration.headerMode = UICollectionLayoutListHeaderModeSupplementary;
    
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
    self.viewModel = std::make_shared<SettingsViewModel>([self makeDataSource]);
}

- (UICollectionViewDiffableDataSource<SettingsSectionModel *, SettingsItemModel *> *)makeDataSource __attribute__((objc_direct)) {
    auto cellRegistration = [self makeCellRegistration];
    auto supplementaryRegistration = [self makeSupplementaryRegistration];
    
    auto dataSource = [[UICollectionViewDiffableDataSource<SettingsSectionModel *, SettingsItemModel *> alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
    }];
    
    dataSource.supplementaryViewProvider = ^UICollectionReusableView * _Nullable(UICollectionView * _Nonnull collectionView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:supplementaryRegistration forIndexPath:indexPath];
    };
    
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        auto itemModel = static_cast<SettingsItemModel *>(item);
        
        switch (itemModel.type) {
            case SettingsItemModelTypeRegion: {
                UIListContentConfiguration *contentConfiguration = cell.defaultContentConfiguration;
                contentConfiguration.text = @"Server Location";
                cell.contentConfiguration = contentConfiguration;
                
                id value = itemModel.userInfo[SettingsItemModelSelectedRegionIdentifierKey];
                NSString *accessoryText;
                if ([value isKindOfClass:NSString.class]) {
                    accessoryText = static_cast<NSString *>(value);
                } else {
                    accessoryText = @"(Auto)";
                }
                
                UICellAccessoryLabel *accessoryLabel = [[UICellAccessoryLabel alloc] initWithText:accessoryText];
                cell.accessories = @[accessoryLabel];
                [accessoryLabel release];
                break;
            }
            case SettingsItemModelTypeLocale: {
                UIListContentConfiguration *contentConfiguration = cell.defaultContentConfiguration;
                contentConfiguration.text = @"Card Language";
                cell.contentConfiguration = contentConfiguration;
                
                
                id value = itemModel.userInfo[SettingsItemModelSelectedLocaleKey];
                NSString *accessoryText;
                if ([value isKindOfClass:NSLocale.class]) {
                    accessoryText = static_cast<NSLocale *>(value).localeIdentifier;
                } else {
                    accessoryText = @"(Auto)";
                }
                
                UICellAccessoryLabel *accessoryLabel = [[UICellAccessoryLabel alloc] initWithText:accessoryText];
                cell.accessories = @[accessoryLabel];
                [accessoryLabel release];
                
                break;
            }
            default:
                cell.contentConfiguration = nil;
                break;
        }
    }];
    
    return cellRegistration;
}

- (UICollectionViewSupplementaryRegistration *)makeSupplementaryRegistration {
    __block id location;
    objc_storeWeak(&location, self);
    
    UICollectionViewSupplementaryRegistration *supplementaryRegistration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:UICollectionViewListCell.class elementKind:UICollectionElementKindSectionHeader configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull supplementaryView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        auto loaded = static_cast<SettingsViewController * _Nullable>(objc_loadWeak(&location));
        if (!loaded) return;
        
        SettingsSectionModel * _Nullable sectionModel = loaded->_viewModel.get()->unsafe_sectionModelFromIndexPath(indexPath);
        if (!sectionModel) return;
        
        switch (sectionModel.type) {
            case SettingsSectionModelTypeAPI: {
                auto contentConfiguration = [supplementaryView defaultContentConfiguration];
                contentConfiguration.text = @"API";
                supplementaryView.contentConfiguration = contentConfiguration;
            }
            default:
                break;
        }
    }];
    
    return supplementaryRegistration;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __block id location;
    objc_storeWeak(&location, self);
    
    _viewModel.get()->itemModelFromIndexPath(indexPath, ^(SettingsItemModel * _Nullable itemModel) {
        if (!itemModel) return;
        auto loaded = static_cast<SettingsViewController * _Nullable>(objc_loadWeak(&location));
        if (!loaded) return;
        
        [loaded.delegate settingsViewController:location didSelectItemModel:itemModel];
    });
}

@end

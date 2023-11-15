//
//  SettingsViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/16/23.
//

#import "SettingsViewController.hpp"
#import "SettingsViewModel.hpp"
#import <memory>

__attribute__((objc_direct_members))
@interface SettingsViewController () <UICollectionViewDelegate>
@property (retain, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) std::shared_ptr<SettingsViewModel> viewModel;
@end

@implementation SettingsViewController

- (void)dealloc {
    [_collectionView release];
    [super dealloc];
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
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:collectionView];
    [NSLayoutConstraint activateConstraints:@[
        [collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    self.collectionView = collectionView;
    [collectionView release];
}

- (void)setupViewModel __attribute__((objc_direct)) {
    self.viewModel = std::make_shared<SettingsViewModel>([self makeDataSource]);
}

- (UICollectionViewDiffableDataSource<SettingsSectionModel *, SettingsItemModel *> *)makeDataSource __attribute__((objc_direct)) {
    auto cellRegistration = [self makeCellRegistration];
    
    auto dataSource = [[UICollectionViewDiffableDataSource<SettingsSectionModel *, SettingsItemModel *> alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
    }];
    
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end

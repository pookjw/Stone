//
//  SettingsLocaleViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/18/23.
//

#import "SettingsLocaleViewController.hpp"
#import "SettingsLocaleViewModel.hpp"
#import <memory>

__attribute__((objc_direct_members))
@interface SettingsLocaleViewController () <UICollectionViewDelegate>
@property (retain, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) std::shared_ptr<SettingsLocaleViewModel> viewModel;
@end

@implementation SettingsLocaleViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit_SettingsLocaleViewController];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit_SettingsLocaleViewController];
    }
    
    return self;
}

- (void)dealloc {
    [_collectionView release];
    [super dealloc];
}

- (void)commonInit_SettingsLocaleViewController __attribute__((objc_direct)) {
    self.title = @"Card Language";
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
    _viewModel = std::make_shared<SettingsLocaleViewModel>([self makeDataSource]);
}

- (UICollectionViewDiffableDataSource<SettingsLocaleSectionModel *, SettingsLocaleItemModel *> *)makeDataSource __attribute__((objc_direct)) {
    auto cellRegistration = [self makeCellRegistration];
    
    auto dataSource = [[UICollectionViewDiffableDataSource<SettingsLocaleSectionModel *, SettingsLocaleItemModel *> alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
    }];
    
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        auto itemModel = static_cast<SettingsLocaleItemModel *>(item);
        
        switch (itemModel.type) {
            case SettingsLocaleItemModelTypeLocale: {
                UIListContentConfiguration *contentConfiguration = cell.defaultContentConfiguration;
                
                auto locale = static_cast<NSLocale *>(itemModel.userInfo[SettingsLocaleItemModelLocaleKey]);
                contentConfiguration.text = locale.localeIdentifier;
                cell.contentConfiguration = contentConfiguration;
                
                if (static_cast<NSNumber *>(itemModel.userInfo[SettingsLocaleItemModelIsSelectedKey]).boolValue) {
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
    _viewModel.get()->handleSelectionForIndexPath(indexPath, ^() {});
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end

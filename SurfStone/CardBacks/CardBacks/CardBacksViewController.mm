//
//  CardBacksViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/21/23.
//

#import "CardBacksViewController.hpp"
#import "CardBacksViewModel.hpp"
#import "CardBacksCollectionViewLayout.hpp"
#import "CardBacksCellContentView.hpp"
#import "UIApplication+mrui_requestSceneWrapper.hpp"
#import <objc/message.h>
#import <memory>
@import StoneCore;

__attribute__((objc_direct_members))
@interface CardBacksViewController () <UICollectionViewDelegate>
@property (retain, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) std::shared_ptr<CardBacksViewModel> viewModel;
@property (retain, nonatomic) NSProgress * _Nullable loadProgress;
@end

@implementation CardBacksViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit_CardBacksViewController];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit_CardBacksViewController];
    }
    
    return self;
}

- (void)dealloc {
    [_loadProgress cancel];
    [_loadProgress release];
    [_collectionView release];
    [super dealloc];
}

- (void)commonInit_CardBacksViewController __attribute__((objc_direct)) {
    self.title = @"Card Backs";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self setupViewModel];
    
    @synchronized (self) {
        self.loadProgress = _viewModel.get()->load(_viewModel, nil, nil, HSCardBacksSortRequestNone);
    }
}

- (void)loadWithTextFilter:(NSString *)textFilter cardBackCategorySlug:(NSString *)slug sort:(HSCardBacksSortRequest)sort {
    @synchronized (self) {
        [self.loadProgress cancel];
        self.loadProgress = _viewModel.get()->load(_viewModel, textFilter, slug, sort);
    }
}

- (void)setupCollectionView __attribute__((objc_direct)) {
    CardBacksCollectionViewLayout *collectionViewLayout = [CardBacksCollectionViewLayout new];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:collectionViewLayout];
    [collectionViewLayout release];
    
    collectionView.delegate = self;
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
    [collectionView release];
}

- (void)setupViewModel __attribute__((objc_direct)) {
    _viewModel = std::make_shared<CardBacksViewModel>([self makeDataSource]);
}

- (UICollectionViewDiffableDataSource<CardBacksSectionModel *, CardBacksItemModel *> *)makeDataSource __attribute__((objc_direct)) {
    auto cellRegistration = [self makeCellRegistration];
    
    auto dataSource = [[UICollectionViewDiffableDataSource<CardBacksSectionModel *, CardBacksItemModel *> alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
    }];
    
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewCell.class configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        auto itemModel = static_cast<CardBacksItemModel *>(item);
        
        switch (itemModel.type) {
            case CardBacksItemModelTypeCardBack: {
                CardBacksCellContentConfiguration *contentConfiguration = [[CardBacksCellContentConfiguration alloc] initWithFrame:cell.bounds cardBackResponse:itemModel.userInfo[CardBacksItemModelHSCardBackResponseKey]];
                cell.contentConfiguration = contentConfiguration;
                [contentConfiguration release];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    auto collectionView = static_cast<UICollectionView *>(scrollView);
    auto collectionViewLayout = static_cast<UICollectionViewCompositionalLayout *>(collectionView.collectionViewLayout);
    auto container = reinterpret_cast<id<NSCollectionLayoutContainer> (*)(id, SEL)>(objc_msgSend)(collectionViewLayout, NSSelectorFromString(@"_containerFromCollectionView"));
    
    NSLog(@"%@", container);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    _viewModel.get()->itemModelFromIndexPath(_viewModel, indexPath, ^(CardBacksItemModel * _Nullable itemModel) {
        auto cardBackResponse = static_cast<HSCardBackResponse *>(itemModel.userInfo[CardBacksItemModelHSCardBackResponseKey]);
        NSError * _Nullable error = nil;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cardBackResponse requiringSecureCoding:YES error:&error];
        assert(!error);
        
        NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"com.pookjw.SurfStone.CardDetail"];
        userActivity.userInfo = @{
            @"HSCardBackResponse": data
        };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication.sharedApplication mruiw_requestVolumetricSceneWithUserActivity:userActivity completionHandler:^(NSError * _Nullable error) {
                assert(!error);
            }];
        });
        
        [userActivity release];
    });
}

@end

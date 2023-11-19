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
    
}

@end

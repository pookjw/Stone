//
//  CardBacksViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/21/23.
//

#import "CardBacksViewController.hpp"
#import "CardBacksOptionsViewModel.hpp"
#import <memory>
@import StoneCore;

__attribute__((objc_direct_members))
@interface CardBacksViewController () <UICollectionViewDelegate>
@property (retain, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) std::shared_ptr<CardBacksOptionsViewModel> viewModel;
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
    [_collectionView release];
    [super dealloc];
}

- (void)commonInit_CardBacksViewController {
    self.title = @"Card Backs";
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end

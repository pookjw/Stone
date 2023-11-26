//
//  CardDetailsViewController.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/26/23.
//

#import "CardDetailsViewController.hpp"
#import "CardDetailsViewModel.hpp"
#import "AsyncImageView.hpp"
#import <objc/message.h>
#import <objc/runtime.h>
#import <memory>

@interface CardDetailsViewController ()
@property (retain, nonatomic) AsyncImageView *cardImageView;
@property (assign, nonatomic) std::shared_ptr<CardDetailsViewModel> viewModel;
@end

@implementation CardDetailsViewController

- (instancetype)initWithUserActivities:(NSSet<NSUserActivity *> *)userActivities {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _viewModel = std::make_shared<CardDetailsViewModel>(userActivities);
    }
    
    return self;
}

- (void)dealloc {
    [_cardImageView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCardImageView];
    
    //
    
    UIView *testView = [[UIView alloc] initWithFrame:self.view.bounds];
    testView.translatesAutoresizingMaskIntoConstraints = NO;
    reinterpret_cast<void (*)(id, SEL, long)>(objc_msgSend)(testView, NSSelectorFromString(@"sws_enablePlatter:"), 8);
    [self.view addSubview:testView];
    [NSLayoutConstraint activateConstraints:@[
        [testView.topAnchor constraintEqualToAnchor:self.cardImageView.bottomAnchor],
        [testView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [testView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [testView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [testView.heightAnchor constraintGreaterThanOrEqualToConstant:300.f]
    ]];
    testView.layer.zPosition = 400.f;
    reinterpret_cast<void (*)(id, SEL, NSUInteger, id)>(objc_msgSend)(testView, NSSelectorFromString(@"_requestSeparatedState:withReason:"), 1, @"SwiftUI.Transform3D");
    
    [self.cardImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [self.cardImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    [testView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    [testView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    [testView release];
    
    //
    
    auto cardImageView = self.cardImageView;
    _viewModel.get()->load(_viewModel, ^(NSURL * _Nonnull cardImageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [cardImageView setImageWithURL:cardImageURL];
        });
    });
}

- (void)setupCardImageView {
    AsyncImageView *cardImageView = [[AsyncImageView alloc] initWithFrame:self.view.bounds];
    
    cardImageView.contentMode = UIViewContentModeScaleAspectFit;
    cardImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    cardImageView.layer.zPosition = 300.f;
    reinterpret_cast<void (*)(id, SEL, NSUInteger, id)>(objc_msgSend)(cardImageView, NSSelectorFromString(@"_requestSeparatedState:withReason:"), 1, @"SwiftUI.Transform3D");
    
    [self.view addSubview:cardImageView];
    
    [NSLayoutConstraint activateConstraints:@[
        [cardImageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [cardImageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [cardImageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
    
    self.cardImageView = cardImageView;
    [cardImageView release];
}

@end

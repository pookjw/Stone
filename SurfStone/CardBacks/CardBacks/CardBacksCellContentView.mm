//
//  CardBacksCellContentView.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/21/23.
//

#import "CardBacksCellContentView.hpp"
#import "AsyncImageView.hpp"

@implementation CardBacksCellContentConfiguration

@synthesize frame = _frame;
@synthesize cardBackResponse = _cardBackResponse;

- (instancetype)initWithFrame:(CGRect)frame cardBackResponse:(HSCardBackResponse *)cardBackResponse {
    if (self = [super init]) {
        _frame = frame;
        _cardBackResponse = [cardBackResponse retain];
    }
    
    return self;
}

- (void)dealloc {
    [_cardBackResponse release];
    [super dealloc];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone { 
    id copy = [self.class new];
    
    if (copy) {
        auto casted = static_cast<CardBacksCellContentConfiguration *>(copy);
        casted->_frame = _frame;
        casted->_cardBackResponse = [_cardBackResponse retain];
    }
    
    return copy;
}

- (nonnull __kindof UIView<UIContentView> *)makeContentView { 
    CardBacksCellContentView *contentView = [[CardBacksCellContentView alloc] initWithConfiguration:self];
    return [contentView autorelease];
}

- (nonnull instancetype)updatedConfigurationForState:(nonnull id<UIConfigurationState>)state { 
    return self;
}

@end

__attribute__((objc_direct_members))
@interface CardBacksCellContentView ()
@property (copy, nonatomic, setter=_setConfiguration:) CardBacksCellContentConfiguration *_configuration;
@property (retain, nonatomic) AsyncImageView *imageView;
@end

@implementation CardBacksCellContentView

- (instancetype)initWithConfiguration:(CardBacksCellContentConfiguration *)configuration {
    if (self = [super initWithFrame:configuration.frame]) {
        [self setupImageView];
        self._configuration = configuration;
    }
    
    return self;
}

- (void)dealloc {
    [_imageView release];
    [super dealloc];
}

- (id<UIContentConfiguration>)configuration {
    return self._configuration;
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    self._configuration = configuration;
}

- (BOOL)supportsConfiguration:(id<UIContentConfiguration>)configuration {
    return [configuration isKindOfClass:CardBacksCellContentConfiguration.class];
}

- (void)_setConfiguration:(CardBacksCellContentConfiguration *)_configuration {
    [self.imageView setImageWithURL:_configuration.cardBackResponse.imageURL];
}

- (void)setupImageView __attribute__((objc_direct)) {
    AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:imageView];
    self.imageView = imageView;
    [imageView release];
}

@end

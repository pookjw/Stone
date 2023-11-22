//
//  AsyncImageView.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/21/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_direct_members))
@interface AsyncImageView : UIImageView
- (NSProgress *)setImageWithURL:(NSURL *)url completionHandler:(UIImage * _Nullable (^)(UIImage * _Nullable image, NSError * _Nullable))completionHandler;
- (NSProgress *)setImageWithURL:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END

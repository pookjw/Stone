//
//  AsyncImageView.mm
//  SurfStone
//
//  Created by Jinwoo Kim on 11/21/23.
//

#import "AsyncImageView.hpp"

@interface AsyncImageView ()
@property (retain, nonatomic) NSURLSession * _Nullable urlSession;
@property (retain, atomic) NSURLSessionDataTask * _Nullable dataTask;
@property (retain, nonatomic) dispatch_queue_t queue;
@end

@implementation AsyncImageView

- (void)dealloc {
    [_urlSession release];
    [_dataTask cancel];
    [_dataTask release];
    dispatch_release(_queue);
    [super dealloc];
}

- (NSProgress *)setImageWithURL:(NSURL *)url completionHandler:(UIImage * _Nullable (^)(UIImage * _Nullable, NSError * _Nullable))completionHandler {
    [self.dataTask cancel];
    self.image = nil;
    
    if (!self.queue) {
        dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, QOS_MIN_RELATIVE_PRIORITY);
        auto queue = dispatch_queue_create("AsyncImageView", attr);
        self.queue = queue;
        dispatch_release(queue);
    }
    
    auto configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    configuration.URLCache = NSURLCache.sharedURLCache;
    
    auto urlSession = [NSURLSession sessionWithConfiguration:configuration];
    
    auto request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.f];
    request.HTTPMethod = @"GET";
    request.allowsCellularAccess = YES;
    
    __weak auto weakSelf = self;
    auto dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionHandler(nil, error);
            return;
        }
        
        auto queue = weakSelf.queue;
        if (!queue) {
            completionHandler(nil, [NSError errorWithDomain:NSURLErrorDomain code:NSUserCancelledError userInfo:nil]);
            return;
        }
        
        dispatch_async(queue, ^{
            UIImage * _Nullable image = [[UIImage alloc] initWithData:data];
            UIImage * _Nullable displayImage = [image imageByPreparingForDisplay];
            [image release];
            
            if (![weakSelf.dataTask.response isEqual:response]) {
                completionHandler(nil, [NSError errorWithDomain:NSURLErrorDomain code:NSUserCancelledError userInfo:nil]);
                return;
            }
            
            UIImage *finalImage = completionHandler(displayImage, nil);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                auto retainedSelf = weakSelf;
                
                if (![retainedSelf.dataTask.response isEqual:response]) {
                    completionHandler(nil, [NSError errorWithDomain:NSURLErrorDomain code:NSUserCancelledError userInfo:nil]);
                    return;
                }
                
                retainedSelf.image = finalImage;
                retainedSelf.alpha = 0.f;
                [UIView animateWithDuration:0.15f animations:^{
                    retainedSelf.alpha = 1.f;
                }];
            });
        });
    }];
    [request release];
    
    self.urlSession = urlSession;
    self.dataTask = dataTask;
    
    [dataTask resume];
    [urlSession finishTasksAndInvalidate];
    
    return dataTask.progress;
}

- (NSProgress *)setImageWithURL:(NSURL *)url {
    return [self setImageWithURL:url completionHandler:^UIImage * _Nullable(UIImage * _Nullable image, NSError * _Nullable) {
        return image;
    }];
}

@end

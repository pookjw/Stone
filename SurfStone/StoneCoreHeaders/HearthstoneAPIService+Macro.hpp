//
//  HearthstoneAPIService+Macro.hpp
//  Stone
//
//  Created by Jinwoo Kim on 11/7/23.
//

#import <Foundation/Foundation.h>
@import StoneCore;

NS_ASSUME_NONNULL_BEGIN

@interface HearthstoneAPIService (Macro)
- (NSProgress *)cardBacksWithCardBackCategory:(NSString * _Nullable)arg1 textFilter:(NSString * _Nullable)arg2 sort:(HSCardBacksSortRequest)arg3 page:(NSNumber * _Nullable)arg4 pageSize:(NSNumber * _Nullable)arg5 completion:(void (^)(HSCardBacksResponse * _Nullable response, NSError * _Nullable error))arg7;
- (NSProgress *)cardBackCategoriesMetadataWithCompletion:(void (^)(NSArray<HSCardBackCategoryResponse *> * _Nullable response, NSError * _Nullable error))arg7;
@end

NS_ASSUME_NONNULL_END

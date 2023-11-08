//
//  HearthstoneAPIService+Macro.hpp
//  Stone
//
//  Created by Jinwoo Kim on 11/7/23.
//

#import <Foundation/Foundation.h>
@import StoneCore;

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

@interface HearthstoneAPIService (Macro)
- (NSProgress *)cardBacksWithLocale:(NSLocale *)arg1 cardBackCategory:(NSString * _Nullable)arg2 textFilter:(NSString * _Nullable)arg3 sort:(HSCardBacksSortRequest)arg4 page:(NSNumber * _Nullable)arg5 pageSize:(NSNumber * _Nullable)arg6 completion:(void (^)(HSCardBacksResponse * _Nullable response, NSError * _Nullable error))arg7;
@end

NS_HEADER_AUDIT_END(nullability, sendability)

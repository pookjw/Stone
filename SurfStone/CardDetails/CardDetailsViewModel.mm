//
//  CardDetailsViewModel.cpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/26/23.
//

#import "CardDetailsViewModel.hpp"

CardDetailsViewModel::CardDetailsViewModel(NSSet<NSUserActivity *> *userActivites) : _userActivites([userActivites retain]) {
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, QOS_MIN_RELATIVE_PRIORITY);
    _queue = dispatch_queue_create("CardDetailsViewModel", attr);
}

CardDetailsViewModel::~CardDetailsViewModel() {
    [_userActivites release];
}

void CardDetailsViewModel::load(std::shared_ptr<CardDetailsViewModel> ref, void (^completionHandler)(NSURL *cardImageURL)) {
    dispatch_async(_queue, ^{
        __block NSUserActivity * _Nullable userActivity = nil;
        [ref.get()->_userActivites enumerateObjectsUsingBlock:^(NSUserActivity * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj.activityType isEqualToString:@"com.pookjw.SurfStone.CardDetail"]) {
                userActivity = [[obj retain] autorelease];
                *stop = YES;
            }
        }];
        
        NSData * _Nullable responseData = userActivity.userInfo[@"HSCardBackResponse"];
        assert(responseData);
        NSError * _Nullable error = nil;
        HSCardBackResponse *hsCardBackResponse = [NSKeyedUnarchiver unarchivedObjectOfClass:HSCardBackResponse.class fromData:responseData error:&error];
        assert(!error);
        
        completionHandler(hsCardBackResponse.imageURL);
    });
}

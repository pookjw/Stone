//
//  CardDetailsViewModel.hpp
//  SurfStone
//
//  Created by Jinwoo Kim on 11/26/23.
//

#import <UIKit/UIKit.h>
#import <memory>
@import StoneCore;

NS_ASSUME_NONNULL_BEGIN

class CardDetailsViewModel {
public:
    CardDetailsViewModel(NSSet<NSUserActivity *> *userActivites);
    ~CardDetailsViewModel();
    CardDetailsViewModel(const CardDetailsViewModel&) = delete;
    CardDetailsViewModel& operator=(const CardDetailsViewModel&) = delete;
    
    void load(std::shared_ptr<CardDetailsViewModel> ref, void (^completionHandler)(NSURL *cardImageURL));
private:
    NSSet<NSUserActivity *> * const _userActivites;
    dispatch_queue_t _queue;
};

NS_ASSUME_NONNULL_END

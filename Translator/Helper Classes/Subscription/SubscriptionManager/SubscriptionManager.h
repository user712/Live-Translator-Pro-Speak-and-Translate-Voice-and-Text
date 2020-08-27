#import <Foundation/Foundation.h>
#import "MKStoreKit.h"
#import "SubscriptionItem.h"

extern NSString * const SubscriptionManagerProductsReceivedNotification;
extern NSString * const SubscriptionStartLoadingAnimationNotification;
extern NSString * const SubscriptionStopLoadingAnimationNotification;
extern NSString * const subscriptionPrivacyLink;
extern NSString * const subscriptionTermsLink;

@interface SubscriptionManager : NSObject

+ (id) sharedManager;
- (void) startSubscriptionManager;
- (SubscriptionItem *) appSubscription;
- (BOOL) isSubscriptionExpired;
- (BOOL) isTrialPeriodExpired;
- (void) purchaseAppSubscription;
- (void) restorePurchases;

@end

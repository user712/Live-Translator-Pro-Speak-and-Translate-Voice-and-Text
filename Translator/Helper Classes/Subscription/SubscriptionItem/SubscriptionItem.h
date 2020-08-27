#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SubscriptionItem : NSObject

@property (nonatomic, strong) SKProduct *product;
@property (nonatomic, copy) NSString *localPrice;
@property (nonatomic, copy) NSString *subscriptionPeriod;
@property (nonatomic, copy) NSString *trialPeriod;

- (id) initWithProduct:(SKProduct *) product;
- (void) printData;

@end

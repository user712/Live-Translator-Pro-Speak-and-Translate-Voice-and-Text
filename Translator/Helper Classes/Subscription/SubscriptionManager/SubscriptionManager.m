#import "SubscriptionManager.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"
@import TrueTime;

NSString * const SubscriptionManagerProductsReceivedNotification = @"SubscriptionManagerProductsReceivedNotification";
NSString * const SubscriptionStartLoadingAnimationNotification = @"SubscriptionStartLoadingAnimationNotification";
NSString * const SubscriptionStopLoadingAnimationNotification = @"SubscriptionStopLoadingAnimationNotification";
NSString * const subscriptionPrivacyLink = @"http://nordicnations.net/livetranslatorpro/privacy/";
NSString * const subscriptionTermsLink = @"http://nordicnations.net/livetranslatorpro/terms/";

@interface SubscriptionManager()

@property (nonatomic, strong) SKProductsRequest *productsRequest;
@property (nonatomic, strong) NSMutableArray *subscriptionOptions;
@property (nonatomic, copy) NSString *appSubscriptionIdentifier;

@end

@implementation SubscriptionManager

//MARK: Initializations
+ (id) sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        [_sharedObject updateAppSubscriptionIdentifier];
    });
    return _sharedObject;
}

- (void) startSubscriptionManager
{
    [self startTrueTimeFetcher];
    [self startNetworkMonitoring];
    [self addStoreKitObservers];
}

- (void) startTrueTimeFetcher
{
    TrueTimeClient *client = [TrueTimeClient sharedInstance];
    [client startWithHostURLs:@[[NSURL URLWithString:@"time.apple.com"]]];
}

- (void) addStoreKitObservers
{
    [self removeStoreKitObservers];
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductsAvailableNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      [self receivedProducts:[[MKStoreKit sharedKit] availableProducts]];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Purchased/Subscribed to product with id: %@", [note object]);
                                                      [[MKStoreKit sharedKit] startValidatingReceiptsAndUpdateLocalStore:^{
                                                          
                                                          [self subscriptionPurchasedActions];
                                                      }];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchaseFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSDictionary *info = note.object;
                                                      NSLog(@"Purchase failed with id: %@", info[@"productID"]);
                                                      [self purchaseFailedActionsWithError:info[@"error"]];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoredPurchasesNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Restored Purchases");
                                                      
                                                      SKPaymentQueue *queue = note.object;
                                                      if (queue.transactions.count)
                                                      {
                                                          [[MKStoreKit sharedKit] startValidatingReceiptsAndUpdateLocalStore:^{
                                                              
                                                              [self subscriptionPurchasedActions];
                                                          }];
                                                      }
                                                      else
                                                      {
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              
                                                              NSString *message = NSLocalizedString(@"noPreviousPurchasesKey", nil);
                                                              [self showToastWithMessage:message];
                                                              [self stopLoadingIndicator];
                                                          });
                                                      }
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoringPurchasesFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSError *restoreError = [note object];
                                                      NSLog(@"Failed restoring purchases with error: %@", restoreError);
                                                      [self restoreFailedActionsWithError:restoreError.localizedDescription];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitSubscriptionExpiredNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Subscription Expired");
                                                      [self subscriptionExpiredActions];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitReceiptValidationFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Receipt Validation Failed");
                                                  }];
}

- (void) removeStoreKitObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) startStoreKitProductRequest
{
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        
        [[MKStoreKit sharedKit] startProductRequest];
        [self stopNetworkMonitoring];
    });
}

//MARK: Purchases Methods
- (void) purchaseAppSubscription
{
    [self startLoadingIndicator];
    [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:self.appSubscriptionIdentifier];
}

- (void) restorePurchases
{
    [self startLoadingIndicator];
    [[MKStoreKit sharedKit] restorePurchases];
}

//MARK: Subscription Methods
- (void) receivedProducts:(NSArray *) products
{
    [self recycleSubscriptionOptions];
    
    for (SKProduct *product in products)
    {
        SubscriptionItem *subscription = [[SubscriptionItem alloc] initWithProduct:product];
        [self.subscriptionOptions addObject:subscription];
        [subscription printData];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SubscriptionManagerProductsReceivedNotification object:nil];
}

- (SubscriptionItem *) appSubscription
{
    for (SubscriptionItem *item in self.subscriptionOptions)
    {
        if ([item.product.productIdentifier isEqualToString:self.appSubscriptionIdentifier])
        {
            return item;
        }
    }
    
    return nil;
}

- (BOOL) isSubscriptionExpired
{
    TrueTimeClient *client = [TrueTimeClient sharedInstance];
    NSDate *currentTime = [[client referenceTime] now];
    if (!currentTime)
    {
        currentTime = [NSDate date];
    }
    NSDate *expireSubscriptionDate = [[MKStoreKit sharedKit] expiryDateForProduct:self.appSubscriptionIdentifier];
    
    switch ([currentTime compare:expireSubscriptionDate])
    {
        case NSOrderedAscending:
        case NSOrderedSame:
            return NO;
        case NSOrderedDescending:
            return YES;
    }
}

- (BOOL) isTrialPeriodExpired
{
    return ![[MKStoreKit sharedKit] isTrialPeriodActiveForProduct:self.appSubscriptionIdentifier];
}

- (void) recycleSubscriptionOptions
{
    if (!self.subscriptionOptions)
    {
        self.subscriptionOptions = [NSMutableArray new];
    }
    [self.subscriptionOptions removeAllObjects];
}

- (void) updateAppSubscriptionIdentifier
{
    NSDictionary *configs = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MKStoreKitConfigs.plist"]];
    NSArray *autoRenewable = configs[@"AutoRenewableSubscription"];
    self.appSubscriptionIdentifier = autoRenewable.firstObject;
}

//MARK: Purchase Actions
- (void) subscriptionPurchasedActions
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self stopLoadingIndicator];
        
        BOOL subscriptionExpired = [self isSubscriptionExpired];
        if (!subscriptionExpired)
        {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate showTranslator];
        }
        else
        {
            NSString *message = NSLocalizedString(@"subscriptionHasExpiredKey", nil);
            [self showToastWithMessage:message];
        }
    });
}

- (void) subscriptionExpiredActions
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate showSubscriptionView];
    });
}

- (void) purchaseFailedActionsWithError:(NSString *) errorDescription
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self stopLoadingIndicator];
        NSString *message = [NSString stringWithFormat:@"Purchase Error: %@", errorDescription];
        [self showToastWithMessage:message];
    });
}

- (void) restoreFailedActionsWithError:(NSString *) errorDescription
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self stopLoadingIndicator];
        NSString *message = [NSString stringWithFormat:@"Restore Error: %@", errorDescription];
        [self showToastWithMessage:message];
    });
}

//MARK: Networking Methods
- (void) startNetworkMonitoring
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"The reachability status is not reachable or unknown");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"The reachability status is reachable");
                [self startStoreKitProductRequest];
                break;
            }
            default:
                break;
        }
    }];
}

- (void) stopNetworkMonitoring
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager stopMonitoring];
}

- (BOOL) internetConnectionAvailable
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    return manager.reachable;
}

//MARK: Loading Indicators
- (void) startLoadingIndicator
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:SubscriptionStartLoadingAnimationNotification object:nil];
}

- (void) stopLoadingIndicator
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:SubscriptionStopLoadingAnimationNotification object:nil];
}

//MARK: Helper Methods
- (void) showToastWithMessage:(NSString *) toastMessage
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.rootViewController.view;
    
    CSToastStyle *toastStyle = [[CSToastStyle alloc] initWithDefaultStyle];
    toastStyle.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:185.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
    toastStyle.messageAlignment = NSTextAlignmentCenter;
    [topView makeToast:toastMessage duration:2.5 position:CSToastPositionCenter style:toastStyle];
}

//MARK: Deallocations
- (void) dealloc
{
    [self removeStoreKitObservers];
}

@end

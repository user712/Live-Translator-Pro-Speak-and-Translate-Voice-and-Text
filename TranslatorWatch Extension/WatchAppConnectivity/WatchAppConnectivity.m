//
//  WatchAppConnectivity.m
//  Cloudify
//
//    on 08/12/15.
//  Copyright © 2015. 
//

#import "WatchAppConnectivity.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import <UIKit/UIKit.h>
#import "LanguageSelectDemon.h"

NSString * const PHONE_DATA_FETCH_STARTED_NOTIFICATION = @"PHONE_DATA_FETCH_STARTED_NOTIFICATION";
NSString * const PHONE_DATA_RECEIVED_NOTIFICATION = @"PHONE_DATA_RECEIVED_NOTIFICATION";
NSString * const PHONE_DATA_FETCH_FAIL_NOTIFICATION = @"PHONE_DATA_FETCH_FAIL_NOTIFICATION";

@interface WatchAppConnectivity() <WCSessionDelegate>

@property (nonatomic, assign) BOOL dispatchToken;

@end

@implementation WatchAppConnectivity

#pragma mark - Initializations
+ (id) sharedConnection
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void) activateWatchSession
{
    if ([WCSession isSupported])
    {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

- (BOOL) sessionIsReachable
{
    WCSession *session = [WCSession defaultSession];
    return session.isReachable;
}

#pragma mark - Sending Messages
- (void) fetchPhoneData
{
    if (![self sessionIsReachable])
    {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PHONE_DATA_FETCH_STARTED_NOTIFICATION object:nil];
    [[WCSession defaultSession] sendMessage:@{@"reason":@(SYNC_WATCH_WITH_PHONE_LANG)} replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        
        NSDictionary *foo = replyMessage;
        [[LanguageSelectDemon summon] setAndSaveSourceLanguage:foo[@"source"]];
        [[LanguageSelectDemon summon] setAndSaveDestiantionLanguage:foo[@"destination"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:PHONE_DATA_RECEIVED_NOTIFICATION object:nil];
        
    } errorHandler:^(NSError * _Nonnull error) {
        
        NSLog(@"got an error while trying to sync the languages: %@, %@", error, [error userInfo]);
        [[NSNotificationCenter defaultCenter] postNotificationName:PHONE_DATA_FETCH_FAIL_NOTIFICATION object:nil];
    }];
    
    NSTimeInterval timeOut = 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeOut), dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PHONE_DATA_FETCH_FAIL_NOTIFICATION object:nil];
    });
}

- (void) syncNewLanguageWithPhone
{
    if (![self sessionIsReachable])
    {
        return;
    }
    
    [[WCSession defaultSession] sendMessage:@{@"source":[[LanguageSelectDemon summon] getCurrentSourceLanguage],
                                              @"destination": [[LanguageSelectDemon summon] getCurrentDestinationlanguage]}
                               replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                   //do nothing
                               } errorHandler:^(NSError * _Nonnull error) {
                                   NSLog(@"well something went wrong and I cannot sync the new watch lang with the watch, reason : %@, %@", error, [error userInfo]);
                               }];
}

- (void) sendTranslationDataToPhone:(NSDictionary *) data replyHandler:(nullable void (^)(NSDictionary<NSString *, id> *replyMessage)) replyHandler errorHandler:(nullable void (^)(NSError *error)) errorHandler
{
    if (![self sessionIsReachable])
    {
        errorHandler(nil);
        return;
    }
    
    [[WCSession defaultSession] sendMessage:data replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        
        NSLog(@"%@",replyMessage);
        replyHandler(replyMessage);
    } errorHandler:^(NSError * _Nonnull error) {
        
        NSLog(@"Error: %@",error);
        errorHandler(error);
    }];
}

#pragma mark - WCSessionDelegate Methods
- (void) sessionReachabilityDidChange:(WCSession *) session
{
    NSLog(@"sessionReachabilityDidChange");
}

- (void) session:(WCSession *) session activationDidCompleteWithState:(WCSessionActivationState) activationState error:(nullable NSError *) error
{
    NSLog(@"activationDidCompleteWithState: %ld", (long)activationState);
    if (activationState == WCSessionActivationStateActivated && session.isReachable)
    {
        if (!self.dispatchToken)
        {
            [self fetchPhoneData];
            self.dispatchToken = YES;
        }
    }
}

@end

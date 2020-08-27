//
//  WatchAppConnectivity.h
//  Cloudify
//
//    on 08/12/15.
//  Copyright © 2015. 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const PHONE_DATA_RECEIVED_NOTIFICATION;
extern NSString * const PHONE_DATA_FETCH_FAIL_NOTIFICATION;
extern NSString * const PHONE_DATA_FETCH_STARTED_NOTIFICATION;

typedef NS_ENUM(NSInteger, SESSION_REASON)
{
    GET_TRANSLATE,
    SYNC_WATCH_WITH_PHONE_LANG,
    SYNC_PHONE_WITH_WATCH_LANG
};

@interface WatchAppConnectivity : NSObject

+ (id) sharedConnection;
- (void) activateWatchSession;
- (void) fetchPhoneData;
- (void) syncNewLanguageWithPhone;
- (void) sendTranslationDataToPhone:(NSDictionary *) data replyHandler:(nullable void (^)(NSDictionary<NSString *, id> *replyMessage)) replyHandler errorHandler:(nullable void (^)(NSError *error)) errorHandler;

@end

NS_ASSUME_NONNULL_END

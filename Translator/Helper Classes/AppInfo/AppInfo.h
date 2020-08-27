//
//  AppInfo.h
//  MyApp5
//
//   Radu on 6/16/16.
//  Copyright © 2016 kat. 
//

#import <Foundation/Foundation.h>

typedef void (^AppInfoResultBlock)(BOOL success);
typedef void (^StoreAppsResultBlock)(NSArray *apps, NSError *error);

@interface Application : NSObject

@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appDescription;
@property (nonatomic, strong) NSString *appIconURL;
@property (nonatomic, strong) NSString *appURL;
@property (nonatomic, strong) NSString *appPrimaryGenre;
@property (nonatomic, readonly) BOOL isCompatible;

- (id) initWithResult:(NSDictionary *) result;

@end

@interface AppInfo : NSObject

#pragma mark - Initializations
+ (AppInfo *) sharedManager;

#pragma mark - Info
- (void) updateInfoWithCompletion:(AppInfoResultBlock) completion;
- (void) recheckAppAvailabilityInStoreForCurrentRegionWithCompletion:(AppInfoResultBlock) completion;
- (NSString *) bundleID;
- (NSString *) appName;
- (NSString *) appID;
- (NSString *) storeAppLink;
- (NSString *) redirectStoreAppLink;
- (NSString *) shortAppURL;
- (void) updateShortAppURL:(NSString *) shareURL;
- (BOOL) isFirstLaunch;
- (BOOL) appHasBeenUpdated;
- (BOOL) appIsAvailableOnStoreForCurrentRegion;
- (void) loadAppsWithArtistId:(NSInteger) artistId completionBlock:(StoreAppsResultBlock) block;

@end

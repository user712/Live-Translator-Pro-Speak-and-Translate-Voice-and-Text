//
//  RemoteSettingsManager.m
//
//   23/12/15.
//  Copyright © 2015 dev. 
//

#import "RemoteSettingsManager.h"
#import "Tools.h"
#import "AppInfo.h"
#import "KeysManager.h"

#define APP_SETTINGS_FETCHING_URL @"http://secret.zemralab.com/api/%@/settings"

@interface RemoteSettingsManager()

@property (nonatomic, assign) BOOL settingsFetched;

@end

@implementation RemoteSettingsManager

+ (id) sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void) loadRemoteSettingsWithCompletion:(RemoteSettingsRequestCompletionBlock) completionBlock
{
    if (self.settingsFetched)
    {
        if (completionBlock)
        {
            completionBlock(nil);
        }
        return;
    }

    NSString *urlString = [NSString stringWithFormat:APP_SETTINGS_FETCHING_URL, [Tools bundleAndVersionString]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (!connectionError)
        {
            NSError *jsonError;
            NSJSONSerialization *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if ([jsonResponse isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = (NSDictionary *) jsonResponse;
                NSNumber *successOperation = dict[@"status"];
                
                if (successOperation && successOperation.intValue == 200)
                {
                    NSDictionary *settingsDictionary = dict[@"data"];
                    if (settingsDictionary && ![settingsDictionary isKindOfClass:[NSNull class]])
                    {
                        self.settingsFetched = YES;
                        
                        NSString *shareURL = settingsDictionary[@"sharelink"];
                        
                        if (shareURL && shareURL.length > 0)
                        {
                            [[AppInfo sharedManager] updateShortAppURL:shareURL];
                        }
                        
                        NSString *apiKeyYandexString = settingsDictionary[@"apiKeyYandex"];
                        if (apiKeyYandexString && apiKeyYandexString.length > 0)
                        {
                            [[KeysManager sharedManager] setApiKeyYandex:apiKeyYandexString];
                        }
                        
                        NSString *apiKeyGoogleString = settingsDictionary[@"apiKeyGoogle"];
                        if (apiKeyGoogleString && apiKeyGoogleString.length > 0)
                        {
                            [[KeysManager sharedManager] setApiKeyGoogle:apiKeyGoogleString];
                        }
                        
                        NSString *appIdNuanceString = settingsDictionary[@"appIdNuance"];
                        if (appIdNuanceString && appIdNuanceString.length > 0)
                        {
                            [[KeysManager sharedManager] setAppIdNuance:appIdNuanceString];
                        }
                        
                        NSString *appIdWatchNuanceString = settingsDictionary[@"appIdWatchNuance"];
                        if (appIdWatchNuanceString && appIdWatchNuanceString.length > 0)
                        {
                            [[KeysManager sharedManager] setAppIdWatchNuance:appIdWatchNuanceString];
                        }
                        
                        NSString *appKeyWatchNuanceString = settingsDictionary[@"appKeyWatchNuance"];
                        if (appKeyWatchNuanceString && appKeyWatchNuanceString.length > 0)
                        {
                            [[KeysManager sharedManager] setAppKeyWatchNuance:appKeyWatchNuanceString];
                        }
                    }
                }
            }
        }
        else
        {
            NSLog(@"Connection Error: %@", connectionError.localizedDescription);
        }
        
        completionBlock(connectionError);
    }];
}

@end

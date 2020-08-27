//
//  AppInfo.m
//  MyApp5
//
//   Radu on 6/16/16.
//  Copyright © 2016 kat. 
//

#import "AppInfo.h"
#import "AFNetworking.h"
#import "AppRaterManager.h"

#pragma mark - Application Class
@implementation Application

- (id) initWithResult:(NSDictionary *) result
{
    NSString *kind = [result objectForKey:@"kind"];
    if (![kind isEqualToString:@"software"])
    {
        return nil;
    }
    self = [super init];
    if (self)
    {
        NSString *appName = result[@"trackName"];
        NSString *appDescription = result[@"description"];
        NSString *appArtworkURL = result[@"artworkUrl100"];
        NSString *appURL = result[@"trackViewUrl"];
        NSString *appGenre = result[@"primaryGenreName"];
        
        if (!appName) appName = @"Unknown name";
        if (!appDescription) appDescription = @"Unknown description";
        if (!appArtworkURL) appArtworkURL = @"unknown";
        if (!appURL) appURL = @"unknown";
        if (!appGenre) appGenre = @"Unknown genre";
        
        self.appName = appName;
        self.appDescription = appDescription;
        self.appIconURL = appArtworkURL;
        self.appURL = appURL;
        self.appPrimaryGenre = appGenre;
        
        NSArray *features = [result objectForKey:@"features"];
        BOOL isUniversal = [features containsObject:@"iosUniversal"];
        NSString *minimumOsVersion = [result objectForKey:@"minimumOsVersion"];
        
        //App compatibility check
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        //Apps are only compatible if the current OS is above the minimum version
        if ([minimumOsVersion compare:systemVersion options:NSNumericSearch] != NSOrderedDescending)
        {
            if (isUniversal)
            {
                //App is universally compatible
                _isCompatible = YES;
            }
            else
            {
                UIUserInterfaceIdiom interfaceIdiom = [[UIDevice currentDevice] userInterfaceIdiom];
                switch (interfaceIdiom)
                {
                    case UIUserInterfaceIdiomPhone:
                    {
                        //App is only compatible with Phone if it contains screenshot urls
                        NSArray *screenshotUrls = [result objectForKey:@"screenshotUrls"];
                        _isCompatible = (screenshotUrls.count > 0);
                    }   break;
                    case UIUserInterfaceIdiomPad:
                    {
                        //App is compatible with Pad if it contains screenshot urls
                        NSArray *screenshotUrls = [result objectForKey:@"screenshotUrls"];
                        if (screenshotUrls.count > 0)
                        {
                            _isCompatible = YES;
                        }
                        else
                        {
                            //Or if it contains ipad screenshot urls
                            NSArray *ipadScreenshotUrls = [result objectForKey:@"ipadScreenshotUrls"];
                            _isCompatible = (ipadScreenshotUrls.count > 0);
                        }
                    }   break;
                    default:
                    {
                        // Future interface idiom? Better to display incompatible apps than none at all
                        _isCompatible = YES;
                    }   break;
                }
            }
        }
    }
    return self;
}

@end

#pragma mark - AppInfo Class
@interface AppInfo()

@property (copy, nonatomic) NSString *applicationID;
@property (copy, nonatomic) NSString *shortURL;
@property (nonatomic, assign) BOOL firstLaunch;
@property (nonatomic, assign) BOOL appWasUpdated;
@property (nonatomic, assign) BOOL appAvailableInStoreForDeviceRegion;

@end

@implementation AppInfo

#pragma mark - Initializations
+ (AppInfo *) sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void) checkLaunchNumber
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // app already launched
        self.firstLaunch = NO;
    }
    else
    {
        // This is the first launch ever
        self.firstLaunch = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void) checkAppUpdate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *currentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *previousVersion = [defaults objectForKey:@"applicationVersion"];
    if (!previousVersion)
    {
        self.appWasUpdated = YES;
        [defaults setObject:currentAppVersion forKey:@"applicationVersion"];
        [defaults synchronize];
    }
    else if ([previousVersion isEqualToString:currentAppVersion])
    {
        //same version
        self.appWasUpdated = NO;
    }
    else
    {
        self.appWasUpdated = YES;
        [defaults setObject:currentAppVersion forKey:@"applicationVersion"];
        [defaults synchronize];
    }
}

- (id) init
{
    self = [super init];
    if (self)
    {
        [self checkLaunchNumber];
        [self checkAppUpdate];
    }
    return self;
}

#pragma mark - Info
- (void) updateInfoWithCompletion:(AppInfoResultBlock) completion
{
    [self updateAppIDWithCompletion:^(BOOL success) {
        
        if (success)
        {
            if (completion)
            {
                completion(success);
            }
            
            /*[self updateShortURLWithCompletion:^(BOOL success) {
             
             if (completion)
             {
             completion(success);
             }
             }];*/
        }
        else
        {
            if (completion)
            {
                completion(success);
            }
        }
    }];
}

- (NSString *) storeBundleLookupLink
{
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?bundleId=%@&country=%@", [self bundleID], [countryCode lowercaseString]];
    return urlString;
}

- (NSString *) storeLookupLinkForAppID:(NSString *) appID
{
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@&country=%@", appID, [countryCode lowercaseString]];
    return urlString;
}

- (void) updateAppIDWithCompletion:(AppInfoResultBlock) completion
{
    if (self.applicationID && self.applicationID.length > 0)
    {
        if (completion)
        {
            completion(YES);
        }
        return;
    }
    NSURL *url = [NSURL URLWithString:[self storeBundleLookupLink]];
    NSURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        BOOL success = NO;
        
        if (!connectionError)
        {
            NSError *jsonError;
            NSJSONSerialization *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError && [jsonResponse isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = (NSDictionary *) jsonResponse;
                
                NSArray *resultsArray = dict[@"results"];
                if (resultsArray && resultsArray.count > 0)
                {
                    NSDictionary *infoDict = [resultsArray firstObject];
                    NSString *trackID = [NSString stringWithFormat:@"%@", infoDict[@"trackId"]];
                    
                    if (trackID && trackID.length > 0)
                    {
                        self.applicationID = trackID;
                        success = YES;
                    }
                }
            }
        }
        else
        {
            success = NO;
        }
        
        if (completion)
        {
            completion(success);
        }
    }];
}

- (NSString *) extractAppIDFromLink:(NSString *) urlString
{
    NSString *appID = nil;
    NSRange idRange = [urlString rangeOfString:@"/id"];
    if (idRange.location != NSNotFound)
    {
        NSURL *url = [NSURL URLWithString:urlString];
        appID = [url.lastPathComponent stringByReplacingOccurrencesOfString:@"id" withString:@""];
    }
    return appID;
}

- (void) recheckAppAvailabilityInStoreForCurrentRegionWithCompletion:(AppInfoResultBlock) completion
{
    if (self.appAvailableInStoreForDeviceRegion)
    {
        if (completion)
        {
            completion(YES);
        }
        return;
    }
    
    if (![self shareLinkIsWorking])
    {
        if (completion)
        {
            completion(NO);
        }
        return;
    }
    
    NSString *appIDFromShareLink = [self extractAppIDFromLink:self.shortURL];
    if (!appIDFromShareLink || appIDFromShareLink.length == 0)
    {
        if (completion)
        {
            completion(NO);
        }
        return;
    }
    
    self.applicationID = appIDFromShareLink;
    NSString *urlString = [self storeLookupLinkForAppID:appIDFromShareLink];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        BOOL success = NO;
        
        if (!connectionError)
        {
            NSError *jsonError;
            NSJSONSerialization *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError && [jsonResponse isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = (NSDictionary *) jsonResponse;

                NSArray *resultsArray = dict[@"results"];
                if (resultsArray && resultsArray.count > 0)
                {
                    success = YES;
                    self.appAvailableInStoreForDeviceRegion = YES;
                }
            }
        }
        else
        {
            success = NO;
        }
        
        if (completion)
        {
            completion(success);
        }
    }];
}

- (void) updateShortURLWithCompletion:(AppInfoResultBlock) completion
{
    NSString *urlString = [NSString stringWithFormat:@"https://is.gd/create.php?format=simple&url=%@", [self storeAppLink]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        BOOL success = NO;
        
        if (!connectionError)
        {
            NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            self.shortURL = resultString;
        }
        else
        {
            success = NO;
        }
        
        if (completion)
        {
            completion(success);
        }
    }];
}

- (NSString *) bundleID
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

- (NSString *) appName
{
    NSDictionary *infoPList = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoPList objectForKey:@"CFBundleDisplayName"];
    return appName;
}

- (NSString *) appID
{
    return self.applicationID;
}

- (void) setApplicationID:(NSString *) applicationID
{
    _applicationID = applicationID;
    [[AppRaterManager sharedManager] updateAppID:applicationID];
}

- (NSString *) storeAppLink
{
    return [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",_applicationID];
}

- (NSString *) redirectStoreAppLink
{
    return [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",_applicationID];
}

- (NSString *) shortAppURL
{
    return self.shortURL;
}

- (void) updateShortAppURL:(NSString *) shareURL
{
    self.shortURL = shareURL;
    [self recheckAppAvailabilityInStoreForCurrentRegionWithCompletion:nil];
}

- (BOOL) shareLinkIsWorking
{
    BOOL shareLinksIsNotNil = (self.shortURL != nil && self.shortURL.length > 0);
    return shareLinksIsNotNil;
}

- (BOOL) isFirstLaunch
{
    return self.firstLaunch;
}

- (BOOL) appHasBeenUpdated
{
    return self.appWasUpdated;
}

- (BOOL) appIsAvailableOnStoreForCurrentRegion
{
    return self.appAvailableInStoreForDeviceRegion;
}

#pragma mark - Fetch Store Apps For Certain Developer
- (void) loadAppsWithArtistId:(NSInteger) artistId completionBlock:(StoreAppsResultBlock) block
{
    NSString *requestPath = [NSString stringWithFormat:@"lookup?id=%i", (int)artistId];
    
    [self loadRequestPath:requestPath withCompletion:^(NSArray *results, NSError *error) {
        
        if (error)
        {
            if (block)
            {
                block(nil, error);
            }
        }
        else
        {
            //Parse array:
            NSMutableArray *resultArray = [NSMutableArray new];
            for (NSDictionary *result in results)
            {
                BOOL isSoftwareWrapper = [[result objectForKey:@"wrapperType"] isEqualToString:@"software"];
                if (isSoftwareWrapper)
                {
                    NSUInteger appID = [result[@"trackId"] integerValue];
                    
                    if (appID != [self.applicationID integerValue]) //Do not show current app in the list
                    {
                        Application *app = [[Application alloc] initWithResult:result];
                        if (app.isCompatible)
                        {
                            [resultArray addObject:app];
                        }
                    }
                }
            }
            if (block)
            {
                block(resultArray, nil);
            }
        }
    }];
}

- (void) loadRequestPath:(NSString *) path withCompletion:(void (^)(NSArray *results, NSError *error)) completion
{
    NSMutableString *requestUrlString = [[NSMutableString alloc] init];
    [requestUrlString appendString:@"http://itunes.apple.com/"];
    [requestUrlString appendString:path];
    [requestUrlString appendFormat:@"&entity=software"];
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    if (countryCode)
    {
        [requestUrlString appendFormat:@"&country=%@", countryCode];
    }
    NSString *languagueCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    if (languagueCode)
    {
        [requestUrlString appendFormat:@"&l=%@", languagueCode];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:requestUrlString]];
    [request setTimeoutInterval:20.0f];
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    void (^returnWithResultsAndError)(NSArray *, NSError *) = ^void(NSArray *results, NSError *error) {
        if (completion)
        {
            completion(results, error);
        }
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
        {
            return returnWithResultsAndError(nil, connectionError);
        }
        
        NSError *jsonError;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError)
        {
            return returnWithResultsAndError(nil, jsonError);
        }
        
        NSArray *results = [jsonDictionary objectForKey:@"results"];
        returnWithResultsAndError(results, nil);
    }];
}

@end

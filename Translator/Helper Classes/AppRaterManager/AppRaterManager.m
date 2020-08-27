//
//  AppRaterManager.m
//  Translator
//
//   1/31/18.
//  
//

#import "AppRaterManager.h"
#import "Appirater.h"

@interface AppRaterManager()

@end

@implementation AppRaterManager

//MARK: Initializations
+ (id) sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

//MARK: Rate Methods
- (void) updateAppID:(NSString *) applicationID
{
    if (!applicationID || applicationID.length == 0)
    {
        return;
    }
    [Appirater setAppId:applicationID];
    [[NSUserDefaults standardUserDefaults] setObject:applicationID forKey:@"lastUsedAppIDForRater"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) loadRaterSettings
{
    NSString *lastUsedAppID = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUsedAppIDForRater"];
    if (lastUsedAppID)
    {
        [Appirater setAppId:lastUsedAppID];
    }
    [Appirater setDaysUntilPrompt:1];                   //After how many days after install/update show rate alert
    [Appirater setUsesUntilPrompt:4];                   //After how many app openings (foreground counts also) show rate alert
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];               //Remind later duration in days
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
}

- (void) appEnteredForeground
{
    [Appirater appEnteredForeground:YES];
}

@end

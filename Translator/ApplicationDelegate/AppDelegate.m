//
//  AppDelegate.m
//  Translator
//
//   10/26/15.
//  Copyright © 2015 Dev. 
//

#import "AppDelegate.h"
#import "PersistenStack.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "AFNetworking/AFNetworking.h"
#import "TranslationSourceDemon.h"
#import "MainAppConnectivity.h"
#import "AppInfo.h"
#import "AppRaterManager.h"
#import "SubscribeViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) PersistenStack *persistentStack;

@end

@implementation AppDelegate

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions
{
    [Fabric with:@[[Crashlytics class]]];
    [self adjustDefaultSettings];
    [self loadDefaultValues];
    [self startApplicationCustomLoadings];
    return YES;
}

- (void) applicationWillResignActive:(UIApplication *) application
{
    if ([DatabaseDemon summon].myLastTranslation != nil) // should clear the whole crash
    {
        NSInteger foo = [[DatabaseDemon summon].transFromCoreData indexOfObject:[DatabaseDemon summon].myLastTranslation];
        [[NSUserDefaults standardUserDefaults] setObject:@(foo) forKey:@"lastTransIndex"];
    }
}

- (void) applicationDidEnterBackground:(UIApplication *) application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void) applicationWillEnterForeground:(UIApplication *) application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[AppRaterManager sharedManager] appEnteredForeground];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastTransIndex"])
    {
        if ((BOOL)[[[NSUserDefaults standardUserDefaults] objectForKey:@"lastTransIndex"] isEqual:@(9223372036854775807)] || (BOOL) [[[NSUserDefaults standardUserDefaults] objectForKey:@"lastTransIndex"] isEqual:@(2147483647)])
        {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"lastTransIndex"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            [[DatabaseDemon summon] loadHistoryFromCoreData];
            NSNumber *lastTrans = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lastTransIndex"];
            if ([lastTrans doubleValue] < [[DatabaseDemon summon].transFromCoreData count])
            {
                [DatabaseDemon summon].myLastTranslation = [[DatabaseDemon summon].transFromCoreData objectAtIndex:[lastTrans integerValue]];
            }
        }
    }
}

- (void) applicationDidBecomeActive:(UIApplication *) application
{
    
}

- (void) applicationWillTerminate:(UIApplication *) application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"lastTransIndex"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"textThatWasOnTop"];
    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"awaitingTranslateJustNeedALanguageSelected"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"textThatWasOnTop"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"lastNoTTSNotifyLang"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Loadings
- (void) adjustDefaultSettings
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void) loadDefaultValues
{
    self.persistentStack = [[PersistenStack alloc] initWithStoreURL:self.storeURL modelURL:self.modelURL];
    self.managedObjectContext = self.persistentStack.managedObjectContext;
    [DatabaseDemon summon].managedObjectContext = self.managedObjectContext;
}

- (void) startApplicationCustomLoadings
{
    LoadingSettingsViewController *loadingVC = [[LoadingSettingsViewController alloc] initWithNibName:@"LoadingSettingsViewController" bundle:nil];
    loadingVC.delegate = self;
    self.window.rootViewController = loadingVC;
    [self.window makeKeyAndVisible];
}

- (void) loadApplication
{
    [self loadViews];
    [self loadAppServices];
    [self updateUI];
}

- (void) updateUI
{
    UIColor *appHighlightColor = [UIColor blueColor];
    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:appHighlightColor];
    [self.window.layer setCornerRadius:4.0f];
    [self.window.layer setMasksToBounds:YES];
}

- (void) loadViews
{
    BOOL subscriptionExpired = [[SubscriptionManager sharedManager] isSubscriptionExpired];
    if (subscriptionExpired)
    {
        [self showSubscriptionView];
    }
    else
    {
        [self showTranslator];
    }
}

- (void) showSubscriptionView
{
    SubscribeViewController *subscribeViewController = [[SubscribeViewController alloc] initWithNibName:@"SubscribeViewController" bundle:nil];
    self.window.rootViewController = subscribeViewController;
    [self.window makeKeyAndVisible];
}

- (void) showTranslator
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CustomTabBarController *tbc = [mainStoryboard instantiateInitialViewController];
    self.window.rootViewController = tbc;
    [self.window makeKeyAndVisible];
}

- (void) loadAppServices
{
    [[AppInfo sharedManager] updateInfoWithCompletion:nil];
    [[DatabaseDemon summon] loadHistoryFromCoreData];
    [[MainAppConnectivity sharedConnection] activateWatchSession];
    [TranslationSourceDemon summom];
    [[AppRaterManager sharedManager] loadRaterSettings];
    [[SubscriptionManager sharedManager] startSubscriptionManager];
}

#pragma mark - Core Data
- (NSURL *) storeURL
{
    NSURL *documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    return [documentsDirectory URLByAppendingPathComponent:@"Translator.sqlite"];
}

- (NSURL *) modelURL
{
    return [[NSBundle mainBundle] URLForResource:@"translateHistory" withExtension:@"momd"];
}

#pragma mark - LoadingViewControllerDelegate Methods
- (void) finishedLoadingKeys
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self loadApplication];
    });
}

@end

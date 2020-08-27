//
//  AppDelegate.h
//  Translator
//
//   10/26/15.
//  Copyright © 2015 Dev. 
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DatabaseDemon.h"
#import "CustomTabBarController.h"
#import "LoadingSettingsViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, LoadingSettingsViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CustomTabBarController *tabBarController;

- (void) showSubscriptionView;
- (void) showTranslator;

@end


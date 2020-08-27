//
//  LoadingSettingsViewController.m
//
//   05/05/15.
//  Copyright (c) 2015 dev. 
//

#import "LoadingSettingsViewController.h"
#import "RemoteSettingsManager.h"

@interface LoadingSettingsViewController ()

@end

@implementation LoadingSettingsViewController

#pragma mark - Initializations
- (void) updateUI
{
    self.loadingActivityIndicator.color = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void) initLaunchImage
{
    NSString *launchImageName;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([UIScreen mainScreen].bounds.size.height == 480) launchImageName = @"LaunchImage-700@2x.png"; // iPhone 4/4s, 3.5 inch screen
        else if ([UIScreen mainScreen].bounds.size.height == 568) launchImageName = @"LaunchImage-700-568h@2x.png"; // iPhone 5/5s, 4.0 inch screen
        else if ([UIScreen mainScreen].bounds.size.height == 667) launchImageName = @"LaunchImage-800-667h@2x.png"; // iPhone 6, 4.7 inch screen
        else if ([UIScreen mainScreen].bounds.size.height == 736) launchImageName = @"LaunchImage-800-Portrait-736h@3x.png"; // iPhone 6+, 5.5 inch screen
        else launchImageName = @"LaunchImage-800-Portrait-736h@3x.png";
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if ([UIScreen mainScreen].scale == 1) launchImageName = @"LaunchImage-700-Portrait~ipad.png"; // iPad 2
        else if ([UIScreen mainScreen].scale == 2) launchImageName = @"LaunchImage-700-Portrait@2x~ipad.png"; // Retina iPads
    }
    self.splashImageView.image = [UIImage imageNamed:launchImageName];
}

#pragma mark - View Controller Methods
- (void) viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
    [self initLaunchImage];
    [self loadAppSettings];
}

#pragma mark - Loadings
- (void) loadAppSettings
{
    __block NSError *settingsError = nil;
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    //Load settings:
    [[RemoteSettingsManager sharedManager] loadRemoteSettingsWithCompletion:^(NSError *error) {
        
        NSLog(@"***Remote Settings success");
        settingsError = error;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group,dispatch_get_main_queue(),^{
        
        NSLog(@"***COMPLETION");
        if ([self.delegate respondsToSelector:@selector(finishedLoadingKeys)])
        {
            [self.delegate finishedLoadingKeys];
        }
    });
}

@end

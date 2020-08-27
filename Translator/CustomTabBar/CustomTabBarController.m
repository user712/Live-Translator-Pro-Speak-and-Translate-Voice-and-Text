//
//  CustomTabBarController.m
//  Translator
//
//   1/12/18.
//  
//

#import "CustomTabBarController.h"

const NSInteger tabChangeFrequencyToShowAds = 5;

@interface CustomTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, assign) NSInteger tabChangeCounter;

@end

@implementation CustomTabBarController

#pragma mark - View Controller LifeCycle Methods
- (void) viewDidLoad
{
    [super viewDidLoad];
    [self loadTabBarIcons];
    [self defaultInits];
}

#pragma mark - Loading
- (void) defaultInits
{
    self.delegate = self;
    self.tabChangeCounter = 0;
}

- (void) loadTabBarIcons
{
    UITabBarItem *item1 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *item2 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *item3 = [self.tabBar.items objectAtIndex:2];
    UITabBarItem *item4 = [self.tabBar.items objectAtIndex:3];
    
    UIImage *unselectedImage1 = [UIImage imageNamed:@"HomeIcon"];
    UIImage *selectedImage1 = [UIImage imageNamed:@"HomeIconSelected"];
    
    UIImage *unselectedImage2 = [UIImage imageNamed:@"FavoriteIcon"];
    UIImage *selectedImage2 = [UIImage imageNamed:@"FavoriteIconSelected"];
    
    UIImage *unselectedImage3 = [UIImage imageNamed:@"HistoryIcon"];
    UIImage *selectedImage3 = [UIImage imageNamed:@"HistoryIconSelected"];
    
    UIImage *unselectedImage4 = [UIImage imageNamed:@"SettingsIcon"];
    UIImage *selectedImage4 = [UIImage imageNamed:@"SettingsIconSelected"];
    
    [item1 setImage:[unselectedImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setSelectedImage:[selectedImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [item2 setImage:[unselectedImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setSelectedImage:[selectedImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [item3 setImage:[unselectedImage3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setSelectedImage:[selectedImage3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [item4 setImage:[unselectedImage4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setSelectedImage:[selectedImage4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIColor *normalColor = [AppColors appGrayColor];
    UIColor *selectedColorItem1 = [AppColors appBlueColor];
    UIColor *selectedColorItem2 = [AppColors appRedColor];
    UIColor *selectedColorItem3 = [AppColors appPurpleColor];
    UIColor *selectedColorItem4 = [AppColors appGreenColor];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : normalColor , NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:10.0] } forState:UIControlStateNormal];
    
    [item1 setTitleTextAttributes:@{ NSForegroundColorAttributeName : selectedColorItem1 , NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:10.0] } forState:UIControlStateSelected];
    [item2 setTitleTextAttributes:@{ NSForegroundColorAttributeName : selectedColorItem2 , NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:10.0] } forState:UIControlStateSelected];
    [item3 setTitleTextAttributes:@{ NSForegroundColorAttributeName : selectedColorItem3 , NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:10.0] } forState:UIControlStateSelected];
    [item4 setTitleTextAttributes:@{ NSForegroundColorAttributeName : selectedColorItem4 , NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:10.0] } forState:UIControlStateSelected];
}

#pragma mark - UITabBarControllerDelegate Methods
- (void) tabBarController:(UITabBarController *) tabBarController didSelectViewController:(UIViewController *) viewController
{
    self.tabChangeCounter++;
    if (self.tabChangeCounter % tabChangeFrequencyToShowAds == 0)
    {
        [self showInterstitialAds];
    }
}

- (void) showInterstitialAds
{
}

@end

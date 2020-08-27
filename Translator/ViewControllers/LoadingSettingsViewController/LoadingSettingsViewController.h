//
//  LoadingSettingsViewController.h
//
//   05/05/15.
//  Copyright (c) 2015 dev. 
//

#import <UIKit/UIKit.h>

@protocol LoadingSettingsViewControllerDelegate <NSObject>

- (void) finishedLoadingKeys;

@end

@interface LoadingSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *splashImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
@property (nonatomic, weak) id <LoadingSettingsViewControllerDelegate> delegate;

@end

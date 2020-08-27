//
//  AboutViewController.h
//  
//
//   4/28/16.
//
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *AppName;
@property (weak, nonatomic) IBOutlet UILabel *AppVersion;

- (IBAction) EULA:(id) sender;
- (IBAction) backButtonPressed:(id) sender;

@end

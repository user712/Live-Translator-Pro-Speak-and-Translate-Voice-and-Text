//
//  AboutViewController.m
//  
//
//   4/28/16.
//
//

#import "AboutViewController.h"

#define nuanceURL @"http://www.nuance.com/ucmprod/groups/imaging/@web-enus/documents/collateral/nc_041406.pdf"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nuanceLogoImageView;
@property (weak, nonatomic) IBOutlet UIButton *nuanceEULAButton;
@property (weak, nonatomic) IBOutlet UIView *topBackgroundView;

@end

@implementation AboutViewController

#pragma mark - Initializations
- (void) localizeText
{
    self.titleLabel.text = NSLocalizedString(@"About", nil);
}

#pragma mark - View Controller LifeCycle Methods
- (void) viewDidLoad
{
    [super viewDidLoad];
    [self localizeText];
    [self updateUI];
}

- (void) updateUI
{
    [_AppName setText:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
    [_AppVersion setText:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

#pragma mark - UI Control Events
- (IBAction) backButtonPressed:(id) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) EULA:(id) sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: nuanceURL]];
}

@end

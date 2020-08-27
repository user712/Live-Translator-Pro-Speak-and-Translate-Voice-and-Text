//
//  SubscriptionInfoViewController.m
//  Translator
//
//   5/16/18.
//  
//

#import "SubscriptionInfoViewController.h"

@interface SubscriptionInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation SubscriptionInfoViewController

//MARK: View Controller LifeCycle Methods
- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setupSubscriptionText];
    [self localizeText];
}

//MARK: Initializations
- (void) localizeText
{
    self.titleLabel.text = NSLocalizedString(@"Subscription", nil);
}

- (void) setupSubscriptionText
{
    NSString *price = [[[SubscriptionManager sharedManager] appSubscription] localPrice];
    NSString *freePeriod = [[[SubscriptionManager sharedManager] appSubscription] trialPeriod];
    NSString *subscriptionPeriod = [[[SubscriptionManager sharedManager] appSubscription] subscriptionPeriod];
    if (!price) price = @"$X";
    if (!freePeriod) freePeriod = [NSString stringWithFormat:@"%d %@", 1, NSLocalizedString(@"week", nil)];
    if (!subscriptionPeriod) subscriptionPeriod = NSLocalizedString(@"month", nil);

    NSString *subscriptionInfo = [NSString stringWithFormat:NSLocalizedString(@"subscriptionInfoKey", nil), freePeriod, price, subscriptionPeriod, subscriptionTermsLink, subscriptionPrivacyLink];
    NSMutableAttributedString *yourAttributedString = [[NSMutableAttributedString alloc] initWithString:subscriptionInfo];
    
    NSRange r1 = [subscriptionInfo rangeOfString:@"&&"];
    NSRange r2 = [subscriptionInfo rangeOfString:@"++"];
    NSRange boldRange = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
    NSRange range = [subscriptionInfo rangeOfString:subscriptionInfo];
    
    [yourAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:17] range:range];
    [yourAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:17] range:boldRange];
    
    [yourAttributedString replaceCharactersInRange:r1 withString:@""];
    NSRange r3 = [subscriptionInfo rangeOfString:@"++"];
    [yourAttributedString replaceCharactersInRange:NSMakeRange(r3.location - r3.length, r3.length) withString:@""];
    [self.infoTextView setAttributedText:yourAttributedString];
}

//MARK: UI Events
- (IBAction) closeButtonPressed:(id) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

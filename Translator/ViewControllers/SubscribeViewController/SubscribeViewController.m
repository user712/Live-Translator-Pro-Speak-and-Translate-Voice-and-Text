//
//  SubscribeViewController.m
//  Translator
//
//   5/14/18.
//  
//

#import "SubscribeViewController.h"
#import "SubscriptionManager.h"

@interface SubscribeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageVIew;
@property (weak, nonatomic) IBOutlet UIButton *privacyButton;
@property (weak, nonatomic) IBOutlet UIButton *termsButton;
@property (weak, nonatomic) IBOutlet UILabel *linksLabel;
@property (weak, nonatomic) IBOutlet UILabel *subscriptionDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleCellOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailCellOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleCellTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailCellTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleCellThreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailCellThreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTrialLabel;
@property (weak, nonatomic) IBOutlet UILabel *freePeriodLabel;
@property (weak, nonatomic) IBOutlet UIButton *restorePurchasesButton;
@property (weak, nonatomic) IBOutlet UILabel *restorePurchasesLabel;

@end

@implementation SubscribeViewController

//MARK: View Controller LifeCycle Methods
- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setupScrollViewContent];
    [self updateUI];
    [self setupLinksButtonsUI];
    [self addObservers];
    [self localizeText];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.size.width = self.scrollView.bounds.size.width;
    contentViewFrame.size.height = MAX(self.scrollView.frame.size.height, contentViewFrame.size.height);
    self.contentView.frame = contentViewFrame;
    self.scrollView.contentSize = self.contentView.frame.size;
}

//MARK: Initializations
- (void) setupScrollViewContent
{
    [self.scrollView addSubview:self.contentView];
}

- (void) setupLinksButtonsUI
{
    NSString *privacyTitle = [NSString stringWithFormat:@"   %@", NSLocalizedString(@"privacyPolicyKey", nil)];
    NSString *termsTitle = [NSString stringWithFormat:@"   %@", NSLocalizedString(@"termsOfServiceKey", nil)];
    
    NSDictionary *linkAttributesPrivacy = @{NSForegroundColorAttributeName:self.privacyButton.titleLabel.textColor, NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)};
    NSAttributedString *attributedStringPrivacy = [[NSAttributedString alloc] initWithString:privacyTitle attributes:linkAttributesPrivacy];
    [self.privacyButton.titleLabel setAttributedText:attributedStringPrivacy];
    
    NSDictionary * linkAttributesTerms = @{NSForegroundColorAttributeName:self.termsButton.titleLabel.textColor, NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)};
    NSAttributedString *attributedStringTerms = [[NSAttributedString alloc] initWithString:termsTitle attributes:linkAttributesTerms];
    [self.termsButton.titleLabel setAttributedText:attributedStringTerms];
}

- (void) updateUI
{
    self.view.backgroundColor = [AppColors appBlueColor];
}

- (void) localizeText
{
    [self updateSubscriptionData];
    
    self.linksLabel.text = NSLocalizedString(@"Links", nil);
    self.startTrialLabel.text = [NSLocalizedString(@"startKey", nil) uppercaseString];
    self.titleCellOneLabel.text = [NSLocalizedString(@"exploreKey", nil) capitalizedString];
    self.detailCellOneLabel.text = [NSLocalizedString(@"anyLanguageKey", nil) capitalizedString];
    self.titleCellTwoLabel.text = [NSLocalizedString(@"communicateKey", nil) capitalizedString];
    self.detailCellTwoLabel.text = [NSLocalizedString(@"expressYourselfKey", nil) capitalizedString];
    self.titleCellThreeLabel.text = [NSLocalizedString(@"chooseKey", nil) capitalizedString];
    self.detailCellThreeLabel.text = [NSLocalizedString(@"andTranslateKey", nil) capitalizedString];
    self.restorePurchasesLabel.text = [NSLocalizedString(@"restorePurchasesKey", nil) uppercaseString];
}

- (void) hideTrialInfo
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         
                         self.freePeriodLabel.hidden = YES;
                         self.startTrialLabel.frame = self.startTrialLabel.superview.bounds;
                     }
                     completion:NULL];
}

- (void) showTrialInfo
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         
                         self.freePeriodLabel.hidden = NO;
                         
                         CGRect frame = self.startTrialLabel.frame;
                         frame.size.height = self.startTrialLabel.superview.bounds.size.height - self.freePeriodLabel.frame.size.height;
                         self.startTrialLabel.frame = frame;
                     }
                     completion:NULL];
}

- (void) updateSubscriptionData
{
    NSString *price = [[[SubscriptionManager sharedManager] appSubscription] localPrice];
    NSString *subscriptionPeriod = [[[SubscriptionManager sharedManager] appSubscription] subscriptionPeriod];
    if (!price) price = @"$X";
    if (!subscriptionPeriod) subscriptionPeriod = @"X";
    
    NSString *freePeriod = [[[SubscriptionManager sharedManager] appSubscription] trialPeriod];
    if (freePeriod)
    {
        BOOL trialPeriodExpired = [[SubscriptionManager sharedManager] isTrialPeriodExpired];
        trialPeriodExpired ? [self hideTrialInfo] : [self showTrialInfo];
    }
    else
    {
        if (!freePeriod) freePeriod = @"X";
        self.freePeriodLabel.hidden = YES;
    }
    self.subscriptionDescriptionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"subscriptionShortInfoKey", nil), freePeriod, price, subscriptionPeriod];
    self.freePeriodLabel.text = [NSString stringWithFormat:@"%@ %@", freePeriod, NSLocalizedString(@"free", nil)];
}

- (void) addObservers
{
    [[NSNotificationCenter defaultCenter] addObserverForName:SubscriptionManagerProductsReceivedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          [self updateSubscriptionData];
                                                      });
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SubscriptionStartLoadingAnimationNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          //start loading custom animation
                                                      });
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SubscriptionStopLoadingAnimationNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          //stop loading custom animation
                                                      });
                                                  }];
}

- (void) removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//MARK: UI Events
- (IBAction) startButtonPressed:(id) sender
{
    [[SubscriptionManager sharedManager] purchaseAppSubscription];
}

- (IBAction) privacyButtonPressed:(id) sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:subscriptionPrivacyLink]];
}

- (IBAction) termsButtonPressed:(id) sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:subscriptionTermsLink]];
}

- (IBAction) restorePurchasesButtonPressed:(id) sender
{
    [[SubscriptionManager sharedManager] restorePurchases];
}

//MARK: Deallocations
- (void) dealloc
{
    [self removeObservers];
}

@end

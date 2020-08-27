//
//  HomeViewController.h
//  Translator
//
//   1/21/16.
//  Copyright © 2016 Dev. 
//

#import <UIKit/UIKit.h>
#import "LanguageSelectDemon.h"
#import "LanguageList.h"
#import "TranslationManager.h"
#import "TranslationHistory.h"
#import "DatabaseDemon.h"
#import "SpeechManagerSeetings.h"
#import "SpeechManagerNuance.h"
#import "WSCoachMarksView.h"

@interface HomeViewController : UIViewController <UITextViewDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITabBarItem *navBarHome;

// TOP BLUE  - top
@property (weak, nonatomic) IBOutlet UIButton *topMicButton;
@property (weak, nonatomic) IBOutlet UILabel *topLanguageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topLanguageFlag;
@property (weak, nonatomic) IBOutlet UIButton *topSelectLanguageButton; //should not need, but to be shure
@property (weak, nonatomic) IBOutlet UIButton *topDeleteButton;         //should not need, but to be shure
@property (weak, nonatomic) IBOutlet UITextView *topTextView;
@property (weak, nonatomic) IBOutlet UILabel *topHiddenSpeakIndicator;
@property (weak, nonatomic) IBOutlet UIView *topView;

- (IBAction) topMicButtonPressed:(id) sender;
- (IBAction) topSelectLanguageButtonWasPressed:(id) sender;               //should not need, but to be shure
- (IBAction) topDeleteButtonWasPressed:(id) sender;

//BOTTOM WHITE  - bot
@property (weak, nonatomic) IBOutlet UIButton *botMicButton;
@property (weak, nonatomic) IBOutlet UILabel *botLanguageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *botLanguageFlag;
@property (weak, nonatomic) IBOutlet UIButton *botSelectLanguageButton; //should not need, but to be shure
@property (weak, nonatomic) IBOutlet UIButton *botFavoriteButton;
@property (weak, nonatomic) IBOutlet UITextView *botTextView;
@property (weak, nonatomic) IBOutlet UILabel *botHiddenSpeakIndicator;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *moveBotToTop;
@property (weak, nonatomic) IBOutlet UIView *botView;

- (IBAction) botFavoriteButtonWasPressed:(id) sender;
- (IBAction) botMicButtonWasPressed:(id) sender;
- (IBAction) botSelectLanguageButtonWasPressed:(id) sender;               //should not need, but to be shure
- (IBAction) moveBotToTop:(id) sender;

@end

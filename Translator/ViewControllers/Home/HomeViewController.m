//
//  HomeViewController.m
//  Translator
//
//   1/21/16.
//  Copyright © 2016 Dev. 
//

#import "HomeViewController.h"
#import "ErrorMessageGenerator.h"
#import "KeysManager.h"
#import "PCAngularActivityIndicatorView.h"
#import "NSString+Additions.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *switchLanguagesButton;
@property (strong, nonatomic) PCAngularActivityIndicatorView *translateIndicator;
@property (strong, nonatomic) PCAngularActivityIndicatorView *listeningIndicator;

@end

@implementation HomeViewController

BOOL isASegue;

//MARK: View Controller LifeCycle Methods
- (void) awakeFromNib
{
    [super awakeFromNib];
    [_navBarHome setTitle:NSLocalizedString(@"navBarHome", nil)];
    _topHiddenSpeakIndicator.text = _botHiddenSpeakIndicator.text =  NSLocalizedString(@"hiddenMessage",nil);
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [[SpeechManagerNuance summon] initSpeechToTextSettings];
    _botMicButton.tag = 0;
    [self addObservers];
    [self updateUI];
    [self initTranslateLoading];
    [self initListeningLoading];
    [self setupButtonsBehaviour];
}

- (void) viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
    [self onViewAppearAction];
}

- (void) onViewAppearAction
{
    isASegue = NO;
    [self setupFlagImages];
    [self setupTheLabels];
    [self setFavState];
    [self setTextFromLastTrans];
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    
    if ([DatabaseDemon summon].myLastTranslation == nil)
    {
        [self cleanScreen];
        [_topTextView setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"textThatWasOnTop"]];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"awaitingTranslateJustNeedALanguageSelected"] isEqual:@(1)])
    {
        [self makeTranslate];
    }
    
    //dinamic button changing
    if ([[SpeechManagerSeetings summon] getParam:Speech_to_Text forLanguage:[[LanguageSelectDemon summon] currentSourceLanguage]] == nil)
    {
        [_topMicButton setBackgroundImage:[UIImage imageNamed:@"bnt_microphone_mute_White"] forState:UIControlStateNormal];
    }
    else
    {
        [_topMicButton setBackgroundImage:[UIImage imageNamed:@"bttnMicTop"] forState:UIControlStateNormal];
    }
    
    if ([[SpeechManagerSeetings summon] getParam:Text_to_Speech forLanguage:[[LanguageSelectDemon summon] getCurrentDestinationlanguage]] == nil)
    {
        [_botMicButton setBackgroundImage:[UIImage imageNamed:@"bnt_speakerMute"] forState:UIControlStateNormal];
        _topMicButton.tag = 0;
    }
    else
    {
        [_botMicButton setBackgroundImage:[UIImage imageNamed:@"bnt_speaker"] forState:UIControlStateNormal];
        _topMicButton.tag = 1;
    }
}

- (void) viewWillDisappear:(BOOL) animated
{
    isASegue = YES;
    
    if ([_topTextView hasText])
    {
        [[NSUserDefaults standardUserDefaults] setObject:_topTextView.text forKey:@"textThatWasOnTop"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [super viewWillDisappear:animated];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect switchButtonRect = self.switchLanguagesButton.frame;
    switchButtonRect.origin.y = self.topView.frame.origin.y + self.topView.frame.size.height - switchButtonRect.size.height / 2;
    self.switchLanguagesButton.frame = switchButtonRect;
    self.translateIndicator.center = self.switchLanguagesButton.center;
}

- (void) viewDidAppear:(BOOL) animated
{
    [super viewDidAppear:animated];
    [self initHelp];
}

- (void) viewDidDisappear:(BOOL) animated
{
    if (self.translateIndicator.animating)
    {
        [self.translateIndicator stopAnimating];
    }
    [super viewDidDisappear:animated];
}

- (void) updateUI
{
    self.topTextView.tintColor = [UIColor whiteColor];
}

- (void) addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordingStartedNotification:) name:SpeechManagerRecordingStartedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordingFinishedNotification:) name:SpeechManagerRecordingFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordingReceivedResultsNotification:) name:SpeechManagerRecordingReceivedResultsNotification object:nil];
}

- (void) removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//MARK: Initializations
- (void) initTranslateLoading
{
    self.translateIndicator = [[PCAngularActivityIndicatorView alloc] initWithActivityIndicatorStyle:PCAngularActivityIndicatorViewStyleLarge];
    self.translateIndicator.color = [AppColors appGreenColor];
    self.translateIndicator.hidesWhenStopped = YES;
    self.translateIndicator.userInteractionEnabled = NO;
    [self.view addSubview:self.translateIndicator];
}

- (void) initListeningLoading
{
    CGFloat padding = 6;
    CGSize spinnerSize = CGSizeMake(self.topMicButton.bounds.size.width - padding, self.topMicButton.bounds.size.height - padding);
    self.listeningIndicator = [[PCAngularActivityIndicatorView alloc] initWithCustomSize:spinnerSize lineWidth:2 andDuration:1.2];
    self.listeningIndicator.color = [[AppColors appBlueColor] colorWithAlphaComponent:0.8];
    self.listeningIndicator.hidesWhenStopped = YES;
    self.listeningIndicator.userInteractionEnabled = NO;
    [self.listeningIndicator stopAnimating];
    self.listeningIndicator.frame = CGRectMake(padding / 2, padding / 2, spinnerSize.width, spinnerSize.height);
    [self.topMicButton addSubview:self.listeningIndicator];
}

- (void) setupButtonsBehaviour
{
    self.switchLanguagesButton.exclusiveTouch = YES;
    self.topMicButton.exclusiveTouch = YES;
    self.botMicButton.exclusiveTouch = YES;
    self.botFavoriteButton.exclusiveTouch = YES;
    self.topDeleteButton.exclusiveTouch = YES;
    self.topSelectLanguageButton.exclusiveTouch = YES;
    self.botSelectLanguageButton.exclusiveTouch = YES;
}

#pragma mark - Observer Methods
- (void) recordingStartedNotification:(NSNotification *) notification
{
    [self lockAllButtonsExceptTheSpeak];
    [self aniamteOrStopRecording:YES];
}

- (void) recordingFinishedNotification:(NSNotification *) notification
{
    [self aniamteOrStopRecording:NO];
    [self unlockTheButtons];
}

- (void) recordingReceivedResultsNotification:(NSNotification *) notification
{
    NSDictionary *info = notification.userInfo;
    if (!info)
    {
        return;
    }
    
    NSArray *results = info[@"results"];
    NSString *firstResult = info[@"firstResult"];
    
    NSInteger numberOfResults = [results count];
    [_topTextView setText:firstResult];
    
    if ([results count] > 0)
    {
        NSLog(@"recognition result %@",[[results subarrayWithRange:NSMakeRange(1, numberOfResults-1)] componentsJoinedByString:@"\n"]);
        [self textViewDidEndEditing:_topTextView];
    }
}

//MARK: helper funcs
- (void) lockAllButtonsExceptTheSpeak
{
    [_topSelectLanguageButton setUserInteractionEnabled:NO];
    [_topDeleteButton setUserInteractionEnabled:NO];
    [_botSelectLanguageButton setUserInteractionEnabled:NO];
    [_botFavoriteButton setUserInteractionEnabled:NO];
    [_moveBotToTop setEnabled:NO];
    [_botMicButton setUserInteractionEnabled:NO];
    [_topTextView setUserInteractionEnabled:NO];
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    self.switchLanguagesButton.userInteractionEnabled = NO;
}

- (void) unlockTheButtons
{
    [_topSelectLanguageButton setUserInteractionEnabled:YES];
    [_topDeleteButton setUserInteractionEnabled:YES];
    [_botSelectLanguageButton setUserInteractionEnabled:YES];
    [_botFavoriteButton setUserInteractionEnabled:YES];
    [_moveBotToTop setEnabled:YES];
    [_botMicButton setUserInteractionEnabled:YES];
    [_topTextView setUserInteractionEnabled:YES];
    self.tabBarController.tabBar.userInteractionEnabled = YES;
    self.switchLanguagesButton.userInteractionEnabled = YES;
}

//MARK: setUp UI
- (void) setupFlagImages
{
    [_topLanguageFlag setImage:[UIImage imageNamed:[[LanguageSelectDemon summon] getCurrentSourceLanguage]]];
    [_botLanguageFlag setImage:[UIImage imageNamed:[[LanguageSelectDemon summon] getCurrentDestinationlanguage]]];
}

- (void) setupTheLabels
{
    [_topLanguageLabel setText:[LanguageList enumToString:[LanguageList indexOfItem:[[LanguageSelectDemon summon] getCurrentSourceLanguage]]]];
    [_botLanguageLabel setText:[LanguageList enumToString:[LanguageList indexOfItem:[[LanguageSelectDemon summon] getCurrentDestinationlanguage]]]];
}

- (void) setFavState
{
    if (![DatabaseDemon summon].myLastTranslation)
    {
        _botFavoriteButton.tag = 0;
        [_botFavoriteButton setImage:[UIImage imageNamed:@"bttnFavorite"] forState:UIControlStateNormal];
    }
    else
    {
        if ([[DatabaseDemon summon].myLastTranslation.faved isEqual:@(0)])
        {
            _botFavoriteButton.tag = 0;
            [_botFavoriteButton setImage:[UIImage imageNamed:@"bttnFavorite"] forState:UIControlStateNormal];
        }
        else
        {
            _botFavoriteButton.tag = 1;
            [_botFavoriteButton setImage:[UIImage imageNamed:@"bttnFavoriteActive"] forState:UIControlStateNormal];
        }
    }
}

- (void) initHelp
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"HelpViewFirstRun"])
    {
        CGFloat topPadding = [UIApplication sharedApplication].statusBarFrame.size.height;
        CGFloat bottomPadding = 0;
        if (@available(iOS 11.0, *))
        {
            UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
            bottomPadding += keyWindow.safeAreaInsets.bottom;
        }
        
        NSArray *coachMarks = @[@{
                                    @"rect": [NSValue valueWithCGRect:(CGRect){{_topLanguageFlag.frame.origin.x-2,_topLanguageFlag.frame.origin.y + topPadding},{_topLanguageFlag.frame.size.width+15,_topLanguageFlag.frame.size.height}}],
                                    @"caption": NSLocalizedString(@"tutorialTip1", nil)
                                    },
                                @{
                                    @"rect":[NSValue valueWithCGRect:(CGRect){{_topTextView.frame.origin.x,_topTextView.frame.origin.y + topPadding},{_topTextView.frame.size.width, _topTextView.frame.size.height}}],
                                    @"caption": NSLocalizedString(@"tutorialTip2", nil)
                                    },
                                @{
                                    @"rect":[NSValue valueWithCGRect:(CGRect){{_topMicButton.frame.origin.x,_topMicButton.frame.origin.y + topPadding},{_topMicButton.frame.size.width,_topMicButton.frame.size.height}}],
                                    @"caption": NSLocalizedString(@"tutorialTip3", nil)
                                    },
                                @{
                                    @"rect":[NSValue valueWithCGRect:(CGRect){{_botView.frame.origin.x,_botView.frame.origin.y},{_botView.frame.size.width,_botView.frame.size.height}}],
                                    @"caption": NSLocalizedString(@"tutorialTip4", nil)
                                    },
                                @{
                                    @"rect":[NSValue valueWithCGRect:(CGRect){{_botMicButton.frame.origin.x,_botMicButton.frame.origin.y + _topView.frame.size.height + topPadding},{_botMicButton.frame.size.width,_botMicButton.frame.size.height}}],
                                    @"caption" : NSLocalizedString(@"tutorialTip7", nil)
                                    },
                                @{
                                    @"rect":[NSValue valueWithCGRect:(CGRect){{_topDeleteButton.frame.origin.x,_topDeleteButton.frame.origin.y + topPadding},{_topDeleteButton.frame.size.width,_topDeleteButton.frame.size.height}}],
                                    @"caption": NSLocalizedString(@"tutorialTip5", nil)
                                    },
                                @{
                                    @"rect":[NSValue valueWithCGRect:(CGRect){{_botFavoriteButton.frame.origin.x,_botFavoriteButton.frame.origin.y+_topView.frame.size.height + topPadding},{_botFavoriteButton.frame.size.width,_botFavoriteButton.frame.size.height}}],
                                    @"caption": NSLocalizedString(@"tutorialTip6", nil)
                                    }
                                ];
        
        WSCoachMarksView *coachMarksView = [[WSCoachMarksView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - bottomPadding - topPadding) coachMarks:coachMarks];
        [self.view addSubview:coachMarksView];
        [coachMarksView setMaskColor:[UIColor colorWithWhite:0 alpha:0.5]];
        
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"HelpViewFirstRun"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [coachMarksView start];
    }
}

// MARK: Animations
- (void) aniamteOrStopRecording:(BOOL) state
{
    if (state)
    {
        [_topMicButton setBackgroundImage:[UIImage imageNamed:@"bttnMicTopActive"] forState:UIControlStateNormal];
        [self.listeningIndicator startAnimating];
        [_topHiddenSpeakIndicator setHidden:NO];
    }
    else
    {
        [_topMicButton setBackgroundImage:[UIImage imageNamed:@"bttnMicTop"] forState:UIControlStateNormal];
        [self.listeningIndicator stopAnimating];
        [_topHiddenSpeakIndicator setHidden:YES];
    }
}

// MARK: storyBoard
- (IBAction) topMicButtonPressed:(id) sender
{
    if (![[SpeechManagerNuance summon] internetConnectionIsReachable])
    {
        [ErrorMessageGenerator showNoInternetConnectionMessage];
    }
    else
    {
        if (([[SpeechManagerNuance summon] transactionState] != TS_RECORDING) && [_botTextView hasText])
        {
            [self topDeleteButtonWasPressed:nil];
        }
        [[SpeechManagerNuance summon] startRecord];
    }
}

- (IBAction) botMicButtonWasPressed:(id) sender
{
    if ([DatabaseDemon summon].myLastTranslation.translateText == nil || [[DatabaseDemon summon].myLastTranslation.translateText isEmpty])
    {
        return;
    }
    
    if (!([[SpeechManagerSeetings summon] getParam:Text_to_Speech forLanguage:[[LanguageSelectDemon summon] getCurrentDestinationlanguage]] == nil))
    {
        [self changeBotButtonIcon];
    }
    
    [[SpeechManagerNuance summon] speakText:[DatabaseDemon summon].myLastTranslation.translateText withLanguage:[[LanguageSelectDemon summon] getCurrentDestinationlanguage] andSender:sender];
}

- (IBAction) switchLanguagesButtonPressed:(id) sender
{
    [self switchLanguages];
}

- (void) changeBotButtonIcon
{
    if (_botMicButton.tag == 0)
    {
        [_botMicButton setBackgroundImage:[UIImage imageNamed:@"bnt_speakerMute"] forState:UIControlStateNormal];
        _botMicButton.tag = 1;
    }
    else
    {
        [_botMicButton setBackgroundImage:[UIImage imageNamed:@"bnt_speaker"] forState:UIControlStateNormal];
        _botMicButton.tag = 0;
    }
}

- (IBAction) topSelectLanguageButtonWasPressed:(id) sender
{
    //should not need, but to be shure
}

- (IBAction) topDeleteButtonWasPressed:(id) sender
{
    [self cleanScreen];
    [self cleanMem];
}

- (void) cleanScreen
{
    [_topTextView setText:@""];
    [_botTextView setText:@""];
    [_topTextView resignFirstResponder];
    
    [_botFavoriteButton setImage:[UIImage imageNamed:@"bttnFavorite"] forState:UIControlStateNormal];
    _botFavoriteButton.tag = 0;
    [[DatabaseDemon summon] setupMyLastTranslation:nil];
}

- (void) cleanMem
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"lastTransIndex"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"textThatWasOnTop"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction) botSelectLanguageButtonWasPressed:(id) sender
{
    //should not need, but to be shure
}

- (IBAction) botFavoriteButtonWasPressed:(id) sender
{
    if (![DatabaseDemon summon].myLastTranslation)
    {
        return;
    }
    UIButton *foo = (UIButton *)sender;
    UITabBarItem *favoritesItem = [self.tabBarController.tabBar.items objectAtIndex:1];
    NSInteger currentValue = [favoritesItem.badgeValue integerValue];
    
    if (foo.tag == 1)
    {
        foo.tag = 0;
        [foo setImage:[UIImage imageNamed:@"bttnFavorite"] forState:UIControlStateNormal];
        currentValue--;
        if (currentValue < 0)
        {
            currentValue = 0;
        }
    }
    else
    {
        foo.tag = 1;
        [foo setImage:[UIImage imageNamed:@"bttnFavoriteActive"] forState:UIControlStateNormal];
        currentValue++;
    }
    
    [favoritesItem setBadgeValue:(currentValue == 0) ? nil : [@(currentValue) stringValue]];
    [[DatabaseDemon summon].myLastTranslation setFaved:[NSNumber numberWithInteger:foo.tag]];
    [[DatabaseDemon summon] save];
}

//MARK: textView Delegate
- (void) textViewDidBeginEditing:(UITextView *) textView
{
    //ajust view so the KeyBoard does not cover the view
}

- (BOOL) textView:(UITextView *) textView shouldChangeTextInRange:(NSRange) range replacementText:(NSString *) text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void) textViewDidEndEditing:(UITextView *) textView
{
    [textView resignFirstResponder];
    [self makeTranslate];
}

//MARK: alertView - Delegate
- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger) buttonIndex
{
    [self performSegueWithIdentifier:@"goToLanguageSelectWhite" sender:nil];
}

//MARK: user actions
- (IBAction) moveBotToTop:(id) sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self switchLanguages];
    });
}

- (void) switchLanguages
{
    CGRect topViewFrame = _topView.frame;
    UIColor *topBackgroundColor = _topView.backgroundColor;
    
    self.switchLanguagesButton.userInteractionEnabled = NO;
    [_botFavoriteButton setHidden:YES];
    [_topDeleteButton setHidden:YES];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone  animations:^{
        _topView.frame = _botView.frame;
        _botView.frame = topViewFrame;
        
        _topView.backgroundColor = _botView.backgroundColor;
        _botView.backgroundColor = topBackgroundColor;
        
        if (![_botTextView.text isEmpty])
        {
            NSString *tempStr = _topTextView.text;
            [_topTextView setText:_botTextView.text];
            [_botTextView setText:tempStr];
        }
        
    } completion:^(BOOL finished) {
        
        _topView.frame = _botView.frame;
        _botView.frame = topViewFrame;
        
        _topView.backgroundColor = topBackgroundColor;
        _botView.backgroundColor = [UIColor whiteColor];
        
        [[LanguageSelectDemon summon] switchSourceAndDestination];
        [[DatabaseDemon summon] switchMyLastTranslation];
        
        [_botFavoriteButton setHidden:NO];
        [_topDeleteButton setHidden:NO];
        self.switchLanguagesButton.userInteractionEnabled = YES;
        
        [self onViewAppearAction];
        
        if (_botMicButton.tag == 1)
        {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[SpeechManagerNuance summon] speakText:[DatabaseDemon summon].myLastTranslation.translateText withLanguage:[[LanguageSelectDemon summon] getCurrentDestinationlanguage] andSender:_botMicButton];
            });
            [self changeBotButtonIcon];
        }
    }];
}

- (void) showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"windowName2", nil)
                                                    message:NSLocalizedString(@"translateToAutodetect", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"confirmAlertButton", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) makeTranslate
{
    if ([[[LanguageSelectDemon summon] getCurrentDestinationlanguage] isEqualToString:@"ad"])
    {
        [self performSelector:@selector(showAlert) withObject:nil afterDelay:0.6];
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"awaitingTranslateJustNeedALanguageSelected"];
    }
    else
    {
        if (!isASegue)
        {
            [self.translateIndicator startAnimating];
            [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"awaitingTranslateJustNeedALanguageSelected"];
            if (![_topTextView.text isEmpty])
            {
                if ([[[LanguageSelectDemon summon] currentSourceLanguage] isEqualToString:@"ad"])
                {
                    [[TranslationManager sharedManager] formAutodetectForText:_topTextView.text onSucces:^(NSDictionary *result) {
                        
                        if ([result[@"lang"] isEqualToString:[LanguageSelectDemon summon].currentDestinationlanguage])
                        {
                            [self successfullyDoneTranslating:_topTextView.text];
                            return;
                        }
                        
                        [[LanguageSelectDemon summon] setAndSaveSourceLanguage:result[@"lang"]];
                        [self setupFlagImages];
                        [self setupTheLabels];
                        [[TranslationManager sharedManager] formRequestForLanguage:[[LanguageSelectDemon summon] formRequestLanguages:NO]
                                                                              text:_topTextView.text
                                                                          onSucces:^(NSDictionary *result) {
                                                                              [self successfullyDoneTranslating:result[@"text"][0]];
                                                                          }
                                                                           onError:^(NSError *error) {
                                                                               [self translationFailedWithError:error withDisplayOption:YES];
                                                                           }];
                    } onError:^(NSError *error) {
                        [self translationFailedWithError:error withDisplayOption:NO];
                    }];
                }
                else
                {
                    [[TranslationManager sharedManager] formRequestForLanguage:[[LanguageSelectDemon summon] formRequestLanguages:NO]
                                                                          text:_topTextView.text
                                                                      onSucces:^(NSDictionary *result) {
                                                                          [self successfullyDoneTranslating:result[@"text"][0]];
                                                                      }
                                                                       onError:^(NSError *error) {
                                                                           [self translationFailedWithError:error withDisplayOption:YES];
                                                                       }];
                }
            }
            else
            {
                [self.translateIndicator stopAnimating];
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) successfullyDoneTranslating:(NSString *) translationResult
{
    //speachKit
    TranslationHistory *foo = [[TranslationHistory alloc]
                               initWithInitialText:_topTextView.text
                               translatedText:translationResult
                               translationDirection:[[LanguageSelectDemon summon] formRequestLanguages:NO]
                               favedState:[NSNumber numberWithUnsignedInt:0]
                               andStamp:nil];
    
    [[DatabaseDemon summon] setupMyLastTranslation:foo];
    [self setTextFromLastTrans];
    
    if ([Settings doIAutoSpeak])
    {
        [self botMicButtonWasPressed:_botMicButton];
    }
    
    [[DatabaseDemon summon] loadHistoryFromCoreData];
    [self setFavState];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.translateIndicator stopAnimating];
    });
}

- (void) translationFailedWithError:(NSError *) error withDisplayOption:(BOOL) displayError
{
    if (displayError)
    {
        [ErrorMessageGenerator displayError:error];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.translateIndicator stopAnimating];
    });
}

- (void) setTextFromLastTrans
{
    if ([DatabaseDemon summon].myLastTranslation != nil)
    {
        [_topTextView setText:[DatabaseDemon summon].myLastTranslation.initialText];
        [_botTextView setText:[DatabaseDemon summon].myLastTranslation.translateText];
    }
}

#pragma mark - Deallocations
- (void) dealloc
{
    [self removeObservers];
}

@end

//
//  LanguageSelectWhiteViewController.h
//  Translator
//
//   1/18/16.
//  Copyright © 2016 Dev. 
//

#import <UIKit/UIKit.h>
#import "LanguageSelectDemon.h"
#import "Settings.h"
#import "SpeechManagerSeetings.h"

@interface LanguageSelectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *recentLanguageWhite;
@property (weak, nonatomic) IBOutlet UITableView *allLanguagesWhite;
@property (weak, nonatomic) IBOutlet UITableView *recentLanguageBlue;
@property (weak, nonatomic) IBOutlet UITableView *allLanguagesBlue;
@property (weak, nonatomic) IBOutlet UITextField *searchBarBlue;
@property (weak, nonatomic) IBOutlet UITextField *searchBarWhite;

- (IBAction) searchButtonWhiteFired:(id) sender;
- (IBAction) searchButtonBlueFired:(id) sender;
- (IBAction) closeButtonPressed:(id) sender;



@end

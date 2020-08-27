//
//  Settings.h
//  Translator
//
//   11/12/15.
//  Copyright © 2015 Dev. 
//

#import <UIKit/UIKit.h>
#import "Tools.h"
#import "ButtonSettingState.h"
#import <MessageUI/MessageUI.h>

@interface Settings : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

+ (BOOL) isProfanityFilterEnabled;
+ (BOOL) isiCloudSyncEnabled;
+ (BOOL) doITextTranslation;
+ (BOOL) doIMaleVoice;
+ (BOOL) doIAutoSpeak;

@property (weak, nonatomic) IBOutlet UITableView *settingsTable;
@property (weak, nonatomic) IBOutlet UILabel *settingsTitle;
@property (weak, nonatomic) IBOutlet UITabBarItem *navBarSettingsTitle;

@end

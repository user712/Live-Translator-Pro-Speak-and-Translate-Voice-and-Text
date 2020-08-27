//
//  TodayViewController.h
//  Translator Widget
//
//   1/12/16.
//  Copyright © 2016 Dev. 
//

#import <UIKit/UIKit.h>
#import "HistoryToolView.h"
#import "LanguageSelectDemon.h"
#import "TranslationManager.h"

@interface TodayViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic,) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *container;

+ (NSMutableArray *) getMyTranslations;
+ (void) setMyTranslations:(NSMutableArray *) array;

@end

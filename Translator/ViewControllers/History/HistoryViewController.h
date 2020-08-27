//
//  HistoryViewController.h
//  Translator
//
//   1/15/16.
//  Copyright © 2016 Dev. 
//

#import <UIKit/UIKit.h>
#include "DatabaseDemon.h"
#include "IODProfanityFilter.h"
#import "TranslationHistory.h"
#import "TraslationCostumCellsTableViewCell.h"
#import "HistoryToolView.h"

@interface HistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (weak, nonatomic) IBOutlet UILabel *historyTitle;
@property (weak, nonatomic) IBOutlet UITabBarItem *navBarHistory;
@property (weak, nonatomic) IBOutlet UILabel *nothingToSeeHereLable;

- (IBAction) deleteAllHistory:(id) sender;

@end

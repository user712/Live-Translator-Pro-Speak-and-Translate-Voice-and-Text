//
//  TodayWidgetTableCell.h
//  Translator
//
//   4/27/17.
//  Copyright © 2017 Dev. 
//

#import <UIKit/UIKit.h>

@interface TodayWidgetTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *originalTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *translatedTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sourceLanguageFlagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *destinationLanguageFlagImageView;

@end

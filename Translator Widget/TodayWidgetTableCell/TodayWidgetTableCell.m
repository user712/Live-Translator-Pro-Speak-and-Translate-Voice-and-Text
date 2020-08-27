//
//  TodayWidgetTableCell.m
//  Translator
//
//   4/27/17.
//  Copyright © 2017 Dev. 
//

#import "TodayWidgetTableCell.h"
#import "WidgetUtilities.h"

@implementation TodayWidgetTableCell

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self.sourceLanguageFlagImageView.layer setMinificationFilter:kCAFilterTrilinear];
    [self.destinationLanguageFlagImageView.layer setMinificationFilter:kCAFilterTrilinear];
    
    if (SYSTEM_VERSION_LESS_THAN(@"10"))
    {
        self.originalTextLabel.textColor = [UIColor whiteColor];
        self.translatedTextLabel.textColor = [UIColor whiteColor];
    }
}

- (void) setSelected:(BOOL) selected animated:(BOOL) animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end

//
//  TraslationCostumCellsTableViewCell.h
//  Translator
//
//   tmp on 10/27/15.
//  Copyright © 2015 fakeCompany. 
//

#import <UIKit/UIKit.h>
#import "TranslationHistory.h"
#import "DatabaseDemon.h"
#import "HistoryToolView.h"

@interface TraslationCostumCellsTableViewCell : UITableViewCell

@property (strong, nonatomic) UITableViewCell *sourceLanguage;
@property (strong, nonatomic) UITableViewCell *destinationLanguage;
@property (strong, nonatomic) UIButton *bar;
@property (strong, nonatomic) UIButton *accesoryButton;
@property (strong, nonatomic) HistoryToolView *toolView;
@property (strong, nonatomic) TranslationHistory *trans;

- (void) switchFavState;
- (id) initWithInputText:(NSString *) inText andOutputText:(NSString *) outText andFrame:(CGRect) frame;
- (id) initWithTranslation:(TranslationHistory *) trans andFrame:(CGRect) frame;
- (void) centerAccesoryButtonForHeight:(CGFloat) height;

@end



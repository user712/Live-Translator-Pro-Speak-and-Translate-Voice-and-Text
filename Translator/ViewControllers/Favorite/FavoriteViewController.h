//
//  FavoriteViewController.h
//  Translator
//
//   12/1/15.
//  Copyright © 2015 Dev. 
//

#include "DatabaseDemon.h"
#include "IODProfanityFilter.h"
#import "TranslationHistory.h"
#import "TraslationCostumCellsTableViewCell.h"

@class FavoriteViewController;
@protocol FavoritsDelegate <NSObject>

- (void) favoriteHasBeenTaped:(UIButton *) buttonPressed;

@end

@interface FavoriteViewController : UIViewController <UITabBarControllerDelegate>

@property (nonatomic, weak) id <FavoritsDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *favTableView;
@property (weak, nonatomic) IBOutlet UILabel *favoriteTranslationTitle;
@property (weak, nonatomic) IBOutlet UITabBarItem *navBarFavTitle;
@property (weak, nonatomic) IBOutlet UILabel *nothingToSeeHereLable;

- (IBAction) unfavAllButton:(id) sender;

@end

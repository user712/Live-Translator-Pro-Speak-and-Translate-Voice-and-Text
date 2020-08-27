//
//  FavoriteViewController.m
//  Translator
//
//   12/1/15.
//  Copyright © 2015 Dev. 
//

#import "FavoriteViewController.h"
#import "LanguageSelectDemon.h"
#import "imageTools.h"

@interface FavoriteViewController ()

@end

@implementation FavoriteViewController

@synthesize delegate;
NSMutableArray<NSNumber*> *tableFavCellHeigt;
NSInteger favChosenOne;
UIImage *theMask;

- (void) viewDidLoad
{
    [super viewDidLoad];
    tableFavCellHeigt = [[NSMutableArray alloc] init];
    [self initTheHeightArray];
    favChosenOne = -6666;
    theMask = [UIImage imageNamed:@"favMask70x"];
}

- (void) initTheHeightArray
{
    [[DatabaseDemon summon] formFavIndex];
    [tableFavCellHeigt removeAllObjects];
    
    for (int i = (int)[[DatabaseDemon summon].favIndex count]-1 ; i >= 0; i--)
    {
        TraslationCostumCellsTableViewCell *foo = [[TraslationCostumCellsTableViewCell alloc] initWithTranslation:[[DatabaseDemon summon]getFavedAtIndex:i] andFrame:self.view.frame];
        [tableFavCellHeigt addObject:[NSNumber numberWithDouble:(foo.sourceLanguage.frame.size.height + foo.destinationLanguage.frame.size.height)]];
    }
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [_navBarFavTitle setTitle:NSLocalizedString(@"navBarFavorite", nil)];
}

- (void) viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
    self.tabBarItem.badgeValue = nil;
    _favoriteTranslationTitle.text  = NSLocalizedString(@"favoriteTranslationTitle", nil);
    _favTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self initTheHeightArray];
    [_favTableView reloadData];
    favChosenOne = -6666;
    [_nothingToSeeHereLable setText:NSLocalizedString(@"nothingToSeeHere", nil)];
}

#pragma mark - utils
- (NSString *) filterTransInput:(NSString *) input forLang:(NSString *) lang
{
    if ([Settings isProfanityFilterEnabled])
    {
        if ([IODProfanityFilter wordsetFor:lang])
        {
            return [IODProfanityFilter stringByFilteringString:input];
        }
    }
    return input;
}

#pragma mark - tableDelegate
- (void) tableView:(UITableView *) tableView didEndDisplayingCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (indexPath.row == favChosenOne)
    {
        favChosenOne = -6666;
        [self initTheHeightArray];
    }
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
    NSInteger r = [[DatabaseDemon summon].favIndex count];
    if (r < 1)
    {
        [_nothingToSeeHereLable setHidden:NO];
    }
    else
    {
        [_nothingToSeeHereLable setHidden:YES];
    }
    
    return r;
}

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath
{
    return  [[tableFavCellHeigt objectAtIndex:indexPath.row] doubleValue];
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    TranslationHistory *translationRecord = [[DatabaseDemon summon] getFavedAtIndex:([tableView numberOfRowsInSection:indexPath.section]-1-indexPath.row)];
    TraslationCostumCellsTableViewCell *foo = [[TraslationCostumCellsTableViewCell alloc] initWithTranslation:translationRecord andFrame:self.view.frame];
    foo.sourceLanguage.textLabel.text = [self filterTransInput:foo.sourceLanguage.textLabel.text forLang:foo.trans.sourceLang];
    foo.destinationLanguage.textLabel.text = [self filterTransInput:foo.destinationLanguage.textLabel.text forLang:foo.trans.destinationLang];
    [foo.sourceLanguage setBackgroundColor:[UIColor whiteColor]];
    [foo.destinationLanguage setBackgroundColor:[UIColor whiteColor]];
    [foo.destinationLanguage.textLabel setTextColor:tableView.tintColor];
    
    foo.sourceLanguage.imageView.image = [ImageTools setMask:theMask forTheFlag:[UIImage imageNamed:[[LanguageSelectDemon summon] getImageAdressForShortName:foo.trans.sourceLang]]];
    foo.destinationLanguage.imageView.image = [ImageTools setMask:theMask forTheFlag:[UIImage imageNamed:[[LanguageSelectDemon summon] getImageAdressForShortName:foo.trans.destinationLang]]];
    
    //Adjust images size:
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [foo.sourceLanguage.imageView.image drawInRect:imageRect];
    foo.sourceLanguage.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    [foo.destinationLanguage.imageView.image drawInRect:imageRect];
    foo.destinationLanguage.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    foo.bar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, foo.frame.size.width, foo.sourceLanguage.frame.size.height + foo.destinationLanguage.frame.size.height)];
    [foo.bar addTarget:self action:@selector(favTranslationWasSelected:) forControlEvents:UIControlEventTouchUpInside];
    foo.bar.tag = ([[DatabaseDemon summon].favIndex count] - 1 - indexPath.row);
    foo.bar.exclusiveTouch = YES;
    [foo addSubview:foo.bar];
    
    [foo centerAccesoryButtonForHeight:[[tableFavCellHeigt objectAtIndex:[[DatabaseDemon summon].favIndex count] - 1 - foo.bar.tag]doubleValue]];
    foo.accesoryButton.tag = indexPath.row;
    [foo.accesoryButton addTarget:self action:@selector(favItemMustDIE:) forControlEvents:UIControlEventTouchUpInside];
    [foo bringSubviewToFront:foo.accesoryButton];
    if (indexPath.row == favChosenOne)
    {
        [self initTheHeightArray];
    }
    
    return foo;
}

- (void) tableView:(UITableView *) tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *) indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void) favTranslationWasSelected:(UIButton *) sender
{
    [self initTheHeightArray];
    
    if (favChosenOne == ([[DatabaseDemon summon].favIndex count] - 1 - sender.tag))
    {

        [[DatabaseDemon summon] setupMyLastTranslation:[[DatabaseDemon summon] getFavedAtIndex:sender.tag]];
        [self.tabBarController setSelectedIndex:0];
        favChosenOne = -6666;
    }
    else
    {
        //do the magic
        TraslationCostumCellsTableViewCell *foo = [_favTableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:([[DatabaseDemon summon].favIndex count] - 1 - sender.tag) inSection:0]];
        HistoryToolView *baz = [[HistoryToolView alloc] initWithFrame:foo.frame andTransToWorkWith:[[DatabaseDemon summon] getFavedAtIndex:sender.tag] andParent:self];
        
        NSNumber * temp = [tableFavCellHeigt objectAtIndex:([[DatabaseDemon summon].favIndex count] - 1 - sender.tag)];
        temp = [NSNumber numberWithDouble:[temp doubleValue] + 80];
        [tableFavCellHeigt replaceObjectAtIndex:([[DatabaseDemon summon].favIndex count] - 1 - sender.tag) withObject:temp];
        [_favTableView beginUpdates];
        [foo addSubview:baz];
        [foo setBackgroundColor:baz.backgroundColor];
        
        [_favTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:favChosenOne inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
        [foo addSubview:baz];
        [foo setBackgroundColor:baz.backgroundColor];
        [foo.sourceLanguage setBackgroundColor:[UIColor clearColor]];
        [foo.sourceLanguage.textLabel setTextColor:[UIColor whiteColor]];
        [foo.destinationLanguage setBackgroundColor:[UIColor clearColor]];
        [foo.destinationLanguage.textLabel setTextColor:[AppColors appLightBlueColor]];
        baz.backgroundColor = [UIColor clearColor];
        
        foo.layer.borderColor = [UIColor whiteColor].CGColor;
        foo.layer.borderWidth = 5;
        
        if ([[[UIDevice currentDevice] systemVersion] integerValue] > 7)
        {
            foo.layer.cornerRadius = 10;
        }
        else
        {
            foo.layer.cornerRadius = 0;
        }
        
        UIImageView *accesory = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bttnHomeDelete"]];
        accesory.frame = CGRectMake(0, 0, 30, 30);
        accesory.contentMode = UIViewContentModeScaleAspectFit;
        foo.accessoryView = accesory;
        
        [_favTableView endUpdates];
        [foo centerAccesoryButtonForHeight:[temp doubleValue]];
        favChosenOne = ([[DatabaseDemon summon].favIndex count]-1-sender.tag);
    }
}

- (void) favItemMustDIE:(UIButton *) sender
{
    TraslationCostumCellsTableViewCell *foo = [_favTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [foo switchFavState];
    [self initTheHeightArray];
    [_favTableView reloadData];
    [self initTheHeightArray];
    
    if (sender.tag == favChosenOne)
    {
        [self initTheHeightArray];
    }
}

- (void) translationWasSelected:(UIButton *) sender
{
    [[self.tabBarController.viewControllers objectAtIndex:0] favoriteHasBeenTaped:sender];
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction) unfavAllButton:(id) sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"windowName2", nil)
                                                     message:NSLocalizedString(@"unfavAll", nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"alertNO", nil)
                                           otherButtonTitles:NSLocalizedString(@"alertYES", nil), nil];
    [alert show];
}

- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger) buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"pressed NO");
    }
    else
    {
        for (int i = 0; i<[[DatabaseDemon summon].favIndex count] ; i++)
        {
            [[DatabaseDemon summon] getFavedAtIndex:i].faved = [NSNumber numberWithInt:0];
        }
        [[DatabaseDemon summon] save];
        [[DatabaseDemon summon].favIndex removeAllObjects];
        [_favTableView reloadData];
    }
}

- (void) viewWillTransitionToSize:(CGSize) size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>) coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){} completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
         [self initTheHeightArray];
         [_favTableView reloadData];
     }];
}

@end

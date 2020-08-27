//
//  HistoryViewController.m
//  Translator
//
//   1/15/16.
//  Copyright © 2016 Dev. 
//

#import "HistoryViewController.h"
#import "LanguageSelectDemon.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

NSMutableArray<NSNumber*> * tableCellHeigt;
NSInteger theChosenOne;

- (void) awakeFromNib
{
    [super awakeFromNib];
    [_navBarHistory setTitle:NSLocalizedString(@"navBarHistory", nil)];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    tableCellHeigt = [[NSMutableArray alloc] init];
    [self initTheHeightArray];
    theChosenOne =  -6666;
}

- (void) viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
    _historyTitle.text = NSLocalizedString(@"historyTitle", nil);
    _historyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [[DatabaseDemon summon] loadHistoryFromCoreData];
    [self initTheHeightArray];
    [_historyTableView reloadData];
    theChosenOne = -6666;
    [_nothingToSeeHereLable setText:NSLocalizedString(@"nothingToSeeHere", nil)];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _historyTableView.contentInset = UIEdgeInsetsZero;
    _historyTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

// MARK: tableView Delegates
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
    NSInteger r = [[DatabaseDemon summon].transFromCoreData count];
    
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

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath * )indexPath
{
    return [[tableCellHeigt objectAtIndex:indexPath.row] doubleValue] ;
}

- (void) tableView:(UITableView *) tableView didEndDisplayingCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (indexPath.row == theChosenOne)
    {
        theChosenOne = -6666;
        [self initTheHeightArray];
    }
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    TraslationCostumCellsTableViewCell *foo = [[TraslationCostumCellsTableViewCell alloc] initWithTranslation:[[DatabaseDemon summon].transFromCoreData objectAtIndex:[tableView numberOfRowsInSection:indexPath.section]- indexPath.row -1] andFrame:self.view.frame];
    
    foo.sourceLanguage.textLabel.text = [self filterTransInput:foo.sourceLanguage.textLabel.text forLang:foo.trans.sourceLang];
    foo.destinationLanguage.textLabel.text = [self filterTransInput:foo.destinationLanguage.textLabel.text forLang:foo.trans.destinationLang];
    foo.sourceLanguage.imageView.image = [UIImage imageNamed:[[LanguageSelectDemon summon] getImageAdressForShortName:foo.trans.sourceLang]];
    foo.destinationLanguage.imageView.image = [UIImage imageNamed:[[LanguageSelectDemon summon] getImageAdressForShortName:foo.trans.destinationLang]];
    [foo.sourceLanguage setBackgroundColor:[UIColor whiteColor]];
    [foo.destinationLanguage setBackgroundColor:[UIColor whiteColor]];
    [foo.destinationLanguage.textLabel setTextColor:tableView.tintColor];
    
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
    [foo.bar addTarget:self action:@selector(translationWasSelected:) forControlEvents:UIControlEventTouchUpInside];
    foo.bar.tag = indexPath.row;
    foo.bar.exclusiveTouch = YES;
    [foo addSubview:foo.bar];
    
    [foo centerAccesoryButtonForHeight:[[tableCellHeigt objectAtIndex:foo.bar.tag] doubleValue]];
    foo.accesoryButton.tag = indexPath.row;
    [foo.accesoryButton addTarget:self action:@selector(itemMustDIE:) forControlEvents:UIControlEventTouchUpInside];
    [foo bringSubviewToFront:foo.accesoryButton];
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

- (void) itemMustDIE:(UIButton *) sender
{
    if ([[DatabaseDemon summon].transFromCoreData objectAtIndex:[_historyTableView numberOfRowsInSection:0]-sender.tag-1] == [DatabaseDemon summon].myLastTranslation)
    {
        [DatabaseDemon summon].myLastTranslation = nil;
    }
    
    [[DatabaseDemon summon].managedObjectContext deleteObject:[[DatabaseDemon summon].transFromCoreData objectAtIndex:[_historyTableView numberOfRowsInSection:0] - sender.tag - 1]];
    [[DatabaseDemon summon] save];
    [CATransaction begin];
    [_historyTableView beginUpdates];
    [_historyTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [_historyTableView endUpdates];
    
    [CATransaction setCompletionBlock: ^{
        [self initTheHeightArray];
        [_historyTableView reloadData];
        [self initTheHeightArray];
    }];
    
    [CATransaction commit];
    
    if (sender.tag == theChosenOne)
    {
        theChosenOne = -6666;
    }
}

// MARK: utils
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

//MARK: cellSelection Menu
- (void) translationWasSelected:(UIButton *) sender
{
    [self initTheHeightArray];
    
    if (theChosenOne == sender.tag)
    {
        [[DatabaseDemon summon] setupMyLastTranslation:[DatabaseDemon summon].transFromCoreData[[_historyTableView numberOfRowsInSection:0]- sender.tag -1]];
        [self.tabBarController setSelectedIndex:0];
        theChosenOne = -6666;
    }
    else
    {
        //set the last selected trans to white bacground, this way we ignore the "animatia se mananinca" shit
        TraslationCostumCellsTableViewCell *bar = [_historyTableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:theChosenOne inSection:0]];
        bar.backgroundColor = [UIColor whiteColor];
        
        //do the magic
        TraslationCostumCellsTableViewCell *foo = [_historyTableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:sender.tag inSection:0]];
        
        HistoryToolView *baz = [[HistoryToolView alloc] initWithFrame:foo.frame andTransToWorkWith:[DatabaseDemon summon].transFromCoreData[[_historyTableView numberOfRowsInSection:0]- sender.tag -1] andParent:self];
        NSNumber *temp = [tableCellHeigt objectAtIndex:foo.bar.tag];
        temp = [NSNumber numberWithDouble:[temp doubleValue] + 80];
        [tableCellHeigt replaceObjectAtIndex:foo.bar.tag withObject:temp];
        
        [_historyTableView beginUpdates];
        [foo setBackgroundColor:baz.backgroundColor];
        [_historyTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:theChosenOne inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
        
        UIImage *deleteImage = [UIImage imageNamed:@"bttnHomeDelete"];
        UIImageView *accesory = [[UIImageView alloc] initWithImage:deleteImage];
        accesory.frame = CGRectMake(0, 0, 30, 30);
        accesory.contentMode = UIViewContentModeScaleAspectFit;
        foo.accessoryView = accesory;
        
        [_historyTableView endUpdates];
        [foo centerAccesoryButtonForHeight:[[tableCellHeigt objectAtIndex:foo.bar.tag] doubleValue]];
        theChosenOne = sender.tag;
    }
}

- (void) initTheHeightArray
{
    [tableCellHeigt removeAllObjects];
    
    for (int i = (int)[[DatabaseDemon summon].transFromCoreData count]-1; i>=0; i--)
    {
        TraslationCostumCellsTableViewCell *foo = [[TraslationCostumCellsTableViewCell alloc] initWithTranslation:[[DatabaseDemon summon].transFromCoreData objectAtIndex:i] andFrame:self.view.frame];
        [tableCellHeigt addObject:[NSNumber numberWithDouble:(foo.sourceLanguage.frame.size.height + foo.destinationLanguage.frame.size.height)]];
    }
}

//MARK: delete all
- (IBAction) deleteAllHistory:(id) sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"windowName2", nil)
                                                     message:NSLocalizedString(@"deleteAll", nil)
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
        for (int i=0; i<[[DatabaseDemon summon].transFromCoreData count]; i++)
        {
            [[DatabaseDemon summon].managedObjectContext deleteObject:[[DatabaseDemon summon].transFromCoreData objectAtIndex:i]];
        }
        
        [DatabaseDemon summon].myLastTranslation = nil;
        [[DatabaseDemon summon] save];
        [_historyTableView reloadData];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"textThatWasOnTop"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void) viewWillTransitionToSize:(CGSize) size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>) coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){} completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
         [self initTheHeightArray];
         [_historyTableView reloadData];
     }];
}

@end

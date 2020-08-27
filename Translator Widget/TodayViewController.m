//
//  TodayViewController.m
//  Translator Widget
//
//   1/12/16.
//  Copyright © 2016 Dev. 
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "WidgetUtilities.h"
#import "TodayWidgetTableCell.h"

#define BiggerButtonSize 64
#define SmallerButtonSize 32
#define TableRowHeight 40
#define TableRowExpandedHeight 120
#define MaxTableItems 4

NSInteger const unselectedRowValue = -6666; //why -6666, cause anithing bellow 0 will do, but this way is more fun :P

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UIButton *translateClipboardButton;
@property (weak, nonatomic) IBOutlet UIButton *sourceLanguageButton;
@property (weak, nonatomic) IBOutlet UIButton *destinationLanguageButton;
@property (weak, nonatomic) IBOutlet UIButton *switchLanguagesButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (assign, nonatomic) NCWidgetDisplayMode currentDisplayMode;
@property (nonatomic, strong) NSMutableArray *myTemArray;
@property (assign, nonatomic) NSInteger theChosenOneForWidget;
@property (nonatomic, strong) NSMutableArray *tableCellHeight;

@end

@implementation TodayViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.myTemArray = [[NSMutableArray alloc] init];
    [self syncMyTranslations];
    self.theChosenOneForWidget = unselectedRowValue;
    self.tableCellHeight = [[NSMutableArray alloc] init];
    [self initTheHeightArray];
    [self addExtendedModeIfAvailable];
    [self updateUI];
    [self updateWidgetFrames];
}

- (void) viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
    [[LanguageSelectDemon summon] laodCurrentLanguageData];
    [self setButtonFlags];
    [self initTheHeightArray];
    self.theChosenOneForWidget = unselectedRowValue;
    [self updateWidgetFrames];
    [_myTableView reloadData];
}

- (void) updateUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.headerView.backgroundColor = [UIColor clearColor];
        self.myTableView.backgroundColor = [UIColor clearColor];
        self.container.backgroundColor = [UIColor clearColor];
        
        NSString *title = NSLocalizedString(@"clipboardButton", nil);
        self.translateClipboardButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.translateClipboardButton setTitle:title forState:UIControlStateNormal];
        [self.translateClipboardButton.titleLabel setNumberOfLines:0];
        [self.translateClipboardButton addTarget:self action:@selector(clipBoardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.sourceLanguageButton addTarget:self action:@selector(leftButtonWasPressed:) forControlEvents:UIControlEventTouchDown];
        [self.destinationLanguageButton addTarget:self action:@selector(rightButtonWasPressed:) forControlEvents:UIControlEventTouchDown];
        
        [self.switchLanguagesButton addTarget:self action:@selector(switchLanguagesButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.switchLanguagesButton setImage:[UIImage imageNamed:@"widget_bnt_change"] forState:UIControlStateNormal];
        [self.switchLanguagesButton setImage:[UIImage imageNamed:@"widget_bnt_change_pressed"] forState:UIControlStateHighlighted];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10"))
        {
            CGSize maxCompactSize = [self.extensionContext widgetMaximumSizeForDisplayMode:NCWidgetDisplayModeCompact];
            CGRect headerFrame = self.headerView.frame;
            headerFrame.size.height = maxCompactSize.height - TableRowHeight;
            self.headerView.frame = headerFrame;
            
            CGRect tableFrame = self.myTableView.frame;
            tableFrame.origin.y = headerFrame.size.height;
            tableFrame.size.height = TableRowHeight * MaxTableItems;
            self.myTableView.frame = tableFrame;
            
            CGRect containerFrame = self.container.frame;
            containerFrame.size.height = headerFrame.size.height + tableFrame.size.height;
            self.container.frame = containerFrame;
        }
    });
}

- (void) addExtendedModeIfAvailable
{
    if (SYSTEM_VERSION_LESS_THAN(@"10"))
    {
        return;
    }
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
}

- (void) widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult)) completionHandler
{
    completionHandler(NCUpdateResultNewData);
}

- (void) widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode) activeDisplayMode withMaximumSize:(CGSize) maxSize
{
    self.currentDisplayMode = activeDisplayMode;
    [self updateWidgetFrames];
}

- (void) updateWidgetFrames
{
    CGFloat tableHeight = 0;
    CGFloat headerHeight = 0;
    CGFloat widgetWidth = self.container.frame.size.width;
    
    if (self.currentDisplayMode == NCWidgetDisplayModeExpanded)
    {
        tableHeight = [self getTheTotalHeightOfAllTheCells];
        if (tableHeight == 0)
        {
            //tableHeight = TableRowHeight;
        }
        headerHeight = self.headerView.frame.size.height;
    }
    else if (self.currentDisplayMode == NCWidgetDisplayModeCompact)
    {
        tableHeight = TableRowHeight + 40;
        headerHeight = self.headerView.frame.size.height;
        
        [self hideExpandedCells];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.preferredContentSize = CGSizeMake(widgetWidth, tableHeight + headerHeight);
        //[_container setFrame:CGRectMake(0, 0, widgetWidth, tableHeight + headerHeight)];
        //[_myTableView setFrame:CGRectMake(0, headerHeight, widgetWidth, tableHeight)];
    });
}

- (void) hideExpandedCells
{
    [self initTheHeightArray];
    self.theChosenOneForWidget = unselectedRowValue;
    [_myTableView reloadData];
    
    for (UITableViewCell *foo in _myTableView.visibleCells)
    {
        NSArray *bar = foo.subviews;
        for (int j=0; j<[bar count]; j++)
        {
            if ([bar[j] isKindOfClass:[HistoryToolView class]])
            {
                [bar[j] removeFromSuperview];
                break;
            }
        }
    }
}

// MARK: the Buttons
- (IBAction) leftButtonWasPressed:(UIButton *) sender
{
    [self openParrentApp];
}

- (IBAction) rightButtonWasPressed:(UIButton *) sender
{
    [self openParrentApp];
}

- (void) setButtonFlags
{
    [self.sourceLanguageButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"widget_%@",[[LanguageSelectDemon summon] getCurrentSourceLanguage]]] forState:UIControlStateNormal];
    [self.destinationLanguageButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"widget_%@",[[LanguageSelectDemon summon] getCurrentDestinationlanguage]]] forState:UIControlStateNormal];
}

- (IBAction) clipBoardButtonPressed:(id) sender
{
    if (_myTableView == nil)
    {
        _myTableView = [[UITableView alloc] init];
    }
    
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    if (pasteBoard.string.length > 0)
    {
        if ([[[LanguageSelectDemon summon] currentSourceLanguage] isEqualToString:@"ad"])
        {
            [[TranslationManager sharedManager] formAutodetectForText:pasteBoard.string onSucces:^(NSDictionary *result) {
                
                if ([result[@"lang"] isEqualToString:[[LanguageSelectDemon summon] getCurrentDestinationlanguage]])
                {
                    [self gotMyTranslation:pasteBoard.string and:pasteBoard.string];
                    return;
                }
                
                [[LanguageSelectDemon summon] setAndSaveSourceLanguage:result[@"lang"]];
                [self setButtonFlags];
                
                [[TranslationManager sharedManager] formRequestForLanguage:[[LanguageSelectDemon summon] formRequestLanguages:[self isLeftOnTheLeft]] text:pasteBoard.string onSucces:^(NSDictionary *result) {
                    [self gotMyTranslation:pasteBoard.string and:result[@"text"][0]];
                } onError:^(NSError *error) {
                    NSLog(@"well something went wrong, but since so much time spent for nothing... %@, %@", error, [error userInfo]);
                    
                    HistoryToolView *foo = [[HistoryToolView alloc] initWithFrame:self.view.frame andTransToWorkWith:nil andParent:self];
                    [foo displayNoInternetNotification];
                }];
                
            } onError:^(NSError *error) {
                HistoryToolView *foo = [[HistoryToolView alloc] initWithFrame:self.view.frame andTransToWorkWith:nil andParent:self];
                [foo displayNoInternetNotification];
                NSLog(@"well something went wrong, but since so much time spent for nothing... %@, %@", error, [error userInfo]);
                
            }];
        }
        else
        {
            [[TranslationManager sharedManager] formRequestForLanguage:[[LanguageSelectDemon summon] formRequestLanguages:[self isLeftOnTheLeft]] text:pasteBoard.string onSucces:^(NSDictionary *result) {
                
                [self gotMyTranslation:pasteBoard.string and:result[@"text"][0]];
                
            } onError:^(NSError *error) {
                HistoryToolView *foo = [[HistoryToolView alloc] initWithFrame:self.view.frame andTransToWorkWith:nil andParent:self];
                [foo displayNoInternetNotification];
                NSLog(@"well something went wrong, but since so much time spent for nothing... %@, %@", error, [error userInfo]);
            }];
        }
    }
}

- (void) gotMyTranslation:(NSString *) iniTxt and:(NSString *) transTxt
{
    NSDictionary *foo = @{@"initialText" : iniTxt,
                          @"translatedText" : transTxt,
                          @"languagePair" : [[LanguageSelectDemon summon] formRequestLanguages:[self isLeftOnTheLeft]],
                          @"wasAddedToCoreData" : [NSNumber numberWithInt:0],
                          @"stamp" : [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]
                          };
    NSMutableArray *locTempArray = [[NSMutableArray alloc] initWithArray:[TodayViewController getMyTranslations]];
    [self.myTemArray insertObject:foo atIndex:0];
    [locTempArray insertObject:foo atIndex:0];
    
    if (self.myTemArray.count > MaxTableItems)
    {
        [self.myTemArray removeObjectAtIndex:self.myTemArray.count-1];
    }
    if (locTempArray.count > MaxTableItems)
    {
        [locTempArray removeObjectAtIndex:locTempArray.count-1];
    }
    
    [TodayViewController setMyTranslations:locTempArray];
    [self hideExpandedCells];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self animateMyMenu];
    });
}

- (UIColor *) randomColor
{
    CGFloat hue = (arc4random() % 256 / 256.0);  //0.0 to 1.0
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;  //0.5 to 1.0, away from white
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;  //0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

// MARK: animation
- (void) animateMyMenu
{
    [UIView animateWithDuration:0.5 animations:^{
        
        [self updateWidgetFrames];
        
    } completion:^(BOOL finished) {
        
        [_myTableView reloadData];
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[_myTableView cellForRowAtIndexPath:index] setSelected:YES animated:YES];
            [[_myTableView cellForRowAtIndexPath:index] setSelected:NO animated:YES];
        });
    }];
}

- (IBAction) switchLanguagesButtonPressed:(id) sender
{
    [self switchTheButtonPosition];
    //[[LanguageSelectDemon summon] switchSourceAndDestination];
}

- (void) switchTheButtonPosition
{
    self.switchLanguagesButton.userInteractionEnabled = NO;
    CGRect tmpFrame = self.sourceLanguageButton.frame;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.sourceLanguageButton.frame = self.destinationLanguageButton.frame;
        self.destinationLanguageButton.frame = tmpFrame;
    } completion:^(BOOL finished) {
        
        self.switchLanguagesButton.userInteractionEnabled = YES;
    }];
}

//MARK: tableView Delegate Function
- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (indexPath.row >= self.tableCellHeight.count)
    {
        return TableRowHeight;
    }
    return [[self.tableCellHeight objectAtIndex:indexPath.row] doubleValue];
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
    return self.myTemArray.count;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    static NSString *CellIdentifier = @"TodayWidgetTableCell";
    
    TodayWidgetTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TodayWidgetTableCell" owner:self options:nil] objectAtIndex:0];
    }
    
    NSInteger index = indexPath.row;
    NSDictionary *foo = self.myTemArray[index];
    
    NSString *sourceLanguageImageName = [NSString stringWithFormat:@"widget_%@", foo[@"languagePair"][0]];
    NSString *destinationLanguageImageName = [NSString stringWithFormat:@"widget_%@", foo[@"languagePair"][1]];
    
    cell.sourceLanguageFlagImageView.image = [UIImage imageNamed:sourceLanguageImageName];
    cell.destinationLanguageFlagImageView.image = [UIImage imageNamed:destinationLanguageImageName];
    
    cell.originalTextLabel.text = foo[@"initialText"];
    cell.translatedTextLabel.text = foo[@"translatedText"];
    
    return cell;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.theChosenOneForWidget != indexPath.row)
    {
        if (self.currentDisplayMode == NCWidgetDisplayModeCompact)
        {
            return;
        }
        
        if (self.theChosenOneForWidget >= 0)
        {
            UITableViewCell *foo = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.theChosenOneForWidget inSection:0]];
            NSArray *bar = foo.subviews;
            for (int j=0; j<[bar count]; j++)
            {
                if ([bar[j] isKindOfClass:[HistoryToolView class]])
                {
                    [bar[j] removeFromSuperview];
                    break;
                }
            }
        }
        
        NSInteger index = indexPath.row;
        [self initTheHeightArray];
        
        [tableView beginUpdates];
        self.tableCellHeight[index] = [NSNumber numberWithInt:TableRowExpandedHeight];
        
        UITableViewCell *foo = [tableView cellForRowAtIndexPath:indexPath];
        foo.contentMode = UIViewContentModeTop;
        
        HistoryToolView *bar = [[HistoryToolView alloc] initWithFrame:foo.frame andDictionaryToWorkWith:self.myTemArray[index] andParent:self];
        bar.backgroundColor = [UIColor clearColor];
        foo.backgroundColor = bar.backgroundColor = [UIColor clearColor];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [foo addSubview:bar];
        });
        
        if (self.theChosenOneForWidget >= 0)
        {
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.theChosenOneForWidget inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self updateWidgetFrames];
        
        [tableView endUpdates];
        self.theChosenOneForWidget = indexPath.row;
    }
    else
    {
        if (self.theChosenOneForWidget >= 0)
        {
            UITableViewCell *foo = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.theChosenOneForWidget inSection:0]];
            NSArray *bar = foo.subviews;
            for (int j=0; j<[bar count]; j++)
            {
                if ([bar[j] isKindOfClass:[HistoryToolView class]])
                {
                    [bar[j] removeFromSuperview];
                    break;
                }
            }
        }
        
        [self initTheHeightArray];
        [tableView beginUpdates];
        
        if (self.theChosenOneForWidget >= 0)
        {
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.theChosenOneForWidget inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        [self updateWidgetFrames];
        
        [tableView endUpdates];
        self.theChosenOneForWidget = unselectedRowValue;
    }
}

// MARK: util
- (UIEdgeInsets) widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets) defaultMarginInsets
{
    return UIEdgeInsetsZero;
}

- (void) openParrentApp
{
    NSURL *url = [NSURL URLWithString:@"sicTranslatorProSchemeURL://"];
    [self.extensionContext openURL:url completionHandler:nil];
}

+ (NSArray *) getMyTranslations
{
    NSArray *translations = [[[NSUserDefaults alloc] initWithSuiteName:APP_CONECTIVITY_ID] objectForKey:@"WidgetArray"];
    if (translations)
    {
        return translations;
    }
    
    return @[];
}

+ (void) setMyTranslations:(NSMutableArray *) array
{
    NSUserDefaults *groupContainter = [[NSUserDefaults alloc] initWithSuiteName:APP_CONECTIVITY_ID];
    [groupContainter setObject:[NSArray arrayWithArray:array] forKey:@"WidgetArray"];
    [groupContainter synchronize];
}

- (void) syncMyTranslations
{
    [self.myTemArray removeAllObjects];
    NSArray *translations = [[[NSUserDefaults alloc] initWithSuiteName:APP_CONECTIVITY_ID] objectForKey:@"WidgetArray"];
    if (translations && translations.count > 0)
    {
        [self.myTemArray addObjectsFromArray:translations];
    }
}

- (BOOL) isLeftOnTheLeft
{
    return self.sourceLanguageButton.frame.origin.x < self.destinationLanguageButton.frame.origin.x ? NO : YES;
}

- (void) initTheHeightArray
{
    [self.tableCellHeight removeAllObjects];
    for (NSInteger i = 0; i<self.myTemArray.count; i++)
    {
        [self.tableCellHeight addObject:[NSNumber numberWithInt:40]];
    }
}

- (CGFloat) getTheTotalHeightOfAllTheCells
{
    CGFloat j = 0;
    for (NSInteger i=0 ; i<self.myTemArray.count; i++)
    {
        j += [[self.tableCellHeight objectAtIndex:i] doubleValue];
    }
    return j;
}

@end

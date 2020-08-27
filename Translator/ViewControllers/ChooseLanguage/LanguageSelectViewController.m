//
//  LanguageSelectWhiteViewController.m
//  Translator
//
//   1/18/16.
//  Copyright © 2016 Dev. 
//

#import "LanguageSelectViewController.h"
#import "NSString+Additions.h"

@interface LanguageSelectViewController ()

@end

@implementation LanguageSelectViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    _searchBarBlue.text = @"";
    _searchBarWhite.text = @"";
    _searchBarBlue.delegate = _searchBarWhite.delegate = self;
    [self addObservers];
}

- (void) updateStatusBarUI
{
    if ([self.restorationIdentifier isEqualToString:@"LanguageSelectWhite"])
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

- (void) resetStatusBarUI
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void) viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
    _recentLanguageWhite.backgroundColor = _allLanguagesWhite.backgroundColor = _recentLanguageBlue.backgroundColor = _allLanguagesBlue.backgroundColor = [UIColor clearColor];
    [_recentLanguageBlue setScrollEnabled:NO];
    [_recentLanguageWhite setScrollEnabled:NO];
    
    _searchBarBlue.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"langSelectPlaceholder", nil) attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    _searchBarWhite.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"langSelectPlaceholder", nil) attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [self updateStatusBarUI];
}

- (void) viewWillDisappear:(BOOL) animated
{
    [_searchBarBlue setText:@""];
    [_searchBarWhite setText:@""];
    [self resetStatusBarUI];
    [super viewWillDisappear:animated];
}

- (void) viewDidAppear:(BOOL) animated
{
    [super viewDidAppear:animated];
    [self scrollOnSelectedLanguageAnimated:YES];
}

- (void) scrollOnSelectedLanguageAnimated:(BOOL) animated
{
    NSString *currentLanguage;
    UITableView *currentTableView;
    
    if (_allLanguagesWhite)
    {
        currentLanguage = [[LanguageSelectDemon summon] getCurrentDestinationlanguage];
        currentTableView = _allLanguagesWhite;
    }
    else
    {
        currentLanguage = [[LanguageSelectDemon summon] getCurrentSourceLanguage];
        currentTableView = _allLanguagesBlue;
    }
    
    NSInteger count = [[LanguageSelectDemon summon] count];
    for (NSInteger i=0; i<count; i++)
    {
        NSString *item = [[LanguageSelectDemon summon] getObjectAtIndex:i];
        if ([item isEqualToString:currentLanguage])
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [currentTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
            break;
        }
    }
}

//MARK: Observers Methods
- (void) addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard Observers
- (void) keyboardWillShow:(NSNotification *) notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
    
    CGRect whiteTableConvertedRect = [self.allLanguagesWhite.superview convertRect:self.allLanguagesWhite.frame toView:self.view];
    CGFloat whiteDiff = self.view.bounds.size.height - (whiteTableConvertedRect.origin.y + whiteTableConvertedRect.size.height);
    UIEdgeInsets whiteTableViewContentInsets = contentInsets;
    whiteTableViewContentInsets.bottom -= whiteDiff;
    
    CGRect blueTableConvertedRect = [self.allLanguagesBlue.superview convertRect:self.allLanguagesBlue.frame toView:self.view];
    CGFloat blueDiff = self.view.bounds.size.height - (blueTableConvertedRect.origin.y + blueTableConvertedRect.size.height);
    UIEdgeInsets blueTableViewContentInsets = contentInsets;
    blueTableViewContentInsets.bottom -= blueDiff;
    
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:rate.floatValue animations:^{
        
        self.allLanguagesWhite.contentInset = whiteTableViewContentInsets;
        self.allLanguagesWhite.scrollIndicatorInsets = whiteTableViewContentInsets;
        self.allLanguagesBlue.contentInset = blueTableViewContentInsets;
        self.allLanguagesBlue.scrollIndicatorInsets = blueTableViewContentInsets;
    }];
}

- (void) keyboardWillHide:(NSNotification *) notification
{
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:rate.floatValue animations:^{
        
        [self adjustTableInsetsToNormalState];
    }];
}

- (void) adjustTableInsetsToNormalState
{
    UIEdgeInsets whiteTableInsets = self.allLanguagesWhite.contentInset;
    whiteTableInsets.bottom = 0;
    [self.allLanguagesWhite setContentInset:whiteTableInsets];
    [self.allLanguagesWhite setScrollIndicatorInsets:self.allLanguagesWhite.contentInset];
    
    UIEdgeInsets blueTableInsets = self.allLanguagesBlue.contentInset;
    blueTableInsets.bottom = 0;
    [self.allLanguagesBlue setContentInset:blueTableInsets];
    [self.allLanguagesBlue setScrollIndicatorInsets:self.allLanguagesBlue.contentInset];
}

// MARK: tableView delegate
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
    
    if (tableView == _recentLanguageWhite || tableView == _recentLanguageBlue)
    {
        return 2;
    }
    else
    {
        return [[LanguageSelectDemon summon] count];
    }
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    static NSString *CellIdentifier = @"choseLanguage";
    
    UITableViewCell *foo = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!foo)
    {
        foo = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [foo setBackgroundColor:[UIColor clearColor]];
    [foo.detailTextLabel setHidden:NO];
    foo.accessoryView = nil;
    [foo.textLabel setFont:[UIFont systemFontOfSize:15]];
    
    UIView *selectedBackgroundColorView = [[UIView alloc] init];
    
    //color difference
    if (tableView == _recentLanguageBlue || tableView == _allLanguagesBlue)
    {
        //costumize for white background
        [foo.textLabel setTextColor:[UIColor whiteColor]];
        selectedBackgroundColorView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    }
    else
    {
        // costumize for blue background
        [foo.textLabel setTextColor:[UIColor blackColor]];
        selectedBackgroundColorView.backgroundColor = [[AppColors appLightBlueColor] colorWithAlphaComponent:0.5];
    }
    [foo setSelectedBackgroundView:selectedBackgroundColorView];
    
    //populate, based on recent or full list
    if (tableView == _recentLanguageWhite || tableView == _recentLanguageBlue)
    {
        if ([[LanguageSelectDemon summon] countRecent] > indexPath.row)
        {
            foo.detailTextLabel.text = [[LanguageSelectDemon summon] getRecentAtIndex:indexPath.row];
            foo.imageView.image = [UIImage imageNamed:[[LanguageSelectDemon summon] getImageAdressForShortName:[[LanguageSelectDemon summon] getRecentAtIndex:indexPath.row]]];
            [foo.textLabel setText:[LanguageList enumToString:[LanguageList indexOfItem:[[LanguageSelectDemon summon] getRecentAtIndex:indexPath.row]]]];
            [self setCellImageSize:foo];
            return foo;
        }
    }
    else
    {
        if (tableView == _allLanguagesWhite)
        {
            if ([[[LanguageSelectDemon summon] getObjectAtIndex:indexPath.row] isEqualToString:[[LanguageSelectDemon summon] getCurrentDestinationlanguage]])
            {
                foo.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accesorySelectedBot"]];
            }
        }
        else
        {
            if ([[[LanguageSelectDemon summon] getObjectAtIndex:indexPath.row] isEqualToString:[[LanguageSelectDemon summon] getCurrentSourceLanguage]])
            {
                foo.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accesorySelectedTop"]];
            }
        }
        [foo.detailTextLabel setText:[[LanguageSelectDemon summon] getObjectAtIndex:indexPath.row]];
        foo.textLabel.text = [LanguageList enumToString:[LanguageList indexOfItem:[[LanguageSelectDemon summon] getObjectAtIndex:indexPath.row]]];
        foo.imageView.image = [UIImage imageNamed:[[LanguageSelectDemon summon] getObjectAtIndex:indexPath.row]];
        [self setCellImageSize:foo];
        
    }
    if (_searchBarWhite ? !(BOOL)[_searchBarWhite.text isEmpty] : NO || _searchBarBlue ? !(BOOL)[_searchBarBlue.text isEmpty] : NO)
    {
        if (![Tools smartSearchIn:[[LanguageList enumToString:[LanguageList indexOfItem:[[LanguageSelectDemon summon] getObjectAtIndex:indexPath.row]]] lowercaseString]  the:[!_searchBarWhite?_searchBarBlue.text:_searchBarWhite.text lowercaseString]])
        {
            [foo setHidden:YES];
        }
    }
    
    if (![Settings doITextTranslation])
    {
        NSString *str1 = [[SpeechManagerSeetings summon] getParam:Speech_to_Text forLanguage:[[LanguageSelectDemon summon] getObjectAtIndex:indexPath.row]];
        NSString *str2 = [[SpeechManagerSeetings summon] getParam:Text_to_Speech forLanguage:[[LanguageSelectDemon summon] getObjectAtIndex:indexPath.row]];
        
        if (!(str1 && str2))
        {
            [foo setHidden:YES];
            return foo;
        }
        else
        {
            return foo;
        }
    }
    else
    {
        return foo;
    }
    
    return nil;
}

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (![Settings doITextTranslation] && (tableView == _allLanguagesWhite || tableView == _allLanguagesBlue))
    {
        NSString *tempLang = [[LanguageSelectDemon summon] getObjectAtIndex:indexPath.row];
        
        NSString *str1 = [[SpeechManagerSeetings summon] getParam:Speech_to_Text forLanguage:tempLang];
        NSString *str2 = [[SpeechManagerSeetings summon] getParam:Text_to_Speech forLanguage:tempLang];
        
        if (!( str1 && str2 ))
        {
            return 0;
        }
    }
    
    if (_searchBarWhite ? !(BOOL)[_searchBarWhite.text isEmpty] : NO || _searchBarBlue ? !(BOOL)[_searchBarBlue.text isEmpty] : NO)
    {
        if (![Tools smartSearchIn:[[LanguageList enumToString:[LanguageList indexOfItem:[[LanguageSelectDemon summon]getObjectAtIndex:indexPath.row]]] lowercaseString] the:[!_searchBarWhite ? _searchBarBlue.text : _searchBarWhite.text lowercaseString]])
        {
            return 0;
        }
    }
    
    return 44;
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

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    [_searchBarBlue resignFirstResponder];
    [_searchBarWhite resignFirstResponder];
    if (tableView == _allLanguagesWhite)
    {
        NSString *theLanguageIJustSelected = [[LanguageSelectDemon summon] getObjectAtIndex:indexPath.row];
        [[LanguageSelectDemon summon] setAndSaveDestiantionLanguage:theLanguageIJustSelected];
        [[LanguageSelectDemon summon] addItemToRecentArray:theLanguageIJustSelected];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (tableView == _allLanguagesBlue)
    {
        NSString *theLanguageIJustSelected = [[LanguageSelectDemon summon] getObjectAtIndex:indexPath.row];
        [[LanguageSelectDemon summon] setAndSaveSourceLanguage:theLanguageIJustSelected];
        [[LanguageSelectDemon summon] addItemToRecentArray:theLanguageIJustSelected];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else  // selected recent array
    {
        if ([[LanguageSelectDemon summon] countRecent] > indexPath.row)  // make sure was no tap on an empty cell
        {
            [Tools moveOnTopRecetObjectAtIndex:indexPath.row fromArray:[[LanguageSelectDemon summon]getRecentArray]];
            if (_recentLanguageWhite)
            {
                //we got recent on bottom
                [[LanguageSelectDemon summon] setAndSaveDestiantionLanguage:[[LanguageSelectDemon summon] getRecentAtIndex:indexPath.row]];
            }
            else
            {
                // we got recent on top
                [[LanguageSelectDemon summon] setAndSaveSourceLanguage:[[LanguageSelectDemon summon] getRecentAtIndex:indexPath.row]];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
        }
    }
}

// MARK: UITextFieldDelegate
- (BOOL) textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString *) string
{
    if (range.length == 0)
    {
        [textField setText:[NSString stringWithFormat:@"%@%@", textField.text, string]];
    }
    else
    {
        [textField setText:[textField.text substringToIndex:[textField.text length] -1]];
    }
    
    if (textField == _searchBarWhite)
    {
        [_allLanguagesWhite reloadData];
    }
    else if (textField == _searchBarBlue)
    {
        [_allLanguagesBlue reloadData];
        
    }
    return NO;
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField
{
    [textField resignFirstResponder];
    return YES;
}

//MARK: utils
- (void) setCellImageSize:(UITableViewCell *) cell
{
    UIImage *foo = cell.imageView.image;
    CGFloat widthScale = 37 / foo.size.width;
    CGFloat heighScale = 32 / foo.size.height;
    cell.imageView.transform = CGAffineTransformMakeScale(widthScale, heighScale);
}

- (IBAction) searchButtonWhiteFired:(id) sender
{
    [_allLanguagesWhite reloadData];
    [_searchBarWhite resignFirstResponder];
}
- (IBAction) searchButtonBlueFired:(id) sender
{
    [_allLanguagesBlue reloadData];
    [_searchBarBlue resignFirstResponder];
}

- (IBAction) closeButtonPressed:(id) sender
{
    [_searchBarBlue resignFirstResponder];
    [_searchBarWhite resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Deallocations
- (void) dealloc
{
    [self removeObservers];
}

@end

//
//  Settings.m
//  Translator
//
//   11/12/15.
//  Copyright © 2015 Dev. 
//

#import "Settings.h"
#import "SettingsCell.h"
#import "AppInfo.h"
#import "AppColors.h"
#import "SubscriptionInfoViewController.h"

#define profanityFilterStateKey @"profanityFilterState"
#define iCloudSyncStateKey @"iCloudSyncState"
#define doITextTranslationKey @"doITextTranslation"
#define doIMaleVoiceKey @"doIMaleVoiceKey"
#define doIAutoSpeakKey @"doIAutoSpeak"

#ifdef I_AM_IN_THE_MAIN_APP
#import "AboutViewController.h"
#endif

typedef NS_ENUM(NSInteger, SettingsSectionsType)
{
    SSTInput = 0,
    SSTVoice,
    SSTAdvanced,
    SSTMore
};

@interface Settings ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) NSMutableArray *tableDatasource;

@end

@implementation Settings

static BOOL isProfanityFilterEnabled;
static BOOL isiCloudSyncEnabled;
static BOOL doITextTranslation;
static BOOL doIMaleVoice;
static BOOL doIAutoSpeak;

+ (void) initialize
{
    isProfanityFilterEnabled = [Tools getBoolValueFromString:[[NSUserDefaults standardUserDefaults] stringForKey:profanityFilterStateKey]];
    isiCloudSyncEnabled = [Tools getBoolValueFromString:[[NSUserDefaults standardUserDefaults] stringForKey:iCloudSyncStateKey]];
    doITextTranslation = [Tools getBoolValueFromString:[[NSUserDefaults standardUserDefaults] stringForKey:doITextTranslationKey]];
    doIMaleVoice = [Tools getBoolValueFromString:[[NSUserDefaults standardUserDefaults] stringForKey:doIMaleVoiceKey]];
    doIAutoSpeak = [Tools getBoolValueFromString:[[NSUserDefaults standardUserDefaults] stringForKey:doIAutoSpeakKey]];
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [_navBarSettingsTitle setTitle:NSLocalizedString(@"navBarSettings", nil)];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self updateSectionsArray];
}

- (void) viewDidAppear:(BOOL) animated
{
    [super viewDidAppear:animated];
    _settingsTable.tableFooterView =  [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
    _settingsTitle.text  = NSLocalizedString(@"settingsTitle", nil);
    _settingsTable.backgroundColor = [AppColors settingsTableBackgroundColor];
}

- (void) updateSectionsArray
{
    if (!_tableDatasource)
    {
        self.tableDatasource = [NSMutableArray new];
    }
    
    [self.tableDatasource removeAllObjects];
    
    NSArray *inputItems = @[@{@"title" : NSLocalizedString(@"inputSourcesItem1", nil), @"image" : @"settingsVoiceIn"}, @{@"title" : NSLocalizedString(@"inputSourcesItem2", nil), @"image" : @"settingsKbIn"}];
    NSArray *voiceItems = @[@{@"title" : NSLocalizedString(@"voiceGenderItem1", nil), @"image" : @"settingsMaleVoice"}, @{@"title" : NSLocalizedString(@"voiceGenderItem2", nil), @"image" : @"settingsFemaleVoice"}];
    NSArray *advancedItems = @[@{@"title" : NSLocalizedString(@"advancedOptionsItem1", nil), @"image" : @"settignsFilter"}, @{@"title" : NSLocalizedString(@"advancedOptionsItem2", nil), @"image" : @"settings_iCloudSync"}, @{@"title" : NSLocalizedString(@"advancedOptionsItem3", nil), @"image" : @"settingsAutospeak"}];
    NSArray *moreItems = @[@{@"title" : NSLocalizedString(@"moreOptionsItem1", nil), @"image" : @"settingsSupport"}, @{@"title" : NSLocalizedString(@"moreOptionsItem2", nil), @"image" : @"settingsRate"}, @{@"title" : NSLocalizedString(@"moreOptionsItem3", nil), @"image" : @"settingsShare"}, @{@"title" : NSLocalizedString(@"moreOptionsItem4", nil), @"image" : @"settingsHelp"}, @{@"title" : NSLocalizedString(@"Subscription", nil), @"image" : @"subscriptionIcon"}, @{@"title" : NSLocalizedString(@"About", nil), @"image" : @"settingsAbout"}];
    
    [self.tableDatasource addObject:@{@"title" : NSLocalizedString(@"tableTitlesItem1", nil), @"type" : @(SSTInput), @"items" : inputItems}];
    [self.tableDatasource addObject:@{@"title" : NSLocalizedString(@"tableTitlesItem2", nil), @"type" : @(SSTVoice), @"items" : voiceItems}];
    [self.tableDatasource addObject:@{@"title" : NSLocalizedString(@"tableTitlesItem3", nil), @"type" : @(SSTAdvanced), @"items" : advancedItems}];
    [self.tableDatasource addObject:@{@"title" : NSLocalizedString(@"tableTitlesItem4", nil), @"type" : @(SSTMore), @"items" : moreItems}];
}

+ (BOOL) isProfanityFilterEnabled
{
    return  isProfanityFilterEnabled;
}

+ (BOOL) doITextTranslation
{
    return doITextTranslation;
}

+ (BOOL) doIMaleVoice
{
    return doIMaleVoice;
}

+ (BOOL) isiCloudSyncEnabled
{
    return isiCloudSyncEnabled;
}

+ (BOOL) doIAutoSpeak
{
    return doIAutoSpeak;
}

//MARK: TableViewDelegate Methods
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
    return [self.tableDatasource count];;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
    NSDictionary *sectionDict = self.tableDatasource[section];
    NSArray *sectionItems = sectionDict[@"items"];
    return [sectionItems count];
}

- (UIView *) tableView:(UITableView *) tableView viewForHeaderInSection:(NSInteger) section
{
    UIView *foo = [[UIView alloc] init];
    foo.backgroundColor = [AppColors settingsTableBackgroundColor];
    UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, self.view.frame.size.width, 30)];
    NSDictionary *sectionDict = self.tableDatasource[section];
    NSString *sectionTitle = sectionDict[@"title"];
    [bar setText:sectionTitle];
    [bar setFont:[UIFont systemFontOfSize:19]];
    [foo addSubview:bar];
    return foo;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    NSString *CellIdentifier = @"SettingsCell";
    
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *sectionDict = self.tableDatasource[indexPath.section];
    NSArray *sectionItems = sectionDict[@"items"];
    NSDictionary *itemDict = sectionItems[indexPath.row];
    NSString *titleString = itemDict[@"title"];
    NSString *imageNameString = itemDict[@"image"];
    
    cell.titleLabel.text = titleString;
    cell.iconImageView.image = [UIImage imageNamed:imageNameString];
    [cell setAccessoryView:nil];
    [cell.accessoryView setHidden:YES];
    
    SettingsSectionsType sectionType = [sectionDict[@"type"] integerValue];
    
    switch (sectionType)
    {
        case SSTInput:
        {
            UIImageView *bar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accesorySettingsSelect"]];
            bar.frame = CGRectMake(0, 0, 13, 13);
            bar.contentMode = UIViewContentModeScaleAspectFit;
            [cell setAccessoryView:bar];
            [cell.accessoryView setHidden:YES];
            
            if ([Settings doITextTranslation])
            {
                if (indexPath.row == 1)
                {
                    [cell.accessoryView setHidden:NO];
                }
            }
            else
            {
                if ((indexPath.row == 0))
                {
                    [cell.accessoryView setHidden:NO];
                }
            }
            break;
        }
        case SSTVoice:
        {
            UIImageView *bar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accesorySettingsSelect"]];
            bar.frame = CGRectMake(0, 0, 13, 13);
            bar.contentMode = UIViewContentModeScaleAspectFit;
            [cell setAccessoryView:bar];
            [cell.accessoryView setHidden:YES];
            
            if ([Settings doIMaleVoice])
            {
                if (indexPath.row == 0)
                {
                    [cell.accessoryView setHidden:NO];
                    [cell setAccessoryView:bar];
                }
            }
            else
            {
                if ((indexPath.row == 1))
                {
                    [cell.accessoryView setHidden:NO];
                }
            }
            break;
        }
        case SSTAdvanced:
        {
            ButtonSettingState *bar = [[ButtonSettingState alloc] init];
            UISwitch *tempSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, bar.frame.size.width, 10)];
            tempSwitch.onTintColor = [AppColors appBlueColor];
            tempSwitch.tag = indexPath.row;
            [tempSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            
            if (indexPath.row == 0)
            {
                [tempSwitch setOn:[Settings isProfanityFilterEnabled]];
            }
            else if(indexPath.row == 1)
            {
                [tempSwitch setOn:[Settings isiCloudSyncEnabled]];
            }
            else
            {
                [tempSwitch setOn:[Settings doIAutoSpeak]];
            }
            
            [cell.accessoryView setHidden:NO];
            [cell setAccessoryView:tempSwitch];
            break;
        }
        case SSTMore:
        {
            UIImageView *bar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accesorySettingsNext"]];
            bar.frame = CGRectMake(0, 0, 13, 13);
            bar.contentMode = UIViewContentModeScaleAspectFit;
            [cell setAccessoryView:bar];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void) switchValueChanged:(UISwitch *) theSwitch
{
    switch (theSwitch.tag)
    {
        case 0:
        {
            isProfanityFilterEnabled = !isProfanityFilterEnabled;
            [Tools setAndSyncNsuserDefaultsObject:[NSNumber numberWithBool:isProfanityFilterEnabled] forKey:profanityFilterStateKey];
            break;
        }
        case 1:
        {
            isiCloudSyncEnabled = !isiCloudSyncEnabled;
            [Tools setAndSyncNsuserDefaultsObject:[NSNumber numberWithBool:isiCloudSyncEnabled] forKey:iCloudSyncStateKey];
            break;
        }
        default:
        {
            doIAutoSpeak = !doIAutoSpeak;
            [Tools setAndSyncNsuserDefaultsObject:[NSNumber numberWithBool:doIAutoSpeak] forKey:doIAutoSpeakKey];
            break;
        }
    }
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

- (CGFloat) tableView:(UITableView *) tableView heightForHeaderInSection:(NSInteger) section
{
    return 30;
}

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath
{
    return 40;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    NSDictionary *sectionDict = self.tableDatasource[indexPath.section];
    SettingsSectionsType sectionType = [sectionDict[@"type"] integerValue];
    
    switch (sectionType)
    {
        case SSTInput:
        {
            if ([Settings doITextTranslation])
            {
                if (indexPath.row == 0)
                {
                    doITextTranslation = NO;
                    [Tools setAndSyncNsuserDefaultsObject:[NSNumber numberWithBool:doITextTranslation] forKey:doITextTranslationKey];
                }
                else
                {
                    //do NOTHING
                }
            }
            else
            {
                if (indexPath.row == 0)
                {
                    //DO NOTHING
                }
                else
                {
                    doITextTranslation = YES;
                    [Tools setAndSyncNsuserDefaultsObject:[NSNumber numberWithBool:doITextTranslation] forKey:doITextTranslationKey];
                }
            }
            [tableView reloadData];
            break;
        }
        case SSTVoice:
        {
            if ([Settings doIMaleVoice])
            {
                if (indexPath.row == 0)
                {
                    //DO NOTHING
                }
                else
                {
                    doIMaleVoice = NO;
                    [Tools setAndSyncNsuserDefaultsObject:[NSNumber numberWithBool:doIMaleVoice] forKey:doIMaleVoiceKey];
                }
            }
            else
            {
                if (indexPath.row == 0)
                {
                    doIMaleVoice = YES;
                    [Tools setAndSyncNsuserDefaultsObject:[NSNumber numberWithBool:doIMaleVoice] forKey:doIMaleVoiceKey];
                }
                else
                {
                    //DO NOTHING
                }
            }
            [tableView reloadData];
            break;
        }
        case SSTAdvanced:  //ADVANCED SETTINGS
        {
            break;
        }
        case SSTMore:  //MORE
        {
            if (indexPath.row == 0)  //Support
            {
                if ([MFMailComposeViewController canSendMail])
                {
                    [self displayMailComposer];
                }
                else
                {
                    #ifdef I_AM_IN_THE_MAIN_APP
                        [Tools showToastWithMessage:NSLocalizedString(@"cannotSendEmailMessageKey", nil) withDuration:3];
                    #endif
                }
            }
            else if (indexPath.row == 1)  //Rate App
            {
#ifdef I_AM_IN_THE_MAIN_APP
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[AppInfo sharedManager] storeAppLink]]];
#endif
            }
            else if (indexPath.row == 2) //Share App
            {
                NSString *texttoshare = NSLocalizedString(@"shareAppDescription", nil);
                texttoshare = [NSString stringWithFormat:@"%@\n%@", texttoshare, @"https://goo.gl/qJtO6J"/*@"https://itunes.apple.com/us/app/live-translator-pro-speech/id1089167197?ls=1&mt=8"*/];
                UIImage *imagetoshare = [UIImage imageNamed:@"share.png"];
                NSArray *activityItems = @[texttoshare, imagetoshare];
                UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
                activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint/*, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo*/];
                
                if ([activityVC respondsToSelector:@selector(popoverPresentationController)])
                {
                    // iOS8
                    activityVC.popoverPresentationController.sourceView =self.view;
                }
                
                [self presentViewController:activityVC animated:TRUE completion:nil];
                
            }
            else if (indexPath.row == 3) //Help
            {
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"HelpViewFirstRun"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.tabBarController setSelectedIndex:0];
            }
            else if (indexPath.row == 4) //Subscription
            {
#ifdef I_AM_IN_THE_MAIN_APP
                [self presentViewController:[[SubscriptionInfoViewController alloc] initWithNibName:@"SubscriptionInfoViewController" bundle:nil] animated:YES completion:nil];
#endif
            }
            else  //About
            {
#ifdef I_AM_IN_THE_MAIN_APP
                [self presentViewController:[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil] animated:YES completion:nil];
#endif
            }
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//MARK: mailComposer
MFMailComposeViewController *mailPicker;

- (void) displayMailComposer
{
#ifdef I_AM_IN_THE_MAIN_APP
    
    mailPicker = [[MFMailComposeViewController alloc]init];
    mailPicker.mailComposeDelegate = self;
    NSString *busgOrSuggestionsReportString = @"Support";
    [mailPicker setSubject:[NSString stringWithFormat:@"%@ %@", [[AppInfo sharedManager] appName], busgOrSuggestionsReportString]];
    NSArray * sendTo = [NSArray arrayWithObjects:supportEmail, nil];
    [mailPicker setToRecipients:sendTo];
    
    NSString *deviceModelTitle = NSLocalizedString(@"Device model:", nil);
    NSString *systemVersionTitle = NSLocalizedString(@"System version: ", nil);
    NSString *appVersionTitle = NSLocalizedString(@"App version:", nil);
    
    NSString *emailBody = [NSString stringWithFormat:
                           @"*****************************************\n"
                           "%@ %@\n"
                           "%@ %@\n"
                           "%@ %@\n"
                           "*****************************************",
                           deviceModelTitle, [Tools deviceModel],
                           systemVersionTitle, [Tools systemVersion],
                           appVersionTitle, [Tools applicationNameAndVersion]];
    
    [mailPicker setMessageBody:emailBody isHTML:NO];
    [self presentViewController:mailPicker animated:YES completion:nil];
#endif
}

- (void) mailComposeController:(MFMailComposeViewController *) controller didFinishWithResult:(MFMailComposeResult) result error:(NSError *) error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

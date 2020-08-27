//
//  HistoryToolView.m
//  Translator
//
//   2/2/16.
//  Copyright © 2016 Dev. 
//

#import "HistoryToolView.h"
#import "AppColors.h"

#define BUTTON_HEIGHT 32
#define BUTTON_WIDTH 95

@implementation HistoryToolView

CGPoint firstBtnPos;
CGPoint secondtBtnPos;
CGPoint thirdBtnPos;
BOOL initedFromTrans;

- (instancetype) initWithFrame:(CGRect) frame andTransToWorkWith:(TranslationHistory *) trans andParent:(UIViewController *) paps
{
    initedFromTrans = YES;
    self = [super initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 80)];
    _transToWorkWith  = trans;
    _parentController = paps;
    [self awakeFromNib];
    return self;
}

- (instancetype) initWithFrame:(CGRect) frame andDictionaryToWorkWith:(NSDictionary *) dictionary andParent:(UIViewController *) paps
{
    initedFromTrans = NO;
    self = [super initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 80)];
    _dictTiWorkWith = dictionary;
    _parentController = paps;
    [self awakeFromNib];
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setBackgroundColor:[AppColors appBlueColor]];
    [self makeTheButtons];
}

- (void) makeTheButtons
{
    [self calculateStuff];
    
    //lisiten button
    _bntListen = [[UIButton alloc] initWithFrame:CGRectMake(firstBtnPos.x , firstBtnPos.y, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [_bntListen setImage:[UIImage imageNamed:@"btn_listen"] forState:UIControlStateNormal];
    [_bntListen setTitle:[NSString stringWithFormat:@" %@", NSLocalizedString(@"Listen", nil)] forState:UIControlStateNormal];
    [_bntListen.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:[self getTextSize]]];
    [_bntListen addTarget:self action:@selector(listenButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bntListen];
    
    //copy button
    _btnCopy = [[UIButton alloc] initWithFrame:CGRectMake(secondtBtnPos.x, secondtBtnPos.y, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [_btnCopy setImage:[UIImage imageNamed:@"btn_copy"] forState:UIControlStateNormal];
    [_btnCopy setTitle:[NSString stringWithFormat:@" %@", NSLocalizedString(@"Copy", nil)] forState:UIControlStateNormal];
    [_btnCopy.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:[self getTextSize]]];
    [_btnCopy addTarget:self action:@selector(copyButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnCopy];
    
    //share button
    _btnShare = [[UIButton alloc] initWithFrame:CGRectMake(thirdBtnPos.x, thirdBtnPos.y, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [_btnShare setImage:[UIImage imageNamed:@"btn-sharing"] forState:UIControlStateNormal];
    [_btnShare setTitle:[NSString stringWithFormat:@" %@", NSLocalizedString(@"Share", nil)] forState:UIControlStateNormal];
    [_btnShare.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:[self getTextSize]]];
    [_btnShare addTarget:self action:@selector(shareButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
    if (initedFromTrans)
    {
        [self addSubview:_btnShare];
    }
}

//calculates the ideal posiationing for the buttons
- (void) calculateStuff
{
    CGFloat marginTop = (self.frame.size.height - BUTTON_HEIGHT) / 2; //center vertically
    CGFloat marginLeft = (self.frame.size.width - BUTTON_WIDTH * 3) / 4; //equal space beetween buttons and margins
    
    firstBtnPos = CGPointMake(marginLeft, marginTop);
    secondtBtnPos = CGPointMake(marginLeft * 2 + BUTTON_WIDTH, marginTop);
    thirdBtnPos = CGPointMake(marginLeft * 3 + BUTTON_WIDTH * 2, marginTop);
}

//MARK: Button actions
- (void) listenButtonWasPressed
{
    [[SpeechManagerNuance summon] speakText:initedFromTrans ? _transToWorkWith.translateText : _dictTiWorkWith[@"translatedText"] withLanguage:initedFromTrans ? _transToWorkWith.destinationLang : _dictTiWorkWith[@"languagePair"][1] andSender:nil];
}

- (void) copyButtonWasPressed
{
    [UIPasteboard generalPasteboard].string = initedFromTrans ? _transToWorkWith.translateText : _dictTiWorkWith[@"translatedText"];;
    [self displayNotification];
}

- (void) shareButtonWasPressed
{
    //[self shareAsTXTFile];
    [self shareAsText];
}

- (void) shareAsTXTFile
{
    NSString *textToShare = initedFromTrans ? _transToWorkWith.translateText : _dictTiWorkWith[@"translatedText"];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:@"My File.txt"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    NSError *saveError;
    BOOL succeed = [textToShare writeToURL:url atomically:YES encoding:NSUTF8StringEncoding error:&saveError];
    [textToShare writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&saveError];
    if (succeed)
    {
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
        activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo];
        [activityViewController setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
            
            [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
        }];
        if ([activityViewController respondsToSelector:@selector(popoverPresentationController)])
        {
            // iOS8
            activityViewController.popoverPresentationController.sourceView = _parentController.view;
        }
        [_parentController presentViewController:activityViewController animated:YES completion:nil];
    }
}

- (void) shareAsText
{
    NSString *textToShare = initedFromTrans ? _transToWorkWith.translateText : _dictTiWorkWith[@"translatedText"];
    NSArray *activityItems = @[textToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo];
    if ([activityVC respondsToSelector:@selector(popoverPresentationController)])
    {
        // iOS8
        activityVC.popoverPresentationController.sourceView = _parentController.view;
    }
    [_parentController presentViewController:activityVC animated:YES completion:nil];
}

- (BDKNotifyHUD *) notify
{
    if (_notify != nil) return _notify;
    
    _notify = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Checkmark"] text:@""];
    _notify.center = CGPointMake(self.parentController.view.center.x, self.parentController.view.center.y - 20);
    return _notify;
}

- (void) displayNotification
{
    if (self.notify.isAnimating) return;
    
    [self.parentController.view addSubview:self.notify];
    [self.notify presentWithDuration:1.0f speed:0.5f inView:self.parentController.view completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.notify removeFromSuperview];
        });
    }];
}

- (BDKNotifyHUD *) noInternetNotify
{
    if (_noInternetNotify != nil) return _noInternetNotify;
        
    _noInternetNotify = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"noWiFi"] text:@""];
    _noInternetNotify.center = CGPointMake(self.parentController.view.center.x, self.parentController.view.center.y-15);
    return _noInternetNotify;
}

- (void) displayNoInternetNotification
{
    if (self.noInternetNotify.isAnimating) return;
    
    [self.parentController.view addSubview:self.noInternetNotify];
    [self.noInternetNotify presentWithDuration:1.0f speed:0.5f inView:self.parentController.view completion:^{
        [self.noInternetNotify removeFromSuperview];
    }];
}

- (NSInteger) getTextSize
{
#ifndef I_AM_IN_THE_MAIN_APP
    return 10;
#else
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if ([language respondsToSelector:@selector(containsString:)])
    {
        return [language containsString:@"ru"] ? 11 : [language containsString:@"pt"] ? 12 : 14;
    }
    else
    {
        return ([language rangeOfString:@"ru"].location != NSNotFound) ? 11 : ([language rangeOfString:@"pt"].location != NSNotFound) ? 12 : 14;
    }
#endif
}

@end

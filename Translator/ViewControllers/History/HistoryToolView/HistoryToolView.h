//
//  HistoryToolView.h
//  Translator
//
//   2/2/16.
//  Copyright © 2016 Dev. 
//

#import <UIKit/UIKit.h>
#import "SpeechManagerNuance.h"
#import "TranslationHistory.h"
#import "BDKNotifyHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface HistoryToolView : UIView

@property (strong, nonatomic) UIButton *bntListen;
@property (strong, nonatomic) UIButton *btnCopy;
@property (strong, nonatomic) UIButton *btnShare;
@property (strong, nonatomic) BDKNotifyHUD *notify;
@property (strong, nonatomic) BDKNotifyHUD *noInternetNotify;
@property (strong, nonatomic) TranslationHistory *transToWorkWith;
@property (strong, nonatomic) NSDictionary *dictTiWorkWith;
@property (weak, nonatomic) UIViewController *parentController;

- (instancetype) initWithFrame:(CGRect) frame andTransToWorkWith:(TranslationHistory *) trans andParent:(UIViewController *) paps;
- (instancetype) initWithFrame:(CGRect) frame andDictionaryToWorkWith:(NSDictionary *) dictionary andParent:(UIViewController *) paps;
- (void) displayNoInternetNotification;
- (void) displayNotification;

@end

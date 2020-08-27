//
//  InterfaceController.h
//  TranslatorWatch Extension
//
//   12/4/15.
//  Copyright © 2015 Dev. 
//


#define APP_CONECTIVITY_ID @"group.megadata.translator"

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "LanguageList.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "HistoryDemon.h"
#import "LanguageSelectDemon.h"

@interface InterfaceController : WKInterfaceController

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *translateFromTop;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *translateFromBottom;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *backgroundGroup;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *interfaceImage;

- (IBAction) topButtonPressed;
- (IBAction) botButtonPressed;

@end

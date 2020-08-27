//
//  tempInterfaceController.h
//  Translator
//
//   12/17/15.
//  Copyright © 2015 Dev. 
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "SpeechManagerSeetings.h"
#import "LanguageList.h"
#import "languagePicker.h"
#import "LanguageSelectDemon.h"
#import "InterfaceController.h"

@interface tempInterfaceController : WKInterfaceController

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfacePicker *picker;

- (IBAction) pickerChangedValue:(NSInteger) value;
- (IBAction) selectLang;

@end

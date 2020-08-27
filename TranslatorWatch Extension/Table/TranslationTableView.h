//
//  TranslationTableView.h
//  Translator
//
//   12/15/15.
//  Copyright © 2015 Dev. 
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "TableRowController.h"
#import "IODProfanityFilter.h"

#import "HistoryDemon.h"

@interface TranslationTableView : WKInterfaceController

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *theTable;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *hiddenMessage;

@end

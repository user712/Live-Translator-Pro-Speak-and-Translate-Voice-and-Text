//
//  TableRowController.h
//  Translator
//
//   12/15/15.
//  Copyright © 2015 Dev. 
//

#import <WatchKit/WatchKit.h>

@interface TableRowController : NSObject

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *topLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *topImage;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *bottomLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *bottomImage;

@end

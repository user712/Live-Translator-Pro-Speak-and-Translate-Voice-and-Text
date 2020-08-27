//
//  GlanceController.h
//  TranslatorWatch Extension
//
//   12/4/15.
//  Copyright © 2015 Dev. 
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface GlanceController : WKInterfaceController

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *transGroup;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *topImage;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *topLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *botImage;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *botLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *greetingLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *theIcon;

@end

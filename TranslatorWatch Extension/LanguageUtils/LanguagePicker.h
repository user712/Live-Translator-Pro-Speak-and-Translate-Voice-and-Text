//
//  LanguagePicker.h
//  Translator
//
//   12/7/15.
//  Copyright © 2015 Dev. 
//

#import <WatchKit/WatchKit.h>

@interface LanguagePicker : WKPickerItem

@property (nonatomic,nonnull) NSString *label;

- (LanguagePicker *_Nonnull) initWithTitle:(NSString *_Nonnull) title andLabel:(NSString *_Nonnull) label;

@end

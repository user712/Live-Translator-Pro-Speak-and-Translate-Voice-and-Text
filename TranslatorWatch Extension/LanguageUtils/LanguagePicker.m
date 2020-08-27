//
//  LanguagePicker.m
//  Translator
//
//   12/7/15.
//  Copyright © 2015 Dev. 
//

#import "LanguagePicker.h"

@implementation LanguagePicker

- (LanguagePicker *) initWithTitle:(NSString *) title andLabel:(NSString *) label
{
    self = [super init];
    [self setTitle:title];
    [self setLabel:label];
    return self;
}

@end

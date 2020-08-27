//
//  ErrorMessageGenerator.h
//  Translator
//
//   2/23/16.
//  Copyright © 2016 Dev. 
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface ErrorMessageGenerator : NSObject

+ (void) showNoInternetConnectionMessage;
+ (void) displayError:(NSError *) error;

@end

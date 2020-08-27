//
//  ErrorMessageGenerator.m
//  Translator
//
//   2/23/16.
//  Copyright © 2016 Dev. 
//

#import "ErrorMessageGenerator.h"
#import "Tools.h"

@implementation ErrorMessageGenerator

+ (void) showNoInternetConnectionMessage
{
#ifdef I_AM_IN_THE_MAIN_APP
    NSString *message = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"windowName", nil), NSLocalizedString(@"noConnectioinAlert", nil)];
    [Tools showToastWithMessage:message withDuration:3];
#endif
}

+ (void) displayError:(NSError *) error
{
#ifdef I_AM_IN_THE_MAIN_APP
    NSString *message = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"windowName", nil), error.localizedDescription];
    [Tools showToastWithMessage:message withDuration:3];
#endif
}

@end

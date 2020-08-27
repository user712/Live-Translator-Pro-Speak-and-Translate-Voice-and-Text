//
//  NSString+Additions.m
//  Translator
//
//   2/7/18.
//  
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (BOOL) isEmpty
{
    if ([self length] == 0)
    {
        return YES;
    }
    
    if (![[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
    {
        return YES;
    }
    return NO;
}

@end

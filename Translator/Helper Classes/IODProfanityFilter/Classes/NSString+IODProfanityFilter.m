//
//  NSString+IODProfanityFilter.m
//  IODProfanityFilter
//
//   John Arnold on 2013-01-27.
//  Copyright (c) 2013 Island of Doom Software Inc. 
//

#import "NSString+IODProfanityFilter.h"
#import "IODProfanityFilter.h"

@implementation NSString (IODProfanityFilter)

- (NSArray *) iod_rangesOfFilteredWords
{
    return [IODProfanityFilter rangesOfFilteredWordsInString:self];
}

- (NSString *) iod_filteredString
{
    return [IODProfanityFilter stringByFilteringString:self];
}

- (NSString *) iod_filteredStringWithReplacementString:(NSString *) replacementString
{
    return [IODProfanityFilter stringByFilteringString:self withReplacementString:replacementString];
}

@end

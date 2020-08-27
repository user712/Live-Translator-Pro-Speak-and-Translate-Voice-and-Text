//
//  IODProfanityFilter.h
//  IODProfanityFilter
//
//   John Arnold on 2013-02-27.
//  Copyright (c) 2013 Island of Doom Software Inc. 
//
#import <UIKit/UIKit.h>

@interface IODProfanityFilter : NSObject

/**
 The word set is initialized from the IODProfanityWords.txt in the app bundle, using the current locale.
 It is exposed as a mutable set so you can easily add/remove words at runtime if needed.
 Note that changes to the word set are not persisted by this class between app launches.
 */
+ (NSMutableSet *) wordSet;

/**
 The word set is initialized from IODProfanityWords.txt using language specified
 lang format - 2chars // "en", "ar" ....
 Note it's reiniting the wordset everytime you use it;
 returns YES if language exists and all done, NO otherwise
*/
+ (BOOL) wordsetFor:(NSString *) lang;


/**
 Returns an array of NSValue(NSRange) indicating where offending words were found in the string.
 If there are no offending words, returns an empty array.
 */
+ (NSArray *) rangesOfFilteredWordsInString:(NSString *) string;

/**
 Returns a string with offending words replaced by "∗"
 */
+ (NSString *) stringByFilteringString:(NSString *) string;

/**
 Returns a string with offending words replaced by the string you pass in (repeated to fit)
 */
+ (NSString *) stringByFilteringString:(NSString *) string withReplacementString:(NSString *) replacementString;

@end

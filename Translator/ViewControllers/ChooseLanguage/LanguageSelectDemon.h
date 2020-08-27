//
//  LanguageSelectDemon.h
//  Translator
//
//   1/18/16.
//  Copyright © 2016 Dev. 
//

#import <Foundation/Foundation.h>
#import "LanguageList.h"
#import "Tools.h"

#ifndef APP_CONECTIVITY_ID
#define APP_CONECTIVITY_ID @"group.megadata.translator"
#endif
@interface LanguageSelectDemon : NSObject

@property (strong, nonatomic) NSString *currentSourceLanguage;
@property (strong, nonatomic) NSString *currentDestinationlanguage;

+ (LanguageSelectDemon *) summon;
- (NSInteger) count;
- (NSInteger) countRecent;
- (NSString *) getImageAdressForShortName:(NSString *) name;
- (NSString *) getObjectAtIndex:(NSInteger) index;
- (NSString *) getRecentAtIndex:(NSInteger) index;
- (void) laodCurrentLanguageData;
- (void) setAndSaveSourceLanguage:(NSString *) lang;
- (void) setAndSaveDestiantionLanguage:(NSString *) lang;
- (NSString *) getCurrentSourceLanguage;
- (NSString *) getCurrentDestinationlanguage;
- (void) switchSourceAndDestination;
- (NSMutableArray *) getRecentArray;
- (void) saveRecetArray;
- (void) addItemToRecentArray:(NSString *) item;
- (NSArray *) formRequestLanguages:(BOOL) reversed;

@end


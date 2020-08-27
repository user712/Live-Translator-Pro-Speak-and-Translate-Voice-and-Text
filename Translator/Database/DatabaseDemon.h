//
//  DatabaseDemon.h
//  Translator
//
//   11/3/15.
//  Copyright © 2015 Dev. 
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TranslationHistory.h"
#import "CoreData_iCloudBridge.h"
#import "Settings.h"
#import "TodayViewController.h"

@class LanguageSelectDemon;

#define defaultKeyForDataStorage @"testData4"

@interface DatabaseDemon : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSArray<TranslationHistory*> *transFromCoreData;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) TranslationHistory *myLastTranslation;
@property (nonatomic, strong) NSMutableArray<NSNumber*> *favIndex;

+ (DatabaseDemon *) summon;
- (NSArray *) loadHistoryFromCoreData;
- (void) loadHistoryFromCloud;
- (BOOL) save;
- (void) formFavIndex;
- (TranslationHistory *) getFavedAtIndex:(NSInteger) index;
- (void) setupMyLastTranslation:(TranslationHistory *) trans;
- (void) switchMyLastTranslation;
- (NSDictionary *) getMyLastTransAsDict;

@end


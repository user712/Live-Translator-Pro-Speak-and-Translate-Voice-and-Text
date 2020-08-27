//
//  HistoryDemon.h
//  Translator
//
//   12/17/15.
//  Copyright © 2015 Dev. 
//

#import <Foundation/Foundation.h>

#define HISTORY_FILE_NAME @"historyFile.out"

@interface HistoryDemon : NSObject

@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSMutableArray *itemList;

+ (HistoryDemon *) summon;
- (void) setUp;
- (void) load;
- (void) save;
- (void) addItem:(NSDictionary *) item;
- (void) removeItem:(id) item;
- (NSUInteger) count;

@end

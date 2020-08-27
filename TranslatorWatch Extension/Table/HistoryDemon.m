//
//  HistoryDemon.m
//  Translator
//
//   12/17/15.
//  Copyright © 2015 Dev. 
//

#import "HistoryDemon.h"

static HistoryDemon * demon;

@implementation HistoryDemon

- (HistoryDemon *) init
{
    self = [super init];
    return self;
}

+ (HistoryDemon *) summon
{
    if (!demon)
    {
        demon = [[HistoryDemon alloc] init];
        [demon setUp];
        [demon load];
    }
    return demon;
}

- (void) setUp
{
    NSURL *urlOut = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.megadata.translator"];
    urlOut = [urlOut URLByAppendingPathComponent:HISTORY_FILE_NAME];
    demon.filePath = urlOut.absoluteString;
    demon.filePath = [demon.filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    demon.itemList = [[NSMutableArray alloc] init];
}

- (void) load
{
    if ([[NSFileManager defaultManager]fileExistsAtPath:demon.filePath])
    {
        demon.itemList = [[NSArray arrayWithContentsOfFile:demon.filePath] mutableCopy];
    }
}

- (void) save
{
    NSArray * foo = [demon.itemList copy];
    NSLog(@"%@",@([foo writeToFile:demon.filePath atomically:YES]));
}

- (void) addItem:(NSDictionary *) item
{
    [demon.itemList addObject:item];
    [demon save];
}

- (void) removeItem:(id) item
{
    [demon.itemList removeObject:item];
}

- (NSUInteger) count
{
    return [demon.itemList count];
}

@end

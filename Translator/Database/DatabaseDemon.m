//
//  DatabaseDemon.m
//  Translator
//
//   11/3/15.
//  Copyright © 2015 Dev. 
//

#import "DatabaseDemon.h"
#import "LanguageSelectDemon.h"

@implementation DatabaseDemon

@synthesize transFromCoreData = _transFromCoreData;
@synthesize managedObjectContext;

static DatabaseDemon *demon;
static BOOL secondInitDone;
static NSInteger translationCounter;
static NSMutableArray *widgetTranslation;

+ (DatabaseDemon *) summon
{
    if (demon == nil)
    {
        demon = [[self alloc] init];
        secondInitDone = NO;
        demon.transFromCoreData = [[NSArray alloc] init];
        return demon;
    }
    if (secondInitDone != YES)
    {
        demon = [[self alloc] initSecondTime];
        return demon;
    }
    
    return demon;
}

- (DatabaseDemon *) init
{
    self = [super init];
    return self;
}

- (DatabaseDemon *) initSecondTime
{
    if (self)
    {
        secondInitDone = YES;
        [self loadHistoryFromCloud];
        self.managedObjectContext = demon.managedObjectContext;
    }
    else
    {
        [NSException raise:@"demon was not initialised" format:@"DatabaseDemon.h row 49"];
    }
    return self;
}

#pragma mark - CRUD interface
- (NSArray *) loadHistoryFromCoreData
{
    //load form coreData
    NSUserDefaults *groupContainer = [[NSUserDefaults alloc] initWithSuiteName:APP_CONECTIVITY_ID];
    [groupContainer synchronize];
    widgetTranslation = [[groupContainer objectForKey:@"WidgetArray"] mutableCopy];
    
    if ([widgetTranslation count] > 0)
    {
        NSMutableArray *dataToInsert = [NSMutableArray new];
        
        for (int i=0; i<[widgetTranslation count]; i++)
        {
            NSMutableDictionary *foo = [[widgetTranslation objectAtIndex:i] mutableCopy];
            if ([foo[@"wasAddedToCoreData"] isEqual:[NSNumber numberWithInt:0]])
            {
                [foo setValue:[NSNumber numberWithInt:1] forKey:@"wasAddedToCoreData"];
                [widgetTranslation replaceObjectAtIndex:i withObject:[foo copy]];
                [TodayViewController setMyTranslations:widgetTranslation];
                [dataToInsert addObject:foo];
            }
        }
        
        //Insert data to database ASC by timestamp:
        if (dataToInsert.count > 0)
        {
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"stamp" ascending:YES];
            NSArray *sortedArray = [dataToInsert sortedArrayUsingDescriptors:@[descriptor]];
            
            for (NSInteger i=0; i<sortedArray.count; i++)
            {
                NSDictionary *dict = sortedArray[i];
                TranslationHistory *bar = [[TranslationHistory alloc]
                                           initWithInitialText:dict[@"initialText"]
                                           translatedText:dict[@"translatedText"]
                                           translationDirection:dict[@"languagePair"] // I know this may look akward but I actually send an array here ^_^
                                           favedState:[NSNumber numberWithInt:0]
                                           andStamp:nil];
                NSLog(@"I know I'm not suppose to use initializations for anything except init itself, but... %@",bar.initialText);
            }
        }
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Translations" inManagedObjectContext:demon.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    NSError *error;
    demon.transFromCoreData = [demon.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    translationCounter++;
    
    //need it for the widget sync
    //[[[NSUserDefaults alloc] initWithSuiteName:APP_CONECTIVITY_ID] setObject:@[] forKey:@"WidgetArray"];
    //[[[NSUserDefaults alloc] initWithSuiteName:APP_CONECTIVITY_ID] synchronize];
    //widgetTranslation = nil;
    return demon.transFromCoreData;
}

- (void) loadHistoryFromCloud
{
    if ([Settings isiCloudSyncEnabled])
    {
        if ([DatabaseDemon summon].transFromCoreData)
        {
            if (translationCounter >= 3)
            {
                NSData *bar = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:defaultKeyForDataStorage];
                if (bar)
                {
                    NSArray *foo = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUbiquitousKeyValueStore defaultStore] objectForKey:defaultKeyForDataStorage]];
                    [CoreData_iCloudBridge mergeLocalHistory:[DatabaseDemon summon].transFromCoreData withCloud:foo];
                }
            }
        }
    }
}

- (NSArray *) removeFromCoreDataObjectAt:(NSUInteger) index
{
    [demon.managedObjectContext deleteObject:[demon.transFromCoreData objectAtIndex:index]];
    NSError *error;
    if (![demon.managedObjectContext save:&error])
    {
        [NSException raise:@"Unable to delete object from coreData" format:@"DatabaseDemon.m row 81"];
    }
    [demon save];
    return [demon loadHistoryFromCoreData];
}

- (BOOL) save
{
    NSError *error;
    if (![demon.managedObjectContext save:&error])
    {
        [NSException raise:@"error while saving" format:@"DatabaseDemon.m row 99"];
    }
    [demon loadHistoryFromCoreData];
    if ([Settings isiCloudSyncEnabled])
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [[NSUbiquitousKeyValueStore defaultStore] setObject:[NSKeyedArchiver archivedDataWithRootObject:[CoreData_iCloudBridge transManagedObjectAfiliatedArrayToDictionaryArray:[DatabaseDemon summon].transFromCoreData]]  forKey:defaultKeyForDataStorage];
            BOOL test = [[NSUbiquitousKeyValueStore defaultStore] synchronize];
            NSLog(@"Cloud Sync Done %@",@(test));
        });
    }
    return YES;
}

- (void) formFavIndex
{
    if (!demon.favIndex)
    {
        demon.favIndex = [[NSMutableArray alloc] init];
    }
    
    [demon.favIndex removeAllObjects];
    for (int i = 0; i<[demon.transFromCoreData count]; i++)
    {
        if ([[demon.transFromCoreData objectAtIndex:i].faved isEqual:@(1)])
        {
            [demon.favIndex addObject:[NSNumber numberWithInt:i]];
        }
    }
}

- (TranslationHistory *) getFavedAtIndex:(NSInteger) index
{
    return [demon.transFromCoreData objectAtIndex:[[demon.favIndex objectAtIndex:index] doubleValue]];
}

- (void) setupMyLastTranslation:(TranslationHistory *) trans
{
    demon.myLastTranslation = trans;
    if (trans != nil)
    {
        [[LanguageSelectDemon summon] setAndSaveSourceLanguage:trans.sourceLang];
        [[LanguageSelectDemon summon] setCurrentDestinationlanguage:trans.destinationLang];
    }
}

- (void) switchMyLastTranslation
{
    NSString *temp = demon.myLastTranslation.initialText;
    demon.myLastTranslation.initialText = demon.myLastTranslation.translateText;
    demon.myLastTranslation.translateText = temp;
    
    NSString *oldSouce = _myLastTranslation.sourceLang;
    _myLastTranslation.sourceLang = _myLastTranslation.destinationLang;
    _myLastTranslation.destinationLang = oldSouce;
}

- (NSDictionary *) getMyLastTransAsDict
{
    return @{@"initialText" : demon.myLastTranslation.initialText,
             @"translateText" : demon.myLastTranslation.translateText,
             @"destinationLang" : demon.myLastTranslation.destinationLang,
             @"sourceLang" : demon.myLastTranslation.sourceLang,
             @"faved" : demon.myLastTranslation.faved,
             @"stamp" : demon.myLastTranslation.stamp
             };
}

@end

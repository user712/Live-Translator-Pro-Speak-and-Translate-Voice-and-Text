//
//  LanguageSelectDemon.m
//  Translator
//
//   1/18/16.
//  Copyright © 2016 Dev. 
//

#import "LanguageSelectDemon.h"

#define sourceLangLabel @"sourceLanguage"
#define destinationLangLabel @"destinationLanguage"

@implementation LanguageSelectDemon

static LanguageSelectDemon *m_LanguageSelectDemon;

NSMutableArray *PhotoArrayDemon;
NSMutableArray *recentlyUsedDemon;

+ (LanguageSelectDemon *) summon
{
    if (!m_LanguageSelectDemon)
    {
        m_LanguageSelectDemon = [[LanguageSelectDemon alloc] init];
        
        [m_LanguageSelectDemon PrepareLanguagesData];
        [m_LanguageSelectDemon laodCurrentLanguageData];
    }
    return m_LanguageSelectDemon;
}

- (instancetype) init
{
    self = [super init];
    return self;
}

- (void) PrepareLanguagesData
{
    recentlyUsedDemon = [[[[NSUserDefaults alloc] initWithSuiteName:APP_CONECTIVITY_ID] valueForKey:@"recentlyUsed"] mutableCopy];
    if (!recentlyUsedDemon)
    {
        recentlyUsedDemon = [[NSMutableArray alloc] init];
    }
    else
    {
        for (NSInteger i = 0; i < recentlyUsedDemon.count; i++)
        {
            NSString *item = recentlyUsedDemon[i];
            if ([item containsString:@"/"])
            {
                item = [[item lastPathComponent] stringByDeletingPathExtension];
            }
            [recentlyUsedDemon replaceObjectAtIndex:i withObject:item];
        }
    }
    
    //init from images available
    NSString *plistName = @"";
    if (!(BOOL)[[[NSUserDefaults standardUserDefaults] objectForKey:@"TranslationSource"] isEqual:@(1)])
    {
        plistName = @"FlagsGoogle";
    }
    else
    {
        plistName = @"FlagsYandex";
    }
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    if (plistPath)
    {
        NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
        PhotoArrayDemon = [array mutableCopy];
    }
    
    [self sortItems];
}

- (void) sortItems
{
    NSMutableArray *fullArray = [NSMutableArray new];
    for (NSInteger i=1; i<PhotoArrayDemon.count; i++)
    {
        
        NSString *flagItem = [PhotoArrayDemon objectAtIndex:i];
        NSString *languageValue = [LanguageList enumToString:[LanguageList indexOfItem:flagItem]];
        [fullArray addObject:@{@"flag" : flagItem, @"language" : languageValue}];
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"language" ascending:YES];
    NSArray *sortedArray = [fullArray sortedArrayUsingDescriptors:@[descriptor]];
    
    [PhotoArrayDemon removeAllObjects];
    for (NSInteger i=1; i<sortedArray.count; i++)
    {
        NSDictionary *dict = sortedArray[i];
        NSString *flagItem = dict[@"flag"];
        [PhotoArrayDemon addObject:flagItem];
    }
}

- (NSInteger) count
{
    return [PhotoArrayDemon count];
}

- (NSInteger) countRecent
{
    return [recentlyUsedDemon count];
}

- (NSString *) getImageAdressForShortName:(NSString *) name
{
    return name;
}

- (NSString *) getObjectAtIndex:(NSInteger) index
{
    return [PhotoArrayDemon objectAtIndex:index];
}

/**
 *alters the recent array in order to omit the last 2 accesed languages, as they are currently selected
 *forgot to note that at function creation, resulted in mind skweeks, when trying to figure what is does O_o
 */
- (NSString *) getRecentAtIndex:(NSInteger) index
{
    switch ([recentlyUsedDemon count])
    {
        case 3:
        {
            return [recentlyUsedDemon objectAtIndex:(long)index + 1];
        }
        case 4:
        {
            return [recentlyUsedDemon objectAtIndex:(long)index + 2];
        }
        default:
        {
            return [recentlyUsedDemon objectAtIndex:(long)index];
        }
    }
    
    return [recentlyUsedDemon objectAtIndex:(long) index];
}

//MARK: current Languages
- (void) laodCurrentLanguageData
{
    if (![[[NSUserDefaults alloc] initWithSuiteName:APP_CONECTIVITY_ID] objectForKey:sourceLangLabel])
    {
        NSLog(@"Wow we got a first run here (:");
        [[LanguageSelectDemon summon] setAndSaveSourceLanguage:@"en"];
        [[LanguageSelectDemon summon] setAndSaveDestiantionLanguage:@"es"];
        [[LanguageSelectDemon summon] saveCurrentLanguages];
    }
    else
    {
        [[LanguageSelectDemon summon] setAndSaveSourceLanguage:[[[NSUserDefaults alloc]initWithSuiteName:APP_CONECTIVITY_ID] objectForKey:sourceLangLabel]];
        [[LanguageSelectDemon summon] setAndSaveDestiantionLanguage:[[[NSUserDefaults alloc]initWithSuiteName:APP_CONECTIVITY_ID] objectForKey:destinationLangLabel]];
        NSLog(@"current set langs are : %@ - %@",[LanguageSelectDemon summon].currentSourceLanguage, [LanguageSelectDemon summon].currentDestinationlanguage);
    }
}

- (void) setAndSaveSourceLanguage:(NSString *) lang
{
    m_LanguageSelectDemon.currentSourceLanguage = lang;
    [[[NSUserDefaults alloc]initWithSuiteName:APP_CONECTIVITY_ID] setObject:m_LanguageSelectDemon.currentSourceLanguage forKey:sourceLangLabel];
    [[[NSUserDefaults alloc]initWithSuiteName:APP_CONECTIVITY_ID] synchronize];
}

- (void) setAndSaveDestiantionLanguage:(NSString *) lang
{
    m_LanguageSelectDemon.currentDestinationlanguage = lang;
    [[[NSUserDefaults alloc]initWithSuiteName:APP_CONECTIVITY_ID] setObject:m_LanguageSelectDemon.currentDestinationlanguage forKey:destinationLangLabel];
    [[[NSUserDefaults alloc]initWithSuiteName:APP_CONECTIVITY_ID] synchronize];
}

- (NSString *) getCurrentSourceLanguage
{
    return m_LanguageSelectDemon.currentSourceLanguage;
}

- (NSString *) getCurrentDestinationlanguage
{
    return m_LanguageSelectDemon.currentDestinationlanguage;
}

- (void) saveCurrentLanguages
{
    [[[NSUserDefaults alloc]initWithSuiteName:APP_CONECTIVITY_ID] setObject:m_LanguageSelectDemon.currentSourceLanguage forKey:sourceLangLabel];
    [[[NSUserDefaults alloc]initWithSuiteName:APP_CONECTIVITY_ID] setObject:m_LanguageSelectDemon.currentDestinationlanguage forKey:destinationLangLabel];
    [[[NSUserDefaults alloc]initWithSuiteName:APP_CONECTIVITY_ID] synchronize];
}

- (void) switchSourceAndDestination
{
    NSString *foo = m_LanguageSelectDemon.currentSourceLanguage;
    m_LanguageSelectDemon.currentSourceLanguage = m_LanguageSelectDemon.currentDestinationlanguage;
    m_LanguageSelectDemon.currentDestinationlanguage = foo;
    [m_LanguageSelectDemon saveCurrentLanguages];
}

- (NSMutableArray *) getRecentArray
{
    return recentlyUsedDemon;
}

- (void) saveRecetArray
{
    [[[NSUserDefaults alloc] initWithSuiteName:APP_CONECTIVITY_ID] setObject:[recentlyUsedDemon copy] forKey:@"recentlyUsed"];
}

- (void) addItemToRecentArray:(NSString *) item
{
    if (![item isEqualToString:@"ad"])
    {
        NSString *actualItem = item;
        
        for (int i = 0; i<[recentlyUsedDemon count]; i++)
        {
            if ([recentlyUsedDemon[i] isEqualToString:actualItem])
            {
                [Tools moveOnTopRecetObjectAtIndex:i fromArray:recentlyUsedDemon];
                return;
            }
        }
        
        //got a new item here
        if ([recentlyUsedDemon count] > 3)
        {
            [recentlyUsedDemon removeLastObject];
        }
        
        [recentlyUsedDemon insertObject:actualItem atIndex:0];
        [self saveRecetArray];
    }
}

- (NSArray *) formRequestLanguages:(BOOL) reversed
{
    NSArray *r;
    if (reversed)
    {
        r = @[m_LanguageSelectDemon.currentDestinationlanguage,m_LanguageSelectDemon.currentSourceLanguage];
    }
    else
    {
        r = @[m_LanguageSelectDemon.currentSourceLanguage, m_LanguageSelectDemon.currentDestinationlanguage];
    }
    return r;
}

@end



//
//  CoreData_iCloudBridge.m
//  Translator
//
//   11/20/15.
//  Copyright © 2015 Dev. 
//

#import "CoreData_iCloudBridge.h"

@implementation CoreData_iCloudBridge

+ (NSArray *) transManagedObjectAfiliatedArrayToDictionaryArray:(NSArray *) moc
{
    NSMutableArray *bar = [[NSMutableArray alloc] init];
    for (TranslationHistory *foo in moc)
    {
        [bar addObject:@{@"faved" : foo.faved,
                         @"initialText" : foo.initialText,
                         @"translateText" : foo.translateText,
                         @"sourceLang" : foo.sourceLang,
                         @"destinationLang" : foo.destinationLang,
                         @"stamp" : foo.stamp}];
    }
    return [bar copy];
}

+ (BOOL) mergeLocalHistory:(NSArray *) arrayLoc withCloud:(NSArray *) arrayCloud
{
    BOOL gotSomething = NO;

    //#warning lame,  try to remove
    //delets all local items
    for (int i = 0; i<[[DatabaseDemon summon].transFromCoreData count]; i++)
    {
        [[DatabaseDemon summon].managedObjectContext deleteObject:[[DatabaseDemon summon].transFromCoreData objectAtIndex:i]];
    }
    
    //and adds all remote again;
    for (NSDictionary *foo in arrayCloud)
    {
        /*
         This is my old try at "normal" sync, but... it didn't work as expected, had problems with deleting and was to lasy to make a "token" system for it
         */
        
        //        BOOL notFound = YES;
        //        if ([arrayLoc count]==0) {
        //            gotSomething = YES;
        //        }
        //
        //        //: now have to delete items individualy, make shure to delete them
        //                // simple way, delete all objects add all the new ones, spares lots of time on checks and stuff
        //        for (TranslationHistory *bar in arrayLoc) {
        //            if ([bar.stamp isEqual:[foo objectForKey:@"stamp"]] ) {
        //                bar.faved = [foo objectForKey:@"faved"];
        //                NSError *error;
        //                if (![[DatabaseDemon summon].managedObjectContext save:&error]) {
        //                    [NSException raise:@"error while saving" format:@"CoreData_iCloudBridge.m row 54"];
        //                }
        //
        //                notFound = NO;
        //                break;
        //            }
        //        }
        //        if (notFound) {
        //            TranslationHistory *asd = [[TranslationHistory alloc] initWithInitialText:[foo objectForKey:@"initialText"]
        //                                                                       translatedText:[foo objectForKey:@"translateText"]
        //                                                                 translationDirection:[foo objectForKey:@"translationDirection"]
        //                                                                           favedState:[foo objectForKey:@"faved"]
        //                                                                             andStamp:[foo objectForKey:@"stamp"]];
        //            NSLog(@"STFU abou Loading cloud data%@",asd.stamp);
        //            gotSomething = YES;
        //        }
        TranslationHistory *asd = [[TranslationHistory alloc] initWithInitialText:[foo objectForKey:@"initialText"]
                                                                   translatedText:[foo objectForKey:@"translateText"]
                                                             translationDirection:@[[foo objectForKey:@"sourceLang"], [foo objectForKey:@"destinationLang"]]
                                                                       favedState:[foo objectForKey:@"faved"]
                                                                         andStamp:[foo objectForKey:@"stamp"]];
        gotSomething = YES;
    }
    
    if (gotSomething)
    {
        [[DatabaseDemon summon] loadHistoryFromCoreData];
        [[DatabaseDemon summon] save];
    }
    return gotSomething;
}

@end

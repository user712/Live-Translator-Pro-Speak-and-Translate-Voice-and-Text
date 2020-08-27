//
//  CoreData_iCloudBridge.h
//  Translator
//
//   11/20/15.
//  Copyright © 2015 Dev. 
//

#import <Foundation/Foundation.h>
#import "TranslationHistory.h"
#import "DatabaseDemon.h"

@interface CoreData_iCloudBridge : NSObject

+ (NSArray *) transManagedObjectAfiliatedArrayToDictionaryArray:(NSArray *) moc;
+ (BOOL) mergeLocalHistory:(NSArray *) arrayLoc withCloud:(NSArray *) arrayCloud;

@end

//
//  PersistenStack.h
//  Translator
//
//   11/20/15.
//  Copyright © 2015 Dev. 
//

#import <Foundation/Foundation.h>

#define defaultPersistenceStoreName @"iCloud_abc_Translator2"

@import CoreData;

@interface PersistenStack : NSObject

- (id) initWithStoreURL:(NSURL *) storeURL modelURL:(NSURL *) modeURL;

@property (nonatomic,strong,readonly) NSManagedObjectContext *managedObjectContext;

@end

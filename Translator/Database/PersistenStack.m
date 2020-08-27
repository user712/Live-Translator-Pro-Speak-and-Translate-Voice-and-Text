//
//  PersistenStack.m
//  Translator
//
//   11/20/15.
//  Copyright © 2015 Dev. 
//

#import "PersistenStack.h"
#import "DatabaseDemon.h"

@interface PersistenStack()

@property (nonatomic,strong,readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSURL *modelURL;
@property (nonatomic, strong) NSURL *storeURL;

@end

@implementation PersistenStack

- (id) initWithStoreURL:(NSURL *) storeURL modelURL:(NSURL *) modeURL
{
    self = [super init];
    if (self)
    {
        self.storeURL = storeURL;
        self.modelURL = modeURL;
        [self setupManagedObjectContext];
    }
    return self;
}

- (void) setupManagedObjectContext
{
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    self.managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    [DatabaseDemon summon].managedObjectContext = self.managedObjectContext;
    NSError *error;
    [[DatabaseDemon summon].managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                                        configuration:nil
                                                                                                  URL:self.storeURL
                                                                                              options:@{NSPersistentStoreUbiquitousContentNameKey : defaultPersistenceStoreName}
                                                                                                error:&error];
    
    if (error)
    {
        NSLog(@"Unresolved %@, %@",error, [error userInfo]);
    }
}

- (NSManagedObjectModel *) managedObjectModel
{
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
}

@end

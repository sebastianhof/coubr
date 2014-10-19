//
//  coubrDatabaseManager.m
//  coubr
//
//  Created by Sebastian Hof on 16.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "coubrDatabaseManager.h"

@interface coubrDatabaseManager ()

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, atomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation coubrDatabaseManager

static coubrDatabaseManager *databaseManagerinstance = nil;

+ (instancetype)defaultManager
{
    
    if (!databaseManagerinstance) {
        databaseManagerinstance = [[coubrDatabaseManager alloc] init];
    }
    return databaseManagerinstance;
}

#pragma mark - init

- (NSURL *)coubrApplicationDocumentDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    return documentsDirectory;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel) {
        
        NSString *modelPath = [[NSBundle mainBundle] pathForResource:ManagedDatabaseModelName ofType:@"momd"];
        NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
        
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSURL *persistentStoreURL = [[self coubrApplicationDocumentDirectory] URLByAppendingPathComponent:ManagedDatabasePersistentStoreURL];
        
        NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption: [NSNumber numberWithBool:YES],
                                   NSInferMappingModelAutomaticallyOption: [NSNumber numberWithBool: YES]
                                   };

        NSError *error;
        BOOL success = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                 configuration:nil
                                                                           URL:persistentStoreURL
                                                                       options:options
                                                                         error:&error];
        
        if (!success) {
            
            NSLog(@"Could not init persistent store coordinator: %@", [error localizedDescription]);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ManagedDatabaseDidFailInitializingNotification object:self];
            
        }
        
    }
    return _persistentStoreCoordinator;
}

@synthesize managedObjectContext = _manageObjectContext;

- (NSManagedObjectContext *)managedObjectContext
{
    
    if (!_manageObjectContext) {
        
        if (self.persistentStoreCoordinator) {
            
            _manageObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_manageObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
            
            if (!_manageObjectContext) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ManagedDatabaseDidFailInitializingNotification object:self];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:ManagedDatabaseDidBecomeAvailableNotification object:self];
            }
            
        }
        
    }
    
    return _manageObjectContext;
}

- (void)initDatabase {
    
    if (self.managedObjectContext) {
        NSLog(@"Managed Object Context intialized");
    }

}

@end

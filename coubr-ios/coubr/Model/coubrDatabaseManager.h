//
//  coubrDatabaseManager.h
//  coubr
//
//  Created by Sebastian Hof on 16.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ManagedDatabaseContext @"ManagedDatabaseContext"
#define ManagedDatabaseDidBecomeAvailableNotification @"ManagedDatabaseDidBecomeAvailableNotification"
#define ManagedDatabaseDidFailInitializingNotification @"ManagedDatabaseDidFailInitializingNotification"


#define ManagedDatabaseModelName @"coubrModel"
#define ManagedDatabasePersistentStoreURL @"coubr.sqlite"

@interface coubrDatabaseManager : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

+ (instancetype)defaultManager;

- (void)initDatabase;

@end

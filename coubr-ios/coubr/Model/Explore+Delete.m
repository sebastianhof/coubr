//
//  Explore+Delete.m
//  coubr
//
//  Created by Sebastian Hof on 16.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "Explore+Delete.h"
#import "coubrDatabaseManager.h"

@implementation Explore (Delete)

+ (void)deleteExploreItemsInDatabase
{
    NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
    
    if (context) {
        
        NSError *error;
        NSFetchRequest *fetchRequest  = [NSFetchRequest fetchRequestWithEntityName:@"Explore"];
        [fetchRequest setIncludesPropertyValues:NO];
        
        NSArray *exploreItems = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"Could not retrieve items of Explore: %@", [error localizedDescription]);
        } else {
            
            for (NSManagedObject *exploreItem in exploreItems) {
                
                if (![exploreItem isDeleted]) {
                    [context deleteObject:exploreItem];
                }
                
      
            }
            
        }
        
    }
      
    
}

@end

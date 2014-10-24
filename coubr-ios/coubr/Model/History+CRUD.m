//
//  History+CRUD.m
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "History+CRUD.h"
#import "coubrDatabaseManager.h"
#import "Store.h"

@implementation History (CRUD)

+ (BOOL)insertHistoryIntoDatabaseFromCoupon:(Coupon *)coupon
{
    
    NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
    
    if (context) {
        
        [context performBlockAndWait:^{
            NSError *error;
            NSArray *result;
            
            // Fetch history in near past
            result = [context executeFetchRequest:[self fetchRequestForShorttermHistoryWithStore:coupon.store] error:&error];
            
            History *history;
            if (result.count > 0) {
                // Store exists already
                history = (History *) [result firstObject];
            } else {
                // Insert new store
                history = (History *) [NSEntityDescription insertNewObjectForEntityForName:@"History" inManagedObjectContext:context];
            }

            history.date = [NSDate date];
            
            if (![history.store isEqual:coupon.store]) {
                history.store = coupon.store;
            }
            
            if (!history.coupons) {
                history.coupons = [[NSMutableSet alloc] initWithObjects:coupon, nil];
            } else {
                [((NSMutableSet *) history.coupons) addObject:coupon];
            }
            
            [context save:&error];
            if (error) {
                NSLog(@"Could not save context: %@", error);
            }
            
        }];
        
        
        return true;
        
    }
    
    return false;
}

+ (NSFetchRequest *)fetchRequestForHistory
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"History"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                              ascending:NO]];
    
    return request;
}

+ (NSFetchRequest *)fetchRequestForShorttermHistoryWithStore:(Store *)store
{
    // Visit must be last hour ago to count to current date
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:-1];
    NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"History"];
    request.predicate = [NSPredicate predicateWithFormat:@"(store = %@) AND (date > %@)", store, date];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                              ascending:NO]];
    
    return request;
}

@end

//
//  Coupon+CRUD.m
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "Coupon+CRUD.h"
#import "coubrDatabaseManager.h"

@implementation Coupon (CRUD)

+ (NSFetchRequest *)fetchRequestForCouponWithId:(NSString *)couponId
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Coupon"];
    request.predicate = [NSPredicate predicateWithFormat:@"(couponId = %@)", couponId];
    
    return request;
}

+ (void)deleteCouponsInDatabase
{
    
    NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
    
    if (context) {
        
        [context performBlockAndWait:^{
            
            NSFetchRequest *fetchRequest  = [NSFetchRequest fetchRequestWithEntityName:@"Coupon"];
            [fetchRequest setIncludesPropertyValues:NO];
            NSError *error;
            NSArray*  coupons = [context executeFetchRequest:fetchRequest error:&error];
            if (error) {
                NSLog(@"Could not retrieve coupons: %@", [error localizedDescription]);
            } else {
                
                for (NSManagedObject *managedObject in coupons) {
                    
                    Coupon *coupon = (Coupon *)managedObject;
                    
                    if (coupon.histories && coupon.histories.count > 0) {
                        // cannot delete coupons in history
                        continue;
                    }
                    
                    if (coupon.isDeleted) {
                        // already deleted
                        continue;
                    }

                    [context deleteObject:coupon];

                }
                
            }
            
        }];
        
    }
    
    
}

@end

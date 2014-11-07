//
//  Explore+CRUD.m
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "Explore+CRUD.h"

#import <CoreLocation/CoreLocation.h>
#import "coubrLocationManager.h"

#import "coubrUtil.h"
#import "coubrConstants.h"
#import "coubrDatabaseManager.h"


@implementation Explore (CRUD)

+ (BOOL)insertExploreIntoDatabaseFromExploreJSON:(NSDictionary *)exploreJSON
{
    
    NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
    
    if (!context) {
        return false;
    }
    
    if (!isValidJSONValue(exploreJSON[EXPLORE_RESPONSE_STORES])) {
        return false;
    }
    
    NSArray *stores = exploreJSON[EXPLORE_RESPONSE_STORES];
    
    [context performBlockAndWait:^{
        
        for (NSDictionary *store in stores) {
            
            NSString *storeId = isValidJSONValue(store[EXPLORE_RESPONSE_STORE_ID]) ? store[EXPLORE_RESPONSE_STORE_ID] : nil;
            
            if (!storeId) {
                continue;
            }
            
            // block: fetch coupon
            NSError *error;
            NSArray *result;
            
            result = [context executeFetchRequest:[self fetchRequestForExploreStoreWithId:storeId] error:&error];
            
            Explore *explore;
            if (result.count > 0) {
                // explore exists already
                explore = (Explore *) [result firstObject];
            } else {
                // insert new explore
                explore = (Explore *) [NSEntityDescription insertNewObjectForEntityForName:@"Explore" inManagedObjectContext:context];
            }
            
            explore.storeId = storeId;
            explore.name = isValidJSONValue(store[EXPLORE_RESPONSE_STORE_NAME]) ? store[EXPLORE_RESPONSE_STORE_NAME] : nil;
            
            explore.type = isValidJSONValue(store[EXPLORE_RESPONSE_STORE_TYPE]) ? store[EXPLORE_RESPONSE_STORE_TYPE] : nil;
            explore.category = isValidJSONValue(store[EXPLORE_RESPONSE_STORE_CATEGORY]) ? store[EXPLORE_RESPONSE_STORE_CATEGORY] : nil;
            explore.subcategory = isValidJSONValue(store[EXPLORE_RESPONSE_STORE_SUBCATEGORY]) ? store[EXPLORE_RESPONSE_STORE_SUBCATEGORY] : nil;
            
            explore.latitude = isValidJSONValue(store[EXPLORE_RESPONSE_STORE_LATITUDE]) ? store[EXPLORE_RESPONSE_STORE_LATITUDE] : nil;
            explore.longitude = isValidJSONValue(store[EXPLORE_RESPONSE_STORE_LONGITUDE]) ? store[EXPLORE_RESPONSE_STORE_LONGITUDE] : nil;
            
            if (explore.latitude && explore.longitude)
            {
                CLLocationDegrees latitude = [store[EXPLORE_RESPONSE_STORE_LATITUDE] doubleValue] ;
                CLLocationDegrees longitude = [store[EXPLORE_RESPONSE_STORE_LONGITUDE] doubleValue];
                
                CLLocation *storeLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                
                CLLocationDistance distance = [storeLocation distanceFromLocation:[[coubrLocationManager defaultManager] userLocation]];
                explore.distance = [NSNumber numberWithDouble:distance];
            }
            
            explore.coupons = isValidJSONValue(store[EXPLORE_RESPONSE_STORE_COUPONS]) ? store[EXPLORE_RESPONSE_STORE_COUPONS] : nil;
            
        }
        
    }];
    
    return true;
}

+ (NSFetchRequest *)fetchRequestForExploreWithinDistance:(double)distance
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Explore"];
    //request.predicate = [NSPredicate predicateWithFormat:@"(distance < %@)", [NSNumber numberWithDouble:distance]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"distance"
                                                              ascending:YES]];
    return request;
}

+ (NSFetchRequest *)fetchRequestForExploreStoreWithId:(NSString *)storeId
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Explore"];
    request.predicate = [NSPredicate predicateWithFormat:@"(storeId = %@)", storeId];
    
    return request;
}

+ (NSFetchRequest *)fetchRequestForExploreCouponWithId:(NSString *)couponId
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ExploreCoupon"];
    request.predicate = [NSPredicate predicateWithFormat:@"(couponId = %@)", couponId];
    
    return request;
}


+ (void)deleteExploreItemsInDatabase
{
    NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
    
    if (context) {

        [context performBlockAndWait:^{
            
            NSFetchRequest *fetchRequest  = [NSFetchRequest fetchRequestWithEntityName:@"Explore"];
            [fetchRequest setIncludesPropertyValues:NO];
            NSError *error;
            NSArray*  exploreItems = [context executeFetchRequest:fetchRequest error:&error];
            if (error) {
                NSLog(@"Could not retrieve items of Explore: %@", [error localizedDescription]);
            } else {
                
                for (NSManagedObject *exploreItem in exploreItems) {
                    
                    if (exploreItem.isDeleted) {
                        // already deleted
                        continue;
                    }
                    
                    [context deleteObject:exploreItem];
                    
                }
                
            }
            
        }];
        
    }
    
}

@end

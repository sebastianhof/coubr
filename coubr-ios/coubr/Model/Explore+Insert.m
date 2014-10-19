//
//  Explore+Insert.m
//  coubr
//
//  Created by Sebastian Hof on 16.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import "coubrConstants.h"

#import "Explore+Insert.h"

#import "ExploreCoupon.h"

#import "coubrLocationManager.h"
#import "coubrDatabaseManager.h"

@implementation Explore (Insert)

static BOOL isValidJSONValue(NSObject *JSONValue)
{
    return JSONValue != [NSNull null];
}

+ (void)insertExploreItemsIntoDatabaseFromExploreJSON:(NSDictionary *)exploreJSON
{
    
    NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
    
    if (!context) {
        return;
    }
    
    if (!isValidJSONValue(exploreJSON[EXPLORE_RESPONSE_STORES])) {
        return;
    }
    
    NSArray *stores = exploreJSON[EXPLORE_RESPONSE_STORES];
    
    
    
    for (NSDictionary *store in stores) {
        
        NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Explore" inManagedObjectContext:context];
        Explore *explore = (Explore *) managedObject;
        
        explore.storeId = isValidJSONValue(store[EXPLORE_RESPONSE_STORE_ID]) ? store[EXPLORE_RESPONSE_STORE_ID] : nil;
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

            CLLocationDistance distance = [storeLocation distanceFromLocation:[[coubrLocationManager defaultManager] lastLocation]];
            explore.distance = [NSNumber numberWithDouble:distance];
        }
        
        NSMutableArray *coupons = [[NSMutableArray alloc] init];
        
        if (isValidJSONValue(store[EXPLORE_RESPONSE_STORE_COUPONS])) {
            
            for (NSString* storeCouponTitle in store[EXPLORE_RESPONSE_STORE_COUPONS]) {
                
                NSManagedObject *managedCouponObject = [NSEntityDescription insertNewObjectForEntityForName:@"ExploreCoupon" inManagedObjectContext:context];
                ExploreCoupon *exploreCoupon = (ExploreCoupon *)managedCouponObject;
                exploreCoupon.title = storeCouponTitle;
                [coupons addObject:exploreCoupon];
            }
            
        }
        
        if (coupons.count > 0) {
            explore.coupons = [[NSSet alloc] initWithArray:coupons];
        }
        
    }
    
}

@end

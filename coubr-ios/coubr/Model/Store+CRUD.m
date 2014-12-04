//
//  Store+CRUD.m
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "Store+CRUD.h"
#import "Store+Distance.h"
#import "Coupon+CRUD.h"
#import "StampCard+CRUD.h"
#import "SpecialOffer+CRUD.h"
#import "StoreMenuItem+CRUD.h"
#import "StoreOpeningTime+CRUD.h"

#import "StoreMenuItem+Dummy.h"
#import "StoreOpeningTime+Dummy.h"

#import "coubrUtil.h"
#import "coubrConstants.h"
#import "coubrDatabaseManager.h"
#import "coubrLocationManager.h"

#import <CoreLocation/CoreLocation.h>

@implementation Store (CRUD)

+ (BOOL)insertStoreIntoDatabaseFromStoreJSON:(NSDictionary *)storeJSON
{
    // Check import variables
    
    NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
    if (!context) {
        return false;
    }
    
    // Get and parse JSON Values
    NSString *storeId = isValidJSONValue(storeJSON[STORE_RESPONSE_STORE_ID]) ? storeJSON[STORE_RESPONSE_STORE_ID] : nil;
    if (!storeId) {
        return false;
    }
    
    // Perform Blcok
    [context performBlockAndWait:^{
        NSError *error;
        NSArray *result;
        
        // Fetch old stores
        result = [context executeFetchRequest:[self fetchRequestForStoreWithId:storeId] error:&error];
        
        Store *store;
        if (result.count > 0) {
            // Store exists already
            store = (Store *) [result firstObject];
        } else {
            // Insert new store
            store = (Store *) [NSEntityDescription insertNewObjectForEntityForName:@"Store" inManagedObjectContext:context];
        }
        
        store.storeId = storeId;
        store.name = isValidJSONValue(storeJSON[STORE_RESPONSE_STORE_NAME]) ? storeJSON[STORE_RESPONSE_STORE_NAME] : nil;
        store.storeDescription = isValidJSONValue(storeJSON[STORE_RESPONSE_STORE_DESCRIPTION]) ? storeJSON[STORE_RESPONSE_STORE_DESCRIPTION] : nil;
        
        store.type = isValidJSONValue(storeJSON[STORE_RESPONSE_STORE_TYPE]) ? storeJSON[STORE_RESPONSE_STORE_TYPE] : nil;
        store.category = isValidJSONValue(storeJSON[STORE_RESPONSE_STORE_CATEGORY]) ? storeJSON[STORE_RESPONSE_STORE_CATEGORY] : nil;
        store.subcategory = isValidJSONValue(storeJSON[STORE_RESPONSE_STORE_SUBCATEGORY]) ? storeJSON[STORE_RESPONSE_STORE_SUBCATEGORY] : nil;
        
        store.latitude = isValidJSONValue(storeJSON[STORE_RESPONSE_STORE_LATITUDE]) ? storeJSON[STORE_RESPONSE_STORE_LATITUDE] : nil;
        store.longitude = isValidJSONValue(storeJSON[STORE_RESPONSE_STORE_LONGITUDE]) ? storeJSON[STORE_RESPONSE_STORE_LONGITUDE] : nil;
        
        store.street = isValidJSONValue(storeJSON[STORE_RESPONSE_STORE_STREET]) ? storeJSON[STORE_RESPONSE_STORE_STREET] : nil;
        store.postalCode = isValidJSONValue(storeJSON[STORE_RESPONSE_STORE_POSTAL_CODE]) ? storeJSON[STORE_RESPONSE_STORE_POSTAL_CODE] : nil;
        store.city = isValidJSONValue(storeJSON[STORE_RESPONSE_STORE_CITY]) ? storeJSON[STORE_RESPONSE_STORE_CITY] : nil;
        
        store.phone = isValidJSONValue(storeJSON[STORE_RESPONSE_STORE_PHONE]) ? storeJSON[STORE_RESPONSE_STORE_PHONE] : nil;
        store.email = isValidJSONValue(storeJSON[STORE_RESPONSE_STORE_EMAIL]) ? storeJSON[STORE_RESPONSE_STORE_EMAIL] : nil;
        store.website = isValidJSONValue(storeJSON[STORE_RESPONSE_STORE_WEBSITE]) ? storeJSON[STORE_RESPONSE_STORE_WEBSITE] : nil;
        
        CLLocationDegrees latitude = [store.latitude doubleValue] ;
        CLLocationDegrees longitude = [store.longitude doubleValue];
        CLLocation *storeLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        store.distance = [NSNumber numberWithDouble:[storeLocation distanceFromLocation:[[coubrLocationManager defaultManager] userLocation]]];
        
        if (storeJSON[STORE_RESPONSE_STORE_COUPONS]) {
            [Coupon insertCouponsToStore:store andCouponJSONs:storeJSON[STORE_RESPONSE_STORE_COUPONS]];
        }
        
        if (storeJSON[STORE_RESPONSE_STORE_STAMP_CARDS]) {
            [StampCard insertStampCardsToStore:store andStampCardsJSONs:storeJSON[STORE_RESPONSE_STORE_STAMP_CARDS]];
        }
        
        if (storeJSON[STORE_RESPONSE_STORE_SPECIAL_OFFERS]) {
            [SpecialOffer insertSpecialOffersToStore:store andSpecialOffersJSONs:storeJSON[STORE_RESPONSE_STORE_SPECIAL_OFFERS]];
        }
        
        if (store.menuItems && store.menuItems.count > 0) {
            
            for (NSManagedObject *managedObject in store.menuItems) {
                [context deleteObject:managedObject];
            }
            
        }
        
        if (storeJSON[STORE_RESPONSE_STORE_MENU]) {
            [StoreMenuItem insertStoreMenuItemsToStore:store categories:storeJSON[STORE_RESPONSE_MENU_CATEGORIES]];
        } else {
            [StoreMenuItem insertStoreMenuItemsToStore:store categories:[StoreMenuItem menuCategories]];
        }
        
        if (store.openingTimes && store.openingTimes.count > 0) {
            
            for (NSManagedObject *managedObject in store.openingTimes) {
                [context deleteObject:managedObject];
            }
            
        }
        
        if (storeJSON[STORE_RESPONSE_STORE_OPENING_TIMES]) {
            [StoreOpeningTime insertStoreOpeningTimesToStore:store andStoreOpeningTimesJSONs:storeJSON[STORE_RESPONSE_STORE_OPENING_TIMES]];
        } else {
            [StoreOpeningTime insertStoreOpeningTimesToStore:store andStoreOpeningTimesJSONs:[StoreOpeningTime openingTimes]];
        }
        
        

    }];

    return true;
    
}

+ (NSFetchRequest *)fetchRequestForStoreWithId:(NSString *)storeId {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Store"];
    request.predicate = [NSPredicate predicateWithFormat:@"(storeId = %@)", storeId];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    
    return request;
}

+ (NSFetchRequest *)fetchRequestForFavoriteStores
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Store"];
    request.predicate = [NSPredicate predicateWithFormat:@"(isFavorite = %@)", [NSNumber numberWithBool:YES]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES]];
    return request;
}


@end

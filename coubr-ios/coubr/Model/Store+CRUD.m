//
//  Store+CRUD.m
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "Store+CRUD.h"
#import "Coupon+CRUD.h"

#import "coubrUtil.h"
#import "coubrConstants.h"
#import "coubrDatabaseManager.h"

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
        
        if (storeJSON[STORE_RESPONSE_STORE_COUPONS]) {
            
            for (NSDictionary* couponJSON in storeJSON[STORE_RESPONSE_STORE_COUPONS]) {
                
                if (isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_ID])) {
                    
                    result = [context executeFetchRequest:[Coupon fetchRequestForCouponWithId:couponJSON[STORE_RESPONSE_COUPON_ID]] error:&error];
                    
                    Coupon *coupon;
                    if (result.count > 0) {
                        // coupon exists already
                        coupon = (Coupon *) [result firstObject];
                        if (result.count > 1) {
                            // delete the rest
                        }
                    } else {
                        // insert new coupon
                        coupon = (Coupon *) [NSEntityDescription insertNewObjectForEntityForName:@"Coupon" inManagedObjectContext:context];
                    }
                    
                    NSDate *validTo;
                    NSNumber *amount;
                    NSNumber *amountIssued;
                    
                    if (isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_AMOUNT])) {
                        NSTimeInterval timeInterval = [couponJSON[STORE_RESPONSE_COUPON_VALID_TO] doubleValue] / 1000.0;
                        validTo = [NSDate dateWithTimeIntervalSince1970:timeInterval];
                    }
                    
                    if (isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_AMOUNT_ISSUED])) {
                        amount = couponJSON[STORE_RESPONSE_COUPON_AMOUNT];
                    }
                    
                    
                    if (isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_VALID_TO])) {
                        amountIssued = couponJSON[STORE_RESPONSE_COUPON_AMOUNT_ISSUED];
                    }
                    
                    coupon.couponId = couponJSON[STORE_RESPONSE_COUPON_ID];
                    coupon.title = isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_TITLE]) ? couponJSON[STORE_RESPONSE_COUPON_TITLE] : nil;
                    coupon.couponDescription = isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_DESCRIPTION]) ? couponJSON[STORE_RESPONSE_COUPON_DESCRIPTION] : nil;
                    coupon.category = isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_CATEGORY]) ? couponJSON[STORE_RESPONSE_COUPON_CATEGORY] : nil;
                    coupon.validTo = validTo;
                    coupon.amount = amount;
                    coupon.amountIssued = amountIssued;
                    coupon.store = store;
                    
                }
                
            }
            
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

+ (NSFetchRequest *)fetchRequestForCouponsOfStoreWithId:(NSString *)storeId
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Coupon"];
    request.predicate = [NSPredicate predicateWithFormat:@"(store.storeId = %@)", storeId];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"validTo"
                                                              ascending:YES]];
    
    return request;
}

+ (NSFetchRequest *)fetchRequestForFavoriteStores
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Store"];
    request.predicate = [NSPredicate predicateWithFormat:@"(isFavorite = %@)", [NSNumber numberWithBool:YES]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    
    return request;
}


+ (void)deleteStoresInDatabase
{
    
    NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
    
    if (context) {
        
        [context performBlockAndWait:^{
            
            NSFetchRequest *fetchRequest  = [NSFetchRequest fetchRequestWithEntityName:@"Store"];
            [fetchRequest setIncludesPropertyValues:NO];
            NSError *error;
            NSArray*  stores = [context executeFetchRequest:fetchRequest error:&error];
            if (error) {
                NSLog(@"Could not retrieve stores: %@", [error localizedDescription]);
            } else {
                
                for (NSManagedObject *managedObject in stores) {
                    
                    Store * store = (Store *)managedObject;
                    
                    if ([store.isFavorite boolValue] == YES) {
                        // cannot delete favorites
                        continue;
                    }
                    
                    if (store.histories && store.histories.count > 0) {
                        // canot delete stores in history
                        continue;
                    }
                    
                    if (store.isDeleted) {
                        // already deleted
                        continue;
                    }
                    
                    [context deleteObject:store];
                    
                }
                
            }
            
        }];
        
    }
    
}

@end

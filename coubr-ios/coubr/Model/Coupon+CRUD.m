//
//  Coupon+CRUD.m
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "Coupon+CRUD.h"

#import "coubrUtil.h"
#import "coubrConstants.h"
#import "coubrDatabaseManager.h"

@implementation Coupon (CRUD)

+ (NSFetchRequest *)fetchRequestForCouponWithId:(NSString *)couponId
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Coupon"];
    request.predicate = [NSPredicate predicateWithFormat:@"(couponId = %@)", couponId];
    
    return request;
}

+ (NSFetchRequest *)fetchRequestForCouponsOfStoreWithId:(NSString *)storeId
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Coupon"];
    request.predicate = [NSPredicate predicateWithFormat:@"(store.storeId = %@)", storeId];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                              ascending:YES]];
    
    return request;
}

+ (void)insertCouponsToStore:(Store *)store andCouponJSONs:(NSArray *)couponJSONs
{
    
    NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
    
    for (NSDictionary* couponJSON in couponJSONs) {
        
        if (isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_ID])) {
            
            NSError *error;
            NSArray *result = [context executeFetchRequest:[Coupon fetchRequestForCouponWithId:couponJSON[STORE_RESPONSE_COUPON_ID]] error:&error];
            
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
            if (isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_VALID_TO])) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                validTo = [dateFormatter dateFromString:couponJSON[STORE_RESPONSE_COUPON_VALID_TO]];
            }

            
            coupon.couponId = couponJSON[STORE_RESPONSE_COUPON_ID];
            coupon.title = isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_TITLE]) ? couponJSON[STORE_RESPONSE_COUPON_TITLE] : nil;
            coupon.couponDescription = isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_DESCRIPTION]) ? couponJSON[STORE_RESPONSE_COUPON_DESCRIPTION] : nil;
            coupon.category = isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_CATEGORY]) ? couponJSON[STORE_RESPONSE_COUPON_CATEGORY] : nil;
            coupon.validTo = validTo;
            coupon.amount = isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_AMOUNT]) ? couponJSON[STORE_RESPONSE_COUPON_AMOUNT] : nil;
            coupon.amountRedeemed = isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_AMOUNT_REDEEMED]) ? couponJSON[STORE_RESPONSE_COUPON_AMOUNT_REDEEMED]: nil;
            coupon.store = store;
            
        }
        
    }
    
}

@end

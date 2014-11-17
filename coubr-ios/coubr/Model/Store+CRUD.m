//
//  Store+CRUD.m
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "Store+CRUD.h"
#import "Coupon+CRUD.h"
#import "StampCard+CRUD.h"
#import "SpecialOffer+CRUD.h"

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
        store.website = isValidJSONValue(storeJSON[STORE_RESPONSE_STORE_WEBSITE]) ? storeJSON[STORE_RESPONSE_STORE_WEBSITE] : nil;
        
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
                    NSNumber *amountRedeemed;
                    
                    if (isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_VALID_TO])) {
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                        validTo = [dateFormatter dateFromString:couponJSON[STORE_RESPONSE_COUPON_VALID_TO]];

                    }
                    
                    if (isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_AMOUNT])) {
                        amount = couponJSON[STORE_RESPONSE_COUPON_AMOUNT];
                    }
                    
                    
                    if (isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_AMOUNT_REDEEMED])) {
                        amountRedeemed= couponJSON[STORE_RESPONSE_COUPON_AMOUNT_REDEEMED];
                    }
                    
                    coupon.couponId = couponJSON[STORE_RESPONSE_COUPON_ID];
                    coupon.title = isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_TITLE]) ? couponJSON[STORE_RESPONSE_COUPON_TITLE] : nil;
                    coupon.couponDescription = isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_DESCRIPTION]) ? couponJSON[STORE_RESPONSE_COUPON_DESCRIPTION] : nil;
                    coupon.category = isValidJSONValue(couponJSON[STORE_RESPONSE_COUPON_CATEGORY]) ? couponJSON[STORE_RESPONSE_COUPON_CATEGORY] : nil;
                    coupon.validTo = validTo;
                    coupon.amount = amount;
                    coupon.amountRedeemed = amountRedeemed;
                    coupon.store = store;
                    
                }
                
            }
            
        }
        
        if (storeJSON[STORE_RESPONSE_STORE_STAMP_CARDS]) {
            
            for (NSDictionary* storeStampJSON in storeJSON[STORE_RESPONSE_STORE_STAMP_CARDS]) {
                
                if (isValidJSONValue(storeStampJSON[STORE_RESPONSE_STAMP_CARD_ID])) {
                    
                    result = [context executeFetchRequest:[StampCard fetchRequestForStampCardWithId:storeStampJSON[STORE_RESPONSE_STAMP_CARD_ID]] error:&error];
                    
                    StampCard *stampCard;
                    if (result.count > 0) {
                        // coupon exists already
                        stampCard = (StampCard *) [result firstObject];
                        if (result.count > 1) {
                            // delete the rest
                        }
                    } else {
                        // insert new coupon
                        stampCard = (StampCard *) [NSEntityDescription insertNewObjectForEntityForName:@"StampCard" inManagedObjectContext:context];
                    }
                    
                    NSDate *validTo;
                    NSNumber *stamps;
                    
                    if (isValidJSONValue(storeStampJSON[STORE_RESPONSE_STAMP_CARD_VALID_TO])) {
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                        validTo = [dateFormatter dateFromString:storeStampJSON[STORE_RESPONSE_STAMP_CARD_VALID_TO]];
                        
                    }
                    
                    if (isValidJSONValue(storeStampJSON[STORE_RESPONSE_STAMP_CARD_STAMPS])) {
                        stamps = storeStampJSON[STORE_RESPONSE_STAMP_CARD_STAMPS];
                    }

                    stampCard.stampCardId = storeStampJSON[STORE_RESPONSE_STAMP_CARD_ID];
                    stampCard.title = isValidJSONValue(storeStampJSON[STORE_RESPONSE_STAMP_CARD_TITLE]) ? storeStampJSON[STORE_RESPONSE_STAMP_CARD_TITLE] : nil;
                    stampCard.stampCardDescription = isValidJSONValue(storeStampJSON[STORE_RESPONSE_STAMP_CARD_DESCRIPTION]) ? storeStampJSON[STORE_RESPONSE_STAMP_CARD_DESCRIPTION] : nil;
                    stampCard.category = isValidJSONValue(storeStampJSON[STORE_RESPONSE_STAMP_CARD_CATEGORY]) ? storeStampJSON[STORE_RESPONSE_STAMP_CARD_CATEGORY] : nil;
                    stampCard.validTo = validTo;
                    stampCard.stamps = stamps;
                    stampCard.store = store;
                    
                }
                
            }
            
        }

        
        if (storeJSON[STORE_RESPONSE_STORE_SPECIAL_OFFERS]) {
            
            for (NSDictionary* specialOfferJSON in storeJSON[STORE_RESPONSE_STORE_SPECIAL_OFFERS]) {
                
                if (isValidJSONValue(specialOfferJSON[STORE_RESPONSE_SPECIAL_OFFER_ID])) {
                    
                    result = [context executeFetchRequest:[SpecialOffer fetchRequestForSpecialOfferWithId:specialOfferJSON[STORE_RESPONSE_SPECIAL_OFFER_ID]] error:&error];
                    
                    SpecialOffer *specialOffer;
                    if (result.count > 0) {
                        // coupon exists already
                        specialOffer = (SpecialOffer *) [result firstObject];
                        if (result.count > 1) {
                            // delete the rest
                        }
                    } else {
                        // insert new coupon
                        specialOffer = (SpecialOffer *) [NSEntityDescription insertNewObjectForEntityForName:@"SpecialOffer" inManagedObjectContext:context];
                    }
                    
                    NSDate *validFrom;
                    NSDate *validTo;
                    
                    if (isValidJSONValue(specialOfferJSON[STORE_RESPONSE_SPECIAL_OFFER_VALID_TO])) {
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                        validTo = [dateFormatter dateFromString:specialOfferJSON[STORE_RESPONSE_SPECIAL_OFFER_VALID_TO]];
                        
                    }
                    
                    if (isValidJSONValue(specialOfferJSON[STORE_RESPONSE_SPECIAL_OFFER_VALID_FROM])) {
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                        validFrom = [dateFormatter dateFromString:specialOfferJSON[STORE_RESPONSE_SPECIAL_OFFER_VALID_FROM]];
                        
                    }
                    
                    specialOffer.specialOfferId = specialOfferJSON[STORE_RESPONSE_SPECIAL_OFFER_ID];
                    specialOffer.title = isValidJSONValue(specialOfferJSON[STORE_RESPONSE_SPECIAL_OFFER_TITLE]) ? specialOfferJSON[STORE_RESPONSE_SPECIAL_OFFER_TITLE] : nil;
                    specialOffer.specialOfferDescription = isValidJSONValue(specialOfferJSON[STORE_RESPONSE_SPECIAL_OFFER_DESCRIPTION]) ? specialOfferJSON[STORE_RESPONSE_SPECIAL_OFFER_DESCRIPTION] : nil;
                    specialOffer.category = isValidJSONValue(specialOfferJSON[STORE_RESPONSE_SPECIAL_OFFER_CATEGORY]) ? specialOfferJSON[STORE_RESPONSE_SPECIAL_OFFER_CATEGORY] : nil;
                    specialOffer.validTo = validTo;
                    specialOffer.validFrom = validFrom;
                    specialOffer.specialOfferShortDescription = isValidJSONValue(specialOfferJSON[STORE_RESPONSE_SPECIAL_OFFER_SHORT_DESCRIPTION]) ? specialOfferJSON[STORE_RESPONSE_SPECIAL_OFFER_SHORT_DESCRIPTION] : nil;
                    specialOffer.store = store;
                    
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
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                              ascending:YES]];

    return request;
}

+ (NSFetchRequest *)fetchRequestForStampCardsOfStoreWithId:(NSString *)storeId
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"StampCard"];
    request.predicate = [NSPredicate predicateWithFormat:@"(store.storeId = %@)", storeId];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                              ascending:YES]];
    
    return request;
}

+ (NSFetchRequest *)fetchRequestForSpecialOffersOfStoreWithId:(NSString *)storeId
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SpecialOffer"];
    request.predicate = [NSPredicate predicateWithFormat:@"(store.storeId = %@)", storeId];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title"
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

@end

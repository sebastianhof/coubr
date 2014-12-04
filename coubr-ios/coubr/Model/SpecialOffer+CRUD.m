//
//  SpecialOffer+CRUD.m
//  coubr
//
//  Created by Sebastian Hof on 08/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "SpecialOffer+CRUD.h"

#import "coubrUtil.h"
#import "coubrConstants.h"
#import "coubrDatabaseManager.h"

@implementation SpecialOffer (CRUD)

+ (NSFetchRequest *)fetchRequestForSpecialOfferWithId:(NSString *)specialOfferId
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SpecialOffer"];
    request.predicate = [NSPredicate predicateWithFormat:@"(specialOfferId = %@)", specialOfferId];
    
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

+ (void)insertSpecialOffersToStore:(Store *)store andSpecialOffersJSONs:(NSArray *)specialOffersJSONs
{
    
    NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
    
    for (NSDictionary* specialOfferJSON in specialOffersJSONs) {
        
        if (isValidJSONValue(specialOfferJSON[STORE_RESPONSE_SPECIAL_OFFER_ID])) {
            
            NSError *error;
            NSArray *result = [context executeFetchRequest:[SpecialOffer fetchRequestForSpecialOfferWithId:specialOfferJSON[STORE_RESPONSE_SPECIAL_OFFER_ID]] error:&error];
            
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

@end

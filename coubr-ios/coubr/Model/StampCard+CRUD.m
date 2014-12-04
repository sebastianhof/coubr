//
//  StampCard+CRUD.m
//  coubr
//
//  Created by Sebastian Hof on 08/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "StampCard+CRUD.h"

#import "coubrUtil.h"
#import "coubrConstants.h"
#import "coubrDatabaseManager.h"

@implementation StampCard (CRUD)

+ (NSFetchRequest *)fetchRequestForStampCardWithId:(NSString *)stampCardId
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"StampCard"];
    request.predicate = [NSPredicate predicateWithFormat:@"(stampCardId = %@)", stampCardId];
    
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

+ (void)insertStampCardsToStore:(Store *)store andStampCardsJSONs:(NSArray *)stampCardJSONs
{
    
    NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
    
    for (NSDictionary* storeStampJSON in stampCardJSONs) {
        
        if (isValidJSONValue(storeStampJSON[STORE_RESPONSE_STAMP_CARD_ID])) {
            
            NSError *error;
            NSArray *result = [context executeFetchRequest:[StampCard fetchRequestForStampCardWithId:storeStampJSON[STORE_RESPONSE_STAMP_CARD_ID]] error:&error];
            
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

            if (isValidJSONValue(storeStampJSON[STORE_RESPONSE_STAMP_CARD_VALID_TO])) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                validTo = [dateFormatter dateFromString:storeStampJSON[STORE_RESPONSE_STAMP_CARD_VALID_TO]];
            }
            
            stampCard.stampCardId = storeStampJSON[STORE_RESPONSE_STAMP_CARD_ID];
            stampCard.title = isValidJSONValue(storeStampJSON[STORE_RESPONSE_STAMP_CARD_TITLE]) ? storeStampJSON[STORE_RESPONSE_STAMP_CARD_TITLE] : nil;
            stampCard.stampCardDescription = isValidJSONValue(storeStampJSON[STORE_RESPONSE_STAMP_CARD_DESCRIPTION]) ? storeStampJSON[STORE_RESPONSE_STAMP_CARD_DESCRIPTION] : nil;
            stampCard.category = isValidJSONValue(storeStampJSON[STORE_RESPONSE_STAMP_CARD_CATEGORY]) ? storeStampJSON[STORE_RESPONSE_STAMP_CARD_CATEGORY] : nil;
            stampCard.validTo = validTo;
            stampCard.stamps = isValidJSONValue(storeStampJSON[STORE_RESPONSE_STAMP_CARD_STAMPS]) ? storeStampJSON[STORE_RESPONSE_STAMP_CARD_STAMPS]: nil;
            stampCard.store = store;
            
        }
        
    }
    
}

@end

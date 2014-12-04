//
//  StoreOpeningTime+CRUD.m
//  coubr
//
//  Created by Sebastian Hof on 22/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "StoreOpeningTime+CRUD.h"

#import "coubrUtil.h"
#import "coubrConstants.h"
#import "coubrDatabaseManager.h"

@implementation StoreOpeningTime (CRUD)

+ (void)insertStoreOpeningTimesToStore:(Store *)store andStoreOpeningTimesJSONs:(NSArray *)storeOpeningTimes
{

    NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
    
    for (NSDictionary* storeOpeningTime in storeOpeningTimes) {

            StoreOpeningTime *openingTime = [NSEntityDescription insertNewObjectForEntityForName:@"StoreOpeningTime" inManagedObjectContext:context];
        
            if (!isValidJSONValue(storeOpeningTime[STORE_RESPONSE_OPENING_TIME_WEEKDAY])) continue;
            if (!isValidJSONValue(storeOpeningTime[STORE_RESPONSE_OPENING_TIME_BEGIN_HOUR])) continue;
            if (!isValidJSONValue(storeOpeningTime[STORE_RESPONSE_OPENING_TIME_BEGIN_MINUTE])) continue;
            if (!isValidJSONValue(storeOpeningTime[STORE_RESPONSE_OPENING_TIME_END_HOUR])) continue;
            if (!isValidJSONValue(storeOpeningTime[STORE_RESPONSE_OPENING_TIME_END_MINUTE])) continue;
        
            openingTime.weekDay = storeOpeningTime[STORE_RESPONSE_OPENING_TIME_WEEKDAY];
            openingTime.beginHour = storeOpeningTime[STORE_RESPONSE_OPENING_TIME_BEGIN_HOUR];
            openingTime.beginMinute = storeOpeningTime[STORE_RESPONSE_OPENING_TIME_BEGIN_MINUTE];
            openingTime.endHour = storeOpeningTime[STORE_RESPONSE_OPENING_TIME_END_HOUR];
            openingTime.endMinute = storeOpeningTime[STORE_RESPONSE_OPENING_TIME_END_MINUTE];
            openingTime.store = store;
        
    }

}

@end

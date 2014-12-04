//
//  StoreOpeningTime+CRUD.h
//  coubr
//
//  Created by Sebastian Hof on 22/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "StoreOpeningTime.h"

@interface StoreOpeningTime (CRUD)

+ (void)insertStoreOpeningTimesToStore:(Store *)store andStoreOpeningTimesJSONs:(NSArray *)storeOpeningTimes;

@end

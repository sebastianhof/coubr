//
//  StampCard+CRUD.h
//  coubr
//
//  Created by Sebastian Hof on 08/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "StampCard.h"
#import "Store.h"

@interface StampCard (CRUD)

+ (NSFetchRequest *)fetchRequestForStampCardWithId:(NSString *)stampCardId;

+ (NSFetchRequest *)fetchRequestForStampCardsOfStoreWithId:(NSString *)storeId;

+ (void)insertStampCardsToStore:(Store *)store andStampCardsJSONs:(NSArray *)stampCardJSONs;

@end

//
//  Store+CRUD.h
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "Store.h"

@interface Store(CRUD)

+ (BOOL)insertStoreIntoDatabaseFromStoreJSON:(NSDictionary *)storeJSON;

+ (NSFetchRequest *)fetchRequestForStoreWithId:(NSString *)storeId;

+ (NSFetchRequest *)fetchRequestForCouponsOfStoreWithId:(NSString *)storeId;

+ (NSFetchRequest *)fetchRequestForStampCardsOfStoreWithId:(NSString *)storeId;

+ (NSFetchRequest *)fetchRequestForSpecialOffersOfStoreWithId:(NSString *)storeId;

+ (NSFetchRequest *)fetchRequestForFavoriteStores;

@end

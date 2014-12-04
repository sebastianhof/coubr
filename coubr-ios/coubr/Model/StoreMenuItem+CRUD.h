//
//  StoreMenuItem+CRUD.h
//  coubr
//
//  Created by Sebastian Hof on 22/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "StoreMenuItem.h"
#import "Store.h"

@interface StoreMenuItem (CRUD)

+ (NSFetchRequest *)fetchRequestForMeunItemsOfStoreWithId:(NSString *)storeId;

+ (void)insertStoreMenuItemsToStore:(Store *)store categories:(NSArray *)categories;

@end

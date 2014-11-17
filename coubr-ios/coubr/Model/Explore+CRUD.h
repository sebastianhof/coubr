//
//  Explore+CRUD.h
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "Explore.h"

@interface Explore (CRUD)

+ (BOOL)insertExploreIntoDatabaseFromExploreJSON:(NSDictionary *)exploreJSON;

+ (NSFetchRequest *)fetchRequestForExplore;

+ (NSFetchRequest *)fetchRequestForExploreWithShowSpecialOffers:(BOOL)specialOffers showStampCards:(BOOL)stampCards showCoupons:(BOOL)coupons selectedCategories:(NSSet *)selectedCategories;

+ (NSFetchRequest *)fetchRequestForExploreStoreWithId:(NSString *)storeId;

+ (NSFetchRequest *)fetchRequestForExploreCouponWithId:(NSString *)couponId;

+ (void)deleteExploreItemsInDatabase;

@end

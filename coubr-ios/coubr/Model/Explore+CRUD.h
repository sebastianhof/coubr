//
//  Explore+CRUD.h
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "Explore.h"
#import "ExploreCoupon.h"

@interface Explore (CRUD)

+ (BOOL)insertExploreIntoDatabaseFromExploreJSON:(NSDictionary *)exploreJSON;

+ (NSFetchRequest *)fetchRequestForExploreWithinDistance:(double)distance;

+ (NSFetchRequest *)fetchRequestForExploreStoreWithId:(NSString *)storeId;

+ (NSFetchRequest *)fetchRequestForExploreCouponWithId:(NSString *)couponId;

+ (void)deleteExploreItemsInDatabase;

@end

//
//  History+CRUD.h
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "History.h"
#import "Coupon.h"

@interface History (CRUD)

+ (BOOL)insertHistoryIntoDatabaseFromCoupon:(Coupon *)coupon;

+ (NSFetchRequest *)fetchRequestForHistory;

+ (NSFetchRequest *)fetchRequestForShorttermHistoryWithStore:(Store *)store;

@end

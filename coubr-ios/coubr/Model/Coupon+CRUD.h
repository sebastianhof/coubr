//
//  Coupon+CRUD.h
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "Coupon.h"

@interface Coupon (CRUD)

+ (NSFetchRequest *)fetchRequestForCouponWithId:(NSString *)couponId;

@end

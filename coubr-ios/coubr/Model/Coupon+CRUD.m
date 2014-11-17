//
//  Coupon+CRUD.m
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "Coupon+CRUD.h"
#import "coubrDatabaseManager.h"

@implementation Coupon (CRUD)

+ (NSFetchRequest *)fetchRequestForCouponWithId:(NSString *)couponId
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Coupon"];
    request.predicate = [NSPredicate predicateWithFormat:@"(couponId = %@)", couponId];
    
    return request;
}

@end

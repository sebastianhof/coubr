//
//  History.h
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Coupon, Store;

@interface History : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Store *store;
@property (nonatomic, retain) NSSet *coupons;
@end

@interface History (CoreDataGeneratedAccessors)

- (void)addCouponsObject:(Coupon *)value;
- (void)removeCouponsObject:(Coupon *)value;
- (void)addCoupons:(NSSet *)values;
- (void)removeCoupons:(NSSet *)values;

@end

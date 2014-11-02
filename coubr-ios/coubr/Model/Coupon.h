//
//  Coupon.h
//  coubr
//
//  Created by Sebastian Hof on 02/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class History, Store;

@interface Coupon : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * amountRedeemed;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * couponDescription;
@property (nonatomic, retain) NSString * couponId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * validTo;
@property (nonatomic, retain) NSSet *histories;
@property (nonatomic, retain) Store *store;
@end

@interface Coupon (CoreDataGeneratedAccessors)

- (void)addHistoriesObject:(History *)value;
- (void)removeHistoriesObject:(History *)value;
- (void)addHistories:(NSSet *)values;
- (void)removeHistories:(NSSet *)values;

@end

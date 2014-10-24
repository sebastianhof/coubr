//
//  Coupon.h
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Store;

@interface Coupon : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * amountIssued;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * couponDescription;
@property (nonatomic, retain) NSString * couponId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * validTo;
@property (nonatomic, retain) Store *store;
@property (nonatomic, retain) NSSet *histories;
@end

@interface Coupon (CoreDataGeneratedAccessors)

- (void)addHistoriesObject:(NSManagedObject *)value;
- (void)removeHistoriesObject:(NSManagedObject *)value;
- (void)addHistories:(NSSet *)values;
- (void)removeHistories:(NSSet *)values;

@end

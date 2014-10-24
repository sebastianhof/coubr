//
//  Store.h
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Coupon, History;

@interface Store : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSString * storeDescription;
@property (nonatomic, retain) NSString * storeId;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * subcategory;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSSet *coupons;
@property (nonatomic, retain) NSSet *histories;
@end

@interface Store (CoreDataGeneratedAccessors)

- (void)addCouponsObject:(Coupon *)value;
- (void)removeCouponsObject:(Coupon *)value;
- (void)addCoupons:(NSSet *)values;
- (void)removeCoupons:(NSSet *)values;

- (void)addHistoriesObject:(History *)value;
- (void)removeHistoriesObject:(History *)value;
- (void)addHistories:(NSSet *)values;
- (void)removeHistories:(NSSet *)values;

@end

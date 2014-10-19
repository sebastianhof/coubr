//
//  Explore.h
//  coubr
//
//  Created by Sebastian Hof on 16.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExploreCoupons;

@interface Explore : NSManagedObject

@property (nonatomic, retain) NSString * storeId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * subcategory;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSSet *coupons;
@end

@interface Explore (CoreDataGeneratedAccessors)

- (void)addCouponsObject:(ExploreCoupons *)value;
- (void)removeCouponsObject:(ExploreCoupons *)value;
- (void)addCoupons:(NSSet *)values;
- (void)removeCoupons:(NSSet *)values;

@end

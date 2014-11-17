//
//  History.h
//  coubr
//
//  Created by Sebastian Hof on 14/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Coupon, SpecialOffer, StampCard, Store;

@interface History : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Store *store;
@property (nonatomic, retain) NSSet *specialOffers;
@property (nonatomic, retain) NSSet *stampCards;
@property (nonatomic, retain) NSSet *coupons;
@end

@interface History (CoreDataGeneratedAccessors)

- (void)addSpecialOffersObject:(SpecialOffer *)value;
- (void)removeSpecialOffersObject:(SpecialOffer *)value;
- (void)addSpecialOffers:(NSSet *)values;
- (void)removeSpecialOffers:(NSSet *)values;

- (void)addStampCardsObject:(StampCard *)value;
- (void)removeStampCardsObject:(StampCard *)value;
- (void)addStampCards:(NSSet *)values;
- (void)removeStampCards:(NSSet *)values;

- (void)addCouponsObject:(Coupon *)value;
- (void)removeCouponsObject:(Coupon *)value;
- (void)addCoupons:(NSSet *)values;
- (void)removeCoupons:(NSSet *)values;

@end

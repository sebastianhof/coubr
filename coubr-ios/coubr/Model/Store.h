//
//  Store.h
//  coubr
//
//  Created by Sebastian Hof on 22/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Coupon, History, SpecialOffer, StampCard, StoreMenuItem, StoreOpeningTime;

@interface Store : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * isFavorite;
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
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSSet *coupons;
@property (nonatomic, retain) NSSet *histories;
@property (nonatomic, retain) NSSet *openingTimes;
@property (nonatomic, retain) NSSet *specialOffers;
@property (nonatomic, retain) NSSet *stampCards;
@property (nonatomic, retain) NSSet *menuItems;
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

- (void)addOpeningTimesObject:(StoreOpeningTime *)value;
- (void)removeOpeningTimesObject:(StoreOpeningTime *)value;
- (void)addOpeningTimes:(NSSet *)values;
- (void)removeOpeningTimes:(NSSet *)values;

- (void)addSpecialOffersObject:(SpecialOffer *)value;
- (void)removeSpecialOffersObject:(SpecialOffer *)value;
- (void)addSpecialOffers:(NSSet *)values;
- (void)removeSpecialOffers:(NSSet *)values;

- (void)addStampCardsObject:(StampCard *)value;
- (void)removeStampCardsObject:(StampCard *)value;
- (void)addStampCards:(NSSet *)values;
- (void)removeStampCards:(NSSet *)values;

- (void)addMenuItemsObject:(StoreMenuItem *)value;
- (void)removeMenuItemsObject:(StoreMenuItem *)value;
- (void)addMenuItems:(NSSet *)values;
- (void)removeMenuItems:(NSSet *)values;

@end

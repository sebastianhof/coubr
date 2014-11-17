//
//  Explore.h
//  coubr
//
//  Created by Sebastian Hof on 14/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Explore : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * coupons;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * specialOffers;
@property (nonatomic, retain) NSNumber * stampCards;
@property (nonatomic, retain) NSString * storeId;
@property (nonatomic, retain) NSString * subcategory;
@property (nonatomic, retain) NSString * type;

@end

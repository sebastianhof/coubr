//
//  ExploreCoupon.h
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Explore;

@interface ExploreCoupon : NSManagedObject

@property (nonatomic, retain) NSString * couponId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Explore *store;

@end

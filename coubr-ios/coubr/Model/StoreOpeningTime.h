//
//  StoreOpeningTime.h
//  coubr
//
//  Created by Sebastian Hof on 21/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Store;

@interface StoreOpeningTime : NSManagedObject

@property (nonatomic, retain) NSNumber * weekDay;
@property (nonatomic, retain) NSNumber * beginHour;
@property (nonatomic, retain) NSNumber * beginMinute;
@property (nonatomic, retain) NSNumber * endHour;
@property (nonatomic, retain) NSNumber * endMinute;
@property (nonatomic, retain) Store *store;

@end

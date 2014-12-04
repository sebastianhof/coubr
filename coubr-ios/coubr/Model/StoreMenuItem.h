//
//  StoreMenuItem.h
//  coubr
//
//  Created by Sebastian Hof on 22/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Store;

@interface StoreMenuItem : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) Store *store;

@end

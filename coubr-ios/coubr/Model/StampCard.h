//
//  StampCard.h
//  coubr
//
//  Created by Sebastian Hof on 14/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class History, Store;

@interface StampCard : NSManagedObject

@property (nonatomic, retain) NSNumber * stamps;
@property (nonatomic, retain) NSNumber * stampsCollected;
@property (nonatomic, retain) NSDate * validTo;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * stampCardDescription;
@property (nonatomic, retain) NSString * stampCardId;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) Store *store;
@property (nonatomic, retain) NSSet *histories;
@end

@interface StampCard (CoreDataGeneratedAccessors)

- (void)addHistoriesObject:(History *)value;
- (void)removeHistoriesObject:(History *)value;
- (void)addHistories:(NSSet *)values;
- (void)removeHistories:(NSSet *)values;

@end

//
//  SpecialOffer.h
//  coubr
//
//  Created by Sebastian Hof on 14/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class History, Store;

@interface SpecialOffer : NSManagedObject

@property (nonatomic, retain) NSString * specialOfferShortDescription;
@property (nonatomic, retain) NSDate * validFrom;
@property (nonatomic, retain) NSDate * validTo;
@property (nonatomic, retain) NSString * specialOfferDescription;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * specialOfferId;
@property (nonatomic, retain) Store *store;
@property (nonatomic, retain) NSSet *histories;
@end

@interface SpecialOffer (CoreDataGeneratedAccessors)

- (void)addHistoriesObject:(History *)value;
- (void)removeHistoriesObject:(History *)value;
- (void)addHistories:(NSSet *)values;
- (void)removeHistories:(NSSet *)values;

@end

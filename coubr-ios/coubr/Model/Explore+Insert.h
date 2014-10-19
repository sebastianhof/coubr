//
//  Explore+Insert.h
//  coubr
//
//  Created by Sebastian Hof on 16.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Explore.h"

@interface Explore (Insert)

+ (void)insertExploreItemsIntoDatabaseFromExploreJSON:(NSDictionary *)exploreJSON;

@end

//
//  Explore+Fetch.h
//  coubr
//
//  Created by Sebastian Hof on 16.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "Explore.h"

@interface Explore (Fetch)

+ (NSFetchRequest *)fetchRequestForExploreItemsWithinDistance:(double)distance;

@end

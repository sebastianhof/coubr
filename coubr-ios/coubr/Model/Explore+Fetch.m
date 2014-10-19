//
//  Explore+Fetch.m
//  coubr
//
//  Created by Sebastian Hof on 16.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import "Explore+Fetch.h"

@implementation Explore (Fetch)

+ (NSFetchRequest *)fetchRequestForExploreItemsWithinDistance:(double)distance
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Explore"];
    //request.predicate = [NSPredicate predicateWithFormat:@"(distance < %@)", [NSNumber numberWithDouble:distance]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"distance"
                                                              ascending:YES]];
    return request;
}

// [NSPredicate predicateWithFormat:@"(distance < %@) AND ((category like %@) OR (name like %@))", [NSNumber numberWithDouble:distance], searchString, searchString];

@end

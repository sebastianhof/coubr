//
//  coubrExploreMapViewAnnotation.m
//  coubr
//
//  Created by Sebastian Hof on 19/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrExploreMapViewAnnotation.h"
#import <CoreLocation/CoreLocation.h>

@implementation coubrExploreMapViewAnnotation

@synthesize category = _category;
@synthesize index = _index;
@synthesize coordinate = _coordinate;

- (instancetype)initWithCategory:(NSString *)category index:(NSInteger)index andCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        _category = category;
        _index = index;
        _coordinate = coordinate;
    }
    return self;
}

@end

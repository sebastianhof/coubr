//
//  coubrStoreMapViewAnnotation.m
//  coubr
//
//  Created by Sebastian Hof on 19/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreMapViewAnnotation.h"

@implementation coubrStoreMapViewAnnotation

@synthesize coordinate = _coordinate;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        _coordinate = coordinate;
    }
    return self;
}

@end

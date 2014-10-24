//
//  coubrMapViewAnnotation.m
//  coubr
//
//  Created by Sebastian Hof on 18/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrMapViewAnnotation.h"

@interface coubrMapViewAnnotation ()

@property (strong, nonatomic) NSString *annotationTitle;
@property (strong, nonatomic) NSString *annotationDescription;
@property (nonatomic) CLLocationCoordinate2D annotationCoordinate;

@end

@implementation coubrMapViewAnnotation 

@synthesize coordinate;

- (NSString *)title
{
    return _annotationTitle;
}

- (NSString *)description
{
    return _annotationDescription;
}

- (CLLocationCoordinate2D)coordinate
{
    return _annotationCoordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _annotationCoordinate = newCoordinate;
}

- (instancetype)initWithTitle:(NSString *)title description:(NSString *)description andCoordinate:(CLLocationCoordinate2D)locationCoordinate
{
    self = [super init];
    
    if (self) {
        _annotationTitle = title;
        _annotationDescription = description;
        _annotationCoordinate = locationCoordinate;
    }
    
    return self;
}


@end

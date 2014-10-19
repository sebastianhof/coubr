//
//  coubrMapViewAnnotation.h
//  coubr
//
//  Created by Sebastian Hof on 18/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface coubrMapViewAnnotation : NSObject <MKAnnotation>

- (instancetype)initWithTitle:(NSString *)title description:(NSString *)description andCoordinate:(CLLocationCoordinate2D)location;

@end

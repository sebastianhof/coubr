//
//  coubrStoreMapViewAnnotation.h
//  coubr
//
//  Created by Sebastian Hof on 19/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface coubrStoreMapViewAnnotation : NSObject <MKAnnotation>

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end

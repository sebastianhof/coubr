//
//  coubrExploreMapViewAnnotation.h
//  coubr
//
//  Created by Sebastian Hof on 19/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface coubrExploreMapViewAnnotation : NSObject <MKAnnotation>

- (instancetype)initWithCategory:(NSString *)category index:(NSInteger)index andCoordinate:(CLLocationCoordinate2D)coordinate;

@property (strong, nonatomic, readonly) NSString *category;
@property (nonatomic, readonly) NSInteger index;

@end

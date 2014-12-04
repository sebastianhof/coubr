//
//  coubrExploreMapViewController.h
//  coubr
//
//  Created by Sebastian Hof on 15.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "coubrExploreViewController.h"

@interface coubrExploreMapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) coubrExploreViewController *parentController;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *userLocationButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (void)updateLocationLabelWithLocation:(CLLocation *)location;

- (void)showMapViewInFullscreen:(BOOL)show;

- (void)selectAnnotationAtIndex:(NSInteger)index;

@end

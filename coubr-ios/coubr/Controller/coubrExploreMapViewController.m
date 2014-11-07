//
//  coubrExploreMapViewController.m
//  coubr
//
//  Created by Sebastian Hof on 15.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrExploreMapViewController.h"
#import "coubrLocationManager.h"

#import "coubrMapViewAnnotation.h"
#import "coubrConstants.h"

#import "Explore.h"

@interface coubrExploreMapViewController ()



@end

@implementation coubrExploreMapViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:FetchedResultsControllerDidUpdatedNotification object:self.parentController queue:nil usingBlock:^(NSNotification *note) {
        [self addAnnotations];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:UserLocationDidBecomeAvailableNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self updateMapViewToLocation:[[coubrLocationManager defaultManager] userLocation]];
        [self updateLocationLabelWithLocation:[[coubrLocationManager defaultManager] userLocation]];
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUserLocationButton];
}

- (void)initUserLocationButton
{

}

#pragma mark - Init

- (void)updateMapViewToLocation:(CLLocation *)location
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, EXPLORE_DEFAULT_DISTANCE * 2, EXPLORE_DEFAULT_DISTANCE *2);
    [self.mapView setRegion:region animated:NO];
}

- (void)updateLocationLabelWithLocation:(CLLocation *)location
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks firstObject];
            [self.locationLabel setText:placemark.locality];
        }
        
    }];
}

#define PIN_REUSE_IDENTIFIER = @"Pin"

- (void)addAnnotations
{    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    for (NSObject *managedObject in [self.parentController.fetchedResultsController fetchedObjects]) {
        
        if ([managedObject isKindOfClass:[Explore class]]) {
            
            Explore *explore = (Explore *) managedObject;
   
            coubrMapViewAnnotation *annotation = [[coubrMapViewAnnotation alloc]
                                                   initWithTitle:explore.name
                                                   description:nil
                                                   andCoordinate: CLLocationCoordinate2DMake([explore.latitude doubleValue], [explore.longitude doubleValue])];
            [annotations addObject:annotation];
        }
        
    };
    if (annotations.count > 0) {
        [self.mapView addAnnotations:annotations];
    }
     
}

#pragma mark - MapView

- (IBAction)centerMapToUserLocation:(id)sender {
    
    [self.mapView setCenterCoordinate:[coubrLocationManager defaultManager].userLocation.coordinate];
}

#pragma mark - Annotation View

static NSString* DEFAULT_ANNOTATION_VIEW_IDENTIFIER = @"DefaultAnnotationViewIdentifer";

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:DEFAULT_ANNOTATION_VIEW_IDENTIFIER];
    
    if (!annotationView) {
        
        annotationView = [[MKAnnotationView alloc] init];
        
        
        if ([annotation isKindOfClass:[coubrMapViewAnnotation class]]) {
            
            // TODO
            
            
            
        }
        
    }
    
    return annotationView;
    
}


@end

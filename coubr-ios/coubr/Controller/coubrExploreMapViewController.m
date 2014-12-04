//
//  coubrExploreMapViewController.m
//  coubr
//
//  Created by Sebastian Hof on 15.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrExploreMapViewController.h"
#import "coubrLocationManager.h"

#import "coubrExploreMapViewAnnotation.h"

#import "coubrConstants.h"
#import "coubrCategoryToImage.h"

#import "UIImage+Overlay.h"

#import "Explore.h"

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
    [self.userLocationButton setImage:[[UIImage imageNamed:@"Map_View_Location"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [self.userLocationButton.layer setCornerRadius:20.0];
    [self.userLocationButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.userLocationButton.layer setBorderWidth:2.0];
}

#pragma mark - Location

- (void)updateMapViewToLocation:(CLLocation *)location
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, EXPLORE_DEFAULT_DISTANCE * 2, EXPLORE_DEFAULT_DISTANCE *2);
    [self.mapView setRegion:region animated:NO];
}

- (IBAction)centerMapToUserLocation:(id)sender {
    [self.mapView setCenterCoordinate:[self.mapView userLocation].coordinate];
}

- (void)showMapViewInFullscreen:(BOOL)show
{
    if (show) {
        self.mapView.showsUserLocation = YES;
        [self addAnnotations];
    } else {
        self.mapView.showsUserLocation = NO;
    }
}

#pragma mark - Label

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

#pragma mark - Annotation View

static NSString* DEFAULT_ANNOTATION_VIEW_IDENTIFIER = @"DefaultAnnotationViewIdentifer";

- (void)selectAnnotationAtIndex:(NSInteger)index
{
    for (NSObject *annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[coubrExploreMapViewAnnotation class]]) {
            
            coubrExploreMapViewAnnotation *mapViewAnnotation = (coubrExploreMapViewAnnotation *)annotation;
            
            if (index == mapViewAnnotation.index) {
                [self.mapView selectAnnotation:mapViewAnnotation animated:YES];
                
                // change map region
                CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
                CLLocation *storeLocation = [[CLLocation alloc] initWithLatitude:mapViewAnnotation.coordinate.latitude longitude:mapViewAnnotation.coordinate.longitude];
                CLLocationDistance distance = [centerLocation distanceFromLocation:storeLocation];
                [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.mapView.centerCoordinate, distance * 2.2, distance * 2.2) animated:YES];
                
                
                
                break;
            }
            
        }
    }
    
    
}

- (void)addAnnotations
{
    [self removeAnnotations];
    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < [self.parentController.fetchedResultsController fetchedObjects].count; i++) {
         
        NSObject *managedObject = [self.parentController.fetchedResultsController.fetchedObjects objectAtIndex:i];
        
        if ([managedObject isKindOfClass:[Explore class]]) {
            
            Explore *explore = (Explore *) managedObject;
            
            coubrExploreMapViewAnnotation *annotation = [[coubrExploreMapViewAnnotation alloc]
                                                  initWithCategory:explore.category index:i
                                                  andCoordinate: CLLocationCoordinate2DMake([explore.latitude doubleValue], [explore.longitude doubleValue])];
            [annotations addObject:annotation];
        }
        
    };
    
    if (annotations.count > 0) {
        [self.mapView addAnnotations:annotations];
    }
    
}

- (void)removeAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
}

#define MAP_VIEW_ANNOTATION_IDENTIFIER @"MapViewAnnotationIdentifier"

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[coubrExploreMapViewAnnotation class]]) {
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:MAP_VIEW_ANNOTATION_IDENTIFIER];
        
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MAP_VIEW_ANNOTATION_IDENTIFIER];
        }

        UIImage *image = [[UIImage imageNamed:@"Explore_Map_View_Location"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [annotationView setImage:[image imageWithColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]]];
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[coubrExploreMapViewAnnotation class]]) {
        UIImage *image = [[UIImage imageNamed:@"Explore_Map_View_Location"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [view setImage:[image imageWithColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]]];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[coubrExploreMapViewAnnotation class]]) {
        UIImage *image = [[UIImage imageNamed:@"Explore_Map_View_Location"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [view setImage:[image imageWithColor:[UIColor colorWithRed:242.0/255.0 green:120.0/255.0 blue:75.0/255.0 alpha:1]]];
        [self.parentController setSelectedStoreToIndex:((coubrExploreMapViewAnnotation *) view.annotation).index];
    }
    
    
}


@end

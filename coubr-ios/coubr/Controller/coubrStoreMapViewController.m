//
//  coubrStoreMapViewController.m
//  coubr
//
//  Created by Sebastian Hof on 21/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreMapViewController.h"
#import "coubrLocationManager.h"
#import "coubrStoreMapViewAnnotation.h"

#import "UIImage+Overlay.h"

@interface coubrStoreMapViewController ()



@property (weak, nonatomic) Store *store;

@end

@implementation coubrStoreMapViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:StoreDidBecomeAvailableNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        self.store = note.userInfo[STORE];
        [self initStoreMap];
        
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUserLocationButton];
}

#define DEFAULT_DISTANCE 200.0
#define STORE_DISTANCE_ADDITION 100.0
#define STORE_ANNOTATION_IDENTIFIER @"StoreAnnotation";

- (void)initUserLocationButton
{
    [self.locationButton setImage:[[UIImage imageNamed:@"Map_View_Location"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [self.locationButton.layer setCornerRadius:20.0];
    [self.locationButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.locationButton.layer setBorderWidth:2.0];
}

- (void)initStoreMap
{
    if (self.storeMapView.overlays.count > 0) {
        [self.storeMapView removeOverlays:self.storeMapView.overlays];
    }
    
    if (self.storeMapView.annotations.count > 0) {
        [self.storeMapView removeAnnotations:self.storeMapView.annotations];
    }
    
    double latitude = latitude = [self.store.latitude doubleValue];
    double longitude = [self.store.longitude doubleValue];
    
    CLLocation *storeLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocation *currentLocation = [[coubrLocationManager defaultManager] userLocation];
    CLLocationDistance distance = [storeLocation distanceFromLocation:currentLocation];
    
    // set annotation
    coubrStoreMapViewAnnotation *storeAnnotation = [[coubrStoreMapViewAnnotation alloc] initWithCoordinate:storeLocation.coordinate];
    [self.storeMapView addAnnotation:storeAnnotation];
    
    // set region
    [self.storeMapView setRegion:MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, distance * 2.2, distance * 2.2)];
    
    // setup navigation
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:storeLocation.coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];

    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:[MKMapItem mapItemForCurrentLocation]];
    [request setDestination:mapItem];
    [request setTransportType:MKDirectionsTransportTypeWalking];
    [request setRequestsAlternateRoutes:YES];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"Could not calculate directions: %@", [error localizedDescription]);
        } else {
            
            for (MKRoute *route in [response routes]) {
                [self.storeMapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads];
            }
            
        }
        
    }];


      
}

#pragma mark - Location

- (IBAction)centerMapToUserLocation:(id)sender {
    [self.storeMapView setCenterCoordinate:[self.storeMapView userLocation].coordinate];
}


- (void)showMapViewInFullscreen:(BOOL)show
{
    if (show) {
        self.storeMapView.showsUserLocation = YES;
        [self initStoreMap];
        [self.locationButton setAlpha:1];
    } else {
        self.storeMapView.showsUserLocation = NO;
        [self.locationButton setAlpha:0];
    }
}

#pragma mark - Annotation

#define MAP_VIEW_ANNOTATION_IDENTIFIER @"MapViewAnnotationIdentifier"

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([self.storeMapView.annotations containsObject:annotation]) {
        if ([annotation isKindOfClass:[coubrStoreMapViewAnnotation class]]) {
            MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:MAP_VIEW_ANNOTATION_IDENTIFIER];
            
            if (!annotationView) {
                annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MAP_VIEW_ANNOTATION_IDENTIFIER];
            }
            
            UIImage *image = [[UIImage imageNamed:@"Explore_Map_View_Location"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [annotationView setImage:[image imageWithColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]]];
            return annotationView;
        }
    }
    return nil;
}

#pragma mark - Polyline

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([self.storeMapView.overlays containsObject:overlay]) {
        if ([overlay isKindOfClass:[MKPolyline class]]) {
            MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
            renderer.strokeColor = [[UIColor orangeColor] colorWithAlphaComponent:0.7];
            renderer.lineWidth = 3.0;
            return  renderer;
        }
    }
    return nil;
}



@end

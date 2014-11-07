//
//  coubrStoreMapViewController.m
//  coubr
//
//  Created by Sebastian Hof on 21/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreMapViewController.h"
#import "coubrDatabaseManager.h"
#import "coubrLocationManager.h"

@interface coubrStoreMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *storeMapView;

@end

@implementation coubrStoreMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self storeLocationDidBecomeAvailable];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#define DEFAULT_DISTANCE 200.0
#define STORE_DISTANCE_ADDITION 100.0
#define STORE_ANNOTATION_IDENTIFIER @"StoreAnnotation";

- (void)storeLocationDidBecomeAvailable
{
    
    if (self.parentController.store) {
        
        __block NSString *name;
        __block double latitude;
        __block double longitude;
        
        [[[coubrDatabaseManager defaultManager] managedObjectContext] performBlockAndWait:^{
            
            latitude = [self.parentController.store.latitude doubleValue] ;
            longitude = [self.parentController.store.longitude doubleValue];
            name = [NSString stringWithString:self.parentController.store.name];
            
        }];
        
        CLLocation *storeLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        CLLocation *currentLocation = [[coubrLocationManager defaultManager] userLocation];
        CLLocationDistance distance = [storeLocation distanceFromLocation:currentLocation];
        
        // set annotation
        MKPointAnnotation *storeAnnotation = [[MKPointAnnotation alloc] init];
        [self.storeMapView addAnnotation:storeAnnotation];
        [storeAnnotation setCoordinate:storeLocation.coordinate];
        [storeAnnotation setTitle:name];
        
        // set region
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate,distance, distance);
        region = [self.storeMapView regionThatFits:region];
        [self.storeMapView setRegion:region];
        
        // show user location
        self.storeMapView.showsUserLocation = YES;
        
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
      
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        renderer.strokeColor = [[UIColor orangeColor] colorWithAlphaComponent:0.7];
        renderer.lineWidth = 3.0;
        return  renderer;
    }
    return nil;
}

- (IBAction)centerMapToUserLocation:(id)sender {
    
    [self.storeMapView setCenterCoordinate:[coubrLocationManager defaultManager].userLocation.coordinate];
}

@end

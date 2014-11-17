//
//  coubrStoreMapViewController.m
//  coubr
//
//  Created by Sebastian Hof on 21/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreMapViewController.h"
#import "coubrLocationManager.h"

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
    
    if (self.store) {
        [self initStoreMap];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.storeMapView.showsUserLocation = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.storeMapView.showsUserLocation = NO;
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

    NSString *name = [NSString stringWithString:self.store.name];
    double latitude = latitude = [self.store.latitude doubleValue];
    double longitude = [self.store.longitude doubleValue];
    
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

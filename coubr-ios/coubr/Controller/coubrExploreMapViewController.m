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

@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

@implementation coubrExploreMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:FetchedResultsControllerDidUpdatedNotification object:self.parentController queue:nil usingBlock:^(NSNotification *note) {
        // Update Map
        
        [self updateMapView];
        [self addAnnotations];
        
    }];
    
}

#pragma mark - Init

- (void)updateMapView
{
    
    CLLocationCoordinate2D coordinate = [[coubrLocationManager defaultManager] lastLocation].coordinate;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, EXPLORE_DEFAULT_DISTANCE * 2, EXPLORE_DEFAULT_DISTANCE * 2);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
    [self.mapView setRegion:adjustedRegion animated:YES];
    self.mapView.showsUserLocation = YES;
    
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
                                                   description:@"Description"
                                                   andCoordinate: CLLocationCoordinate2DMake([explore.latitude doubleValue], [explore.longitude doubleValue])];
            [annotations addObject:annotation];
        }
        
    };
    if (annotations.count > 0) {
        [self.mapView addAnnotations:annotations];
    }
     
}

#pragma mark - MapView



- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    
    
}


//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view

#pragma mark - Annotation Pin View




@end

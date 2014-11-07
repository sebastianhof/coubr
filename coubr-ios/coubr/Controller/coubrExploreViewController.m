//
//  coubrExploreViewController.m
//  coubr
//
//  Created by Sebastian Hof on 15.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "coubrExploreViewController.h"

#import "coubrDatabaseManager.h"

#import "coubrConstants.h"
#import "coubrRemoteManager+Explore.h"

#import "Explore+CRUD.h"

#import "coubrExploreMapViewController.h"
#import "coubrExploreTableViewController.h"

#import "coubrExploreFilterViewController.h"

#import "UIImage+ImageEffects.h"

#import "coubrLocationManager.h"

@interface coubrExploreViewController ()

@property (strong, nonatomic) coubrExploreMapViewController *exploreMapViewController;
@property (strong, nonatomic) coubrExploreTableViewController *exploreTableViewController;

@property (weak, nonatomic) UIView *exploreMapView;
@property (weak, nonatomic) UIView *exploreTableView;
@property (strong, nonatomic) UIView *overlayView;

@property (strong, nonatomic) UIPanGestureRecognizer *overlayPanGestureRecognizer;
@property (strong, nonatomic) UIDynamicAnimator *animator;

@property (nonatomic) BOOL notInit;

@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation coubrExploreViewController

#pragma mark - view lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // setup notification listener
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ManagedDatabaseDidBecomeAvailableNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Explore fetchRequestForExploreWithinDistance:EXPLORE_DEFAULT_DISTANCE] managedObjectContext:[[coubrDatabaseManager defaultManager] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        
        // refresh
        [self updateFetchedResultsController];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UserLocationDidBecomeAvailableNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.currentLocation = [[coubrLocationManager defaultManager] userLocation];
        [self updateFetchedResultsController];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[coubrLocationManager defaultManager] updateUserLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.notInit) {
        [self initView];
    }
    
}

#pragma mark - init controllers

- (coubrExploreMapViewController *)exploreMapViewController
{
    if (!_exploreMapViewController) {
        _exploreMapViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"coubrExploreMapViewController"];
        [self addChildViewController:_exploreMapViewController];
        [_exploreMapViewController setParentController:self];
    }
    return _exploreMapViewController;
}

- (coubrExploreTableViewController *)exploreTableViewController
{
    if (!_exploreTableViewController) {
        _exploreTableViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"coubrExploreTableViewController"];
        [self addChildViewController:_exploreTableViewController];
        [_exploreTableViewController setParentController:self];
    }
    return _exploreTableViewController;
}

#pragma mark - init views

#define HEADER_HEIGHT 99.0

- (void)initView
{
    [self.view addSubview:self.exploreMapView];
    [self.view addSubview:self.exploreTableView];
    [self.view addSubview:self.overlayView];
    
    // collision animation
    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.exploreTableView,self.exploreTableView]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collisionBehavior];

    // elasticity animation
    UIDynamicItemBehavior *elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.exploreTableView,self.exploreTableView]];
    elasticityBehavior.elasticity = 0.7;
    elasticityBehavior.friction = 0.7;
    [self.animator addBehavior:elasticityBehavior];
    
    self.notInit = YES;
}

- (UIView *)exploreMapView
{
    if (!_exploreMapView) {
        _exploreMapView = self.exploreMapViewController.view;
        
        CGRect superviewFrame = self.view.frame;
        
        CGRect frame = _exploreMapView.frame;
        frame.size.width = superviewFrame.size.width;
        frame.size.height = HEADER_HEIGHT;
        frame.origin.y = 0;
        frame.origin.x = 0;
        [_exploreMapView setFrame:frame];

    }
    return _exploreMapView;
}

- (UIView *)exploreTableView
{
    if (!_exploreTableView) {
        _exploreTableView  = self.exploreTableViewController.view;
        
        CGRect superviewFrame = self.view.frame;

        CGRect frame = _exploreTableView.frame;
        frame.size.width = superviewFrame.size.width;
        frame.size.height = superviewFrame.size.height - HEADER_HEIGHT;
        frame.origin.y = HEADER_HEIGHT;
        frame.origin.x = 0;
        [_exploreTableView setFrame:frame];

    }
    return _exploreTableView;
}

- (UIView *)overlayView
{
    if (!_overlayView) {
        CGRect superviewFrame = self.view.frame;
        CGRect frame = CGRectMake(0, 0, superviewFrame.size.width, HEADER_HEIGHT);
        _overlayView = [[UIView alloc] initWithFrame:frame];
        [_overlayView addGestureRecognizer:self.overlayPanGestureRecognizer];
    }
    return _overlayView;
}

#pragma mark - update FetchedResultsController

- (void)updateFetchedResultsController
{
    
    // Load data from remote
    if (self.currentLocation && [[coubrDatabaseManager defaultManager] managedObjectContext]) {
        
        // wipe database before loading
        [Explore deleteExploreItemsInDatabase];
        
        CLLocationCoordinate2D coordinate = self.currentLocation.coordinate;
        
        [[coubrRemoteManager defaultManager] loadExploreJSONAtLatitude:coordinate.latitude longitude:coordinate.longitude distance:10000 completionHandler:^(NSDictionary *JSONData) {
            
            // Update Database with JSON Explore Data
            
            [Explore insertExploreIntoDatabaseFromExploreJSON:JSONData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ConnectionDidBecomeAvailableNotification object:self];
            
            // Update FetchedResultsController
            NSError *error;
            [self.fetchedResultsController performFetch:&error];

            if (!error) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:FetchedResultsControllerDidUpdatedNotification object:self];
            }
            
        } errorHandler:^(NSInteger errorCode) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ConnectionDidFailNotification object:self];
            
            NSLog(@"Could not load data: %li", errorCode);

        }];
        
    }
    
}

#pragma mark - Map View

- (void)updateCurrentLocationFromMapViewCenter
{
    CLLocationCoordinate2D coordinate = [self.exploreMapViewController.mapView centerCoordinate];
    self.currentLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self.exploreMapViewController updateLocationLabelWithLocation:self.currentLocation];
}

#pragma mark - Overlay

- (UIPanGestureRecognizer *)overlayPanGestureRecognizer
{
    if (!_overlayPanGestureRecognizer) {
        _overlayPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOverlay:)];
    }
    return _overlayPanGestureRecognizer;
}

- (void)panOverlay:(UIPanGestureRecognizer *)gesture
{
    static CGPoint originalPoint;
    
    CGPoint translatedPoint = [gesture translationInView:self.view];
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        originalPoint = gesture.view.center;
        [self userDidStartPanningAtLocation:originalPoint];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint currentPoint = CGPointMake(originalPoint.x + translatedPoint.x, originalPoint.y + translatedPoint.y);
        [self userIsPanningFromLocation:originalPoint toLocation:currentPoint withTranslation:translatedPoint];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
    {
        CGPoint destination = CGPointMake(originalPoint.x + translatedPoint.x, originalPoint.y + translatedPoint.y);
        [self userDidFinishPanningFromLocation:originalPoint toLocation:destination];
    }
}

- (void)userDidStartPanningAtLocation:(CGPoint)location
{
    CGRect superviewFrame = self.view.frame;
    if (location.y > superviewFrame.size.height * 0.5) {
        [self.exploreMapViewController.locationLabel setText:@""];
        [self updateCurrentLocationFromMapViewCenter];
    }
}

- (void)userIsPanningFromLocation:(CGPoint)origin toLocation:(CGPoint)destination withTranslation:(CGPoint)translation
{
    CGRect superviewFrame = self.view.frame;
    
    if (translation.y > 0) {
        // move down
        
        if (origin.y < superviewFrame.size.height * 0.5 && destination.y < (superviewFrame.size.height - HEADER_HEIGHT)) {
            // shows map view
            [self.overlayView setFrame:CGRectMake(0, 0, superviewFrame.size.width, HEADER_HEIGHT + translation.y)];
            [self.exploreMapView setFrame:CGRectMake(0, 0, superviewFrame.size.width, HEADER_HEIGHT + translation.y)];
            [self.exploreTableView setFrame:CGRectMake(0, HEADER_HEIGHT + translation.y, superviewFrame.size.width, superviewFrame.size.height - HEADER_HEIGHT)];
        }
  
    } else {
        // move up
        
        if (origin.y >= superviewFrame.size.height * 0.5 && destination.y > HEADER_HEIGHT) {
            // shows table view
            [self.overlayView setFrame:CGRectMake(0, superviewFrame.size.height - HEADER_HEIGHT + translation.y, superviewFrame.size.width, HEADER_HEIGHT - translation.y)];
            [self.exploreMapView setFrame:CGRectMake(0, 0, superviewFrame.size.width, superviewFrame.size.height - HEADER_HEIGHT + translation.y)];
            [self.exploreTableView setFrame:CGRectMake(0, superviewFrame.size.height - HEADER_HEIGHT + translation.y, superviewFrame.size.width, superviewFrame.size.height - HEADER_HEIGHT)];
        }
        
    }
    
    if (destination.y < HEADER_HEIGHT) {
        [self.exploreMapViewController.userLocationButton setAlpha:0];
        [self.exploreMapViewController.locationLabel setAlpha:1];
    } else if (destination.y > (superviewFrame.size.height - HEADER_HEIGHT)) {
        [self.exploreMapViewController.userLocationButton setAlpha:1];
        [self.exploreMapViewController.locationLabel setAlpha:0];
    } else {
        [self.exploreMapViewController.userLocationButton setAlpha:destination.y / (superviewFrame.size.height - HEADER_HEIGHT)];
        [self.exploreMapViewController.locationLabel setAlpha:1 - (destination.y / (superviewFrame.size.height - HEADER_HEIGHT))];
    }
    
}

- (void)userDidFinishPanningFromLocation:(CGPoint)origin toLocation:(CGPoint)destination
{
    CGRect superviewFrame = self.view.frame;
    if (destination.y < superviewFrame.size.height * 0.5) {
        // shows table view
        
        // moved from bottom to top
        // moved from top to top
        [self.overlayView setFrame:CGRectMake(0, 0, superviewFrame.size.width, HEADER_HEIGHT)];
        [self.exploreMapView setFrame:CGRectMake(0, 0, superviewFrame.size.width, HEADER_HEIGHT)];
        [self.exploreTableView setFrame:CGRectMake(0, HEADER_HEIGHT, superviewFrame.size.width, superviewFrame.size.height - HEADER_HEIGHT) ];

        [self.exploreMapViewController.locationLabel setAlpha:1];
        [self.exploreMapViewController.userLocationButton setAlpha:0];
        
        // refresh location
        if (origin.y > superviewFrame.size.height * 0.5) {
            // moved from button to top therefore closes
            [self updateFetchedResultsController];
        }
        
        
    } else {
        // shows map view
        
        // moved from top to bottom
        // moved from bottom to bottom
        [self.overlayView setFrame:CGRectMake(0, superviewFrame.size.height - HEADER_HEIGHT, superviewFrame.size.width, HEADER_HEIGHT)];
        [self.exploreMapView setFrame:CGRectMake(0, 0, superviewFrame.size.width, superviewFrame.size.height - HEADER_HEIGHT)];
        [self.exploreTableView setFrame:CGRectMake(0, superviewFrame.size.height - HEADER_HEIGHT, superviewFrame.size.width, superviewFrame.size.height - HEADER_HEIGHT)];
        
        [self.exploreMapViewController.userLocationButton setAlpha:1];
        [self.exploreMapViewController.locationLabel setAlpha:0];
        
         
    }
 
}

#pragma mark - Animation

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

@end

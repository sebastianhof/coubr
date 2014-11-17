//
//  coubrExploreViewController.m
//  coubr
//
//  Created by Sebastian Hof on 15.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

#import "coubrExploreViewController.h"

#import "coubrDatabaseManager.h"

#import "coubrConstants.h"
#import "coubrLocale.h"
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
@property (strong, nonatomic) coubrExploreFilterViewController *exploreFilterViewController;

@property (weak, nonatomic) UIView *exploreMapView;
@property (weak, nonatomic) UIView *exploreTableView;
@property (strong, nonatomic) UIView *overlayView;
@property (weak, nonatomic) UIView *exploreFilterView;

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) NSMutableArray *searchLocationResults; // of MKPlacemark

@property (strong, nonatomic) UIBarButtonItem *searchBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *filterBarButtonItem;


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
    
    self.exploreMapViewController;
    self.exploreTableViewController;
    self.exploreFilterViewController;
    
    // setup notification listener
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ManagedDatabaseDidBecomeAvailableNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Explore fetchRequestForExplore] managedObjectContext:[[coubrDatabaseManager defaultManager] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        
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
    
    [self initNavigationBar];
}

#pragma mark - Init

- (UIBarButtonItem *)filterBarButtonItem
{
    if (!_filterBarButtonItem) {
        _filterBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Nav_Bar_Filter"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]  style:UIBarButtonItemStylePlain target:self action:@selector(toggleFilter:)];
    }
    return _filterBarButtonItem;
}

- (UIBarButtonItem *)searchBarButtonItem
{
    if (!_searchBarButtonItem) {
        _searchBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Nav_Bar_Search"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]  style:UIBarButtonItemStylePlain target:self action:@selector(toggleSearch:)];
    }
    return _searchBarButtonItem;
}

- (void)initNavigationBar
{
    [self.parentViewController.navigationItem setRightBarButtonItems:@[ self.searchBarButtonItem, self.filterBarButtonItem ] animated:NO];
}

#pragma mark - Init controllers

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

- (coubrExploreFilterViewController *)exploreFilterViewController
{
    if (!_exploreFilterViewController) {
        _exploreFilterViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"coubrExploreFilterViewController"];
        [self addChildViewController:_exploreFilterViewController];
        [_exploreFilterViewController setParentController:self];
    }
    return _exploreFilterViewController;
}

#pragma mark - Init views

#define HEADER_HEIGHT 99.0
#define TOPBAR_HEIGHT 64.0
#define BOTTOMBAR_HEIGHT 50.0

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
        CGRect frame = CGRectMake(0, TOPBAR_HEIGHT, superviewFrame.size.width, HEADER_HEIGHT);
        [_exploreMapView setFrame:frame];

    }
    return _exploreMapView;
}

- (UIView *)overlayView
{
    if (!_overlayView) {
        CGRect superviewFrame = self.view.frame;
        CGRect frame = CGRectMake(0, TOPBAR_HEIGHT, superviewFrame.size.width, HEADER_HEIGHT);
        
        _overlayView = [[UIView alloc] initWithFrame:frame];
        [_overlayView addGestureRecognizer:self.overlayPanGestureRecognizer];
    }
    return _overlayView;
}

- (UIView *)exploreTableView
{
    if (!_exploreTableView) {
        _exploreTableView  = self.exploreTableViewController.view;
        
        CGRect superviewFrame = self.view.frame;
        CGRect frame = CGRectMake(0, HEADER_HEIGHT + TOPBAR_HEIGHT, superviewFrame.size.width, superviewFrame.size.height - HEADER_HEIGHT - TOPBAR_HEIGHT);
        [_exploreTableView setFrame:frame];

    }
    return _exploreTableView;
}

- (UIView *)exploreFilterView
{
    if (!_exploreFilterView) {
        _exploreFilterView  = self.exploreFilterViewController.view;
        
        CGRect superviewFrame = self.view.frame;
        CGRect frame = CGRectMake(0, TOPBAR_HEIGHT, superviewFrame.size.width, superviewFrame.size.height - TOPBAR_HEIGHT);
        [_exploreFilterView setFrame:frame];
        
    }
    return _exploreFilterView;
}

#pragma mark - update FetchedResultsController

- (void)updateFetchedResultsControllerRequest
{
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:
                                     
                                     [Explore fetchRequestForExploreWithShowSpecialOffers:self.exploreFilterViewController.showSpecialOffers
                                                                    showStampCards:self.exploreFilterViewController.showStampCards
                                                                       showCoupons:self.exploreFilterViewController.showCoupons
                                                                       selectedCategories:self.exploreFilterViewController.selectedCategories]
                                     
                                                                        managedObjectContext:[[coubrDatabaseManager defaultManager] managedObjectContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    
    if (!error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:FetchedResultsControllerDidUpdatedNotification object:self];
    }
}

- (void)updateFetchedResultsController
{
    
    // Load data from remote
    if (self.currentLocation && [[coubrDatabaseManager defaultManager] managedObjectContext]) {
        
        // wipe database before loading
        [Explore deleteExploreItemsInDatabase];
        
        CLLocationCoordinate2D coordinate = self.currentLocation.coordinate;
        
        [[coubrRemoteManager defaultManager] loadExploreJSONAtLatitude:coordinate.latitude longitude:coordinate.longitude distance:[self.exploreFilterViewController currentDistance] completionHandler:^(NSDictionary *JSONData) {
            
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
    if (location.y > (superviewFrame.size.height * 0.5 + TOPBAR_HEIGHT)) {
        [self.exploreMapViewController.locationLabel setText:@""];
        [self updateCurrentLocationFromMapViewCenter];
    }
}

- (void)userIsPanningFromLocation:(CGPoint)origin toLocation:(CGPoint)destination withTranslation:(CGPoint)translation
{
    CGRect superviewFrame = self.view.frame;
    
    if (translation.y > 0) {
        // move down
        
        if (origin.y < (superviewFrame.size.height * 0.5 + TOPBAR_HEIGHT) && destination.y < (superviewFrame.size.height - HEADER_HEIGHT)) {
            // shows map view
            [self.exploreMapView setFrame:CGRectMake(0, TOPBAR_HEIGHT, self.exploreMapView.bounds.size.width, HEADER_HEIGHT + TOPBAR_HEIGHT + translation.y)];
            [self.overlayView setFrame:CGRectMake(0, TOPBAR_HEIGHT, self.overlayView.bounds.size.width, HEADER_HEIGHT + TOPBAR_HEIGHT + translation.y)];
            [self.exploreTableView setFrame:CGRectMake(0, TOPBAR_HEIGHT + HEADER_HEIGHT + translation.y, self.exploreTableView.bounds.size.width, self.exploreTableView.bounds.size.height)];
        }
  
    } else {
        // move up
        
        if (origin.y >= (superviewFrame.size.height * 0.5 + TOPBAR_HEIGHT) && destination.y > (HEADER_HEIGHT + TOPBAR_HEIGHT)) {
            // shows table view
            [self.exploreMapView setFrame:CGRectMake(0, TOPBAR_HEIGHT, self.exploreMapView.bounds.size.width, superviewFrame.size.height - HEADER_HEIGHT - TOPBAR_HEIGHT + translation.y)];
            [self.overlayView setFrame:CGRectMake(0, superviewFrame.size.height - HEADER_HEIGHT + translation.y, self.overlayView.bounds.size.width, HEADER_HEIGHT - translation.y )];
            [self.exploreTableView setFrame:CGRectMake(0, superviewFrame.size.height - HEADER_HEIGHT + translation.y, self.exploreTableView.bounds.size.width, self.exploreTableView.bounds.size.height)];
        }
        
    }
    
    if (destination.y < (HEADER_HEIGHT + TOPBAR_HEIGHT)) {
        [self.exploreMapViewController.userLocationButton setAlpha:0];
        [self.exploreMapViewController.locationLabel setAlpha:1];
    } else if (destination.y > (superviewFrame.size.height - HEADER_HEIGHT)) {
        [self.exploreMapViewController.userLocationButton setAlpha:1];
        [self.exploreMapViewController.locationLabel setAlpha:0];
    } else {
        [self.exploreMapViewController.userLocationButton setAlpha:destination.y / (superviewFrame.size.height - HEADER_HEIGHT - TOPBAR_HEIGHT)];
        [self.exploreMapViewController.locationLabel setAlpha:1 - (destination.y / (superviewFrame.size.height - HEADER_HEIGHT - TOPBAR_HEIGHT))];
    }
    
}

- (void)userDidFinishPanningFromLocation:(CGPoint)origin toLocation:(CGPoint)destination
{
    CGRect superviewFrame = self.view.frame;
    if (destination.y < (superviewFrame.size.height * 0.5 + TOPBAR_HEIGHT)) {
        // shows table view
        
        // moved from bottom to top
        // moved from top to top
        [self.exploreMapView setFrame:CGRectMake(0, TOPBAR_HEIGHT, self.exploreMapView.bounds.size.width, HEADER_HEIGHT)];
        [self.overlayView setFrame:CGRectMake(0, TOPBAR_HEIGHT, self.overlayView.bounds.size.width, HEADER_HEIGHT)];
        [self.exploreTableView setFrame:CGRectMake(0, HEADER_HEIGHT + TOPBAR_HEIGHT, self.exploreTableView.bounds.size.width, self.exploreTableView.bounds.size.height) ];

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
        [self.exploreMapView setFrame:CGRectMake(0, TOPBAR_HEIGHT, self.exploreMapView.bounds.size.width, superviewFrame.size.height - HEADER_HEIGHT - TOPBAR_HEIGHT)];
        [self.overlayView setFrame:CGRectMake(0, superviewFrame.size.height - HEADER_HEIGHT, self.overlayView.bounds.size.width, HEADER_HEIGHT)];
        [self.exploreTableView setFrame:CGRectMake(0, superviewFrame.size.height - HEADER_HEIGHT, self.exploreTableView.bounds.size.width, self.exploreTableView.bounds.size.height)];
        
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

#pragma mark - Search

#define SEARCH_BAR_HEIGHT 44.0

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        CGRect superviewFrame = self.view.frame;
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, TOPBAR_HEIGHT, superviewFrame.size.width, SEARCH_BAR_HEIGHT)];
        [_searchBar setTranslucent:NO];
        [_searchBar setBarTintColor:[UIColor colorWithRed:242.0/255.0 green:120.0/255.0 blue:75.0/255.0 alpha:1]];
        [_searchBar setTintColor:[UIColor colorWithRed:242.0/255.0 green:241.0/255.0 blue:239.0/255.0 alpha:1]];
        [_searchBar setDelegate:self];
        
    }
    return _searchBar;
}

- (UISearchDisplayController *)searchController
{
    if (!_searchController) {
        _searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        [_searchController setSearchResultsDataSource:self];
        [_searchController setSearchResultsDelegate:self];
        [_searchController setDelegate:self];
   
        [_searchController.searchResultsTableView setContentInset:UIEdgeInsetsMake(SEARCH_BAR_HEIGHT, 0, 0, 0)];
    }
    return _searchController;
}

- (NSMutableArray *)searchLocationResults
{
    if (!_searchLocationResults) {
        _searchLocationResults = [[NSMutableArray alloc] init];
    }
    return _searchLocationResults;
}

- (void)toggleSearch:(id)sender
{
    if ([self.view.subviews containsObject:self.exploreFilterView]) {
        [self toggleFilter:nil];
    }
    
    if (![self.view.subviews containsObject:self.searchBar]) {
        [self.searchController setActive:YES];
    } else {
        [self.searchController setActive:NO];
        
    }
}

- (void)searchWithSearchText:(NSString *)searchText
{
    [self.searchLocationResults removeAllObjects];
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchText;
    request.region = MKCoordinateRegionForMapRect(MKMapRectWorld);
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        for (MKMapItem *mapItem in response.mapItems)
        {
            MKPlacemark *placemark = mapItem.placemark;
            
            if ([placemark.countryCode isEqualToString:@"DE"] || [placemark.countryCode isEqualToString:@"CN"]) {
                
                if ([placemark.locality hasPrefix:searchText]) {
                    
                    BOOL contains = NO;
                    for (MKPlacemark *existingPlacemark in self.searchLocationResults) {
                        
                        if ([existingPlacemark.locality isEqualToString:placemark.locality]) {
                            contains = YES;
                        }
                        
                    }
                    
                    if (!contains) {
                        [self.searchLocationResults addObject:placemark];
                    }
                    
                }

            }
            
        }
        
        [self.searchDisplayController.searchResultsTableView reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchWithSearchText:searchBar.text];
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchWithSearchText:searchText];
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    [self.searchBarButtonItem setTintColor:[UIColor colorWithRed:242.0/255.0 green:120.0/255.0 blue:75.0/255.0 alpha:1]];
    
    self.searchBar.showsCancelButton = NO;
    
    if (![self.view.subviews containsObject:self.searchBar]) {
        [self.view addSubview:self.searchBar];
    }
    [self.searchBar becomeFirstResponder];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.searchBarButtonItem setTintColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]];
    
    [self.searchBar resignFirstResponder];
    [self.searchBar removeFromSuperview];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    CGRect superviewFrame = self.view.frame;
    [_searchController.searchResultsTableView setFrame:CGRectMake(0, TOPBAR_HEIGHT, superviewFrame.size.width, superviewFrame.size.height - TOPBAR_HEIGHT)];
}

#define EXPLORE_SEARCH_RESULT_TABLE_VIEW_CELL_REUSE_IDENTIFIER @"ExploreSearchResultTableViewCell"

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchLocationResults.count > 0) {
        return 1;
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0 && self.searchLocationResults.count > 0) {
        return LOCALE_SEARCH_LOCATION_HEADER;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchLocationResults) {
        return self.searchLocationResults.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:EXPLORE_SEARCH_RESULT_TABLE_VIEW_CELL_REUSE_IDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EXPLORE_SEARCH_RESULT_TABLE_VIEW_CELL_REUSE_IDENTIFIER];
    }
    
    if ([[self.searchLocationResults objectAtIndex:indexPath.row] isKindOfClass:[MKPlacemark class]]) {
        MKPlacemark *placemark = (MKPlacemark *) [self.searchLocationResults objectAtIndex:indexPath.row];
        [cell.textLabel setText:placemark.locality];
    }
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.searchLocationResults objectAtIndex:indexPath.row] isKindOfClass:[MKPlacemark class]]) {
        MKPlacemark *placemark = (MKPlacemark *) [self.searchLocationResults objectAtIndex:indexPath.row];
       
        [self.exploreMapViewController.mapView setCenterCoordinate:placemark.coordinate];
        [self updateCurrentLocationFromMapViewCenter];
        [self updateFetchedResultsController];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self.searchController setActive:NO];
    }
}

#pragma mark - Filter

- (void)toggleFilter:(id)sender
{
    if ([self.view.subviews containsObject:self.searchBar]) {
        [self toggleSearch:nil];
    }
    
    if (![self.view.subviews containsObject:self.exploreFilterView]) {
        [self.filterBarButtonItem setTintColor:[UIColor colorWithRed:242.0/255.0 green:120.0/255.0 blue:75.0/255.0 alpha:1]];
        [self.view addSubview:self.exploreFilterView];
    } else {
        [self.filterBarButtonItem setTintColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]];
        [self.exploreFilterView removeFromSuperview];
    }
    
}

@end

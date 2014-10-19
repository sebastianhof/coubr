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

#import "Explore+Delete.h"
#import "Explore+Insert.h"
#import "Explore+Fetch.h"

#import "coubrExploreMapViewController.h"
#import "coubrExploreTableViewController.h"

#import "coubrLocationManager.h"

@interface coubrExploreViewController ()

@property (strong, nonatomic) coubrExploreTableViewController *exploreTableViewController;
@property (strong, nonatomic) coubrExploreMapViewController *exploreMapViewController;

@property (weak, nonatomic) IBOutlet UIButton *leftBottomButton;
@property (weak, nonatomic) IBOutlet UIButton *leftBottomLabelButton;

@property (weak, nonatomic) UIView *exploreTableView;
@property (weak, nonatomic) UIView *exploreMapView;

@end

@implementation coubrExploreViewController

- (void)awakeFromNib
{
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ManagedDatabaseDidBecomeAvailableNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Explore fetchRequestForExploreItemsWithinDistance:EXPLORE_DEFAULT_DISTANCE] managedObjectContext:[[coubrDatabaseManager defaultManager] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        
        [self refresh];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:LocationDidBecomeAvailableNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self refresh];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:LocationDidFailNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // DO something on location error
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[coubrLocationManager defaultManager] updateLocation];
    [self showTableViewInExploreView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - init

- (coubrExploreTableViewController *)exploreTableViewController
{
    if (!_exploreTableViewController) {
        _exploreTableViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"coubrExploreTableViewController"];
        [_exploreTableViewController setParentController:self];
        [self addChildViewController:_exploreTableViewController];
    }
    return _exploreTableViewController;
}

- (coubrExploreMapViewController *)exploreMapViewController
{
    if (!_exploreMapViewController) {
        _exploreMapViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"coubrExploreMapViewController"];
        [_exploreMapViewController setParentController:self];
        [self addChildViewController:_exploreMapViewController];
    }
    return _exploreMapViewController;
}

- (UIView *)exploreTableView
{
    if (!_exploreTableView) {
        _exploreTableView  = self.exploreTableViewController.view;
        
        CGRect superviewFrame = self.view.frame;

        CGRect frame = _exploreTableView.frame;
        frame.size.width = superviewFrame.size.width;
        frame.size.height = superviewFrame.size.width * (3.0 / 2.0);
        frame.origin.y = 0;
        frame.origin.x = 0;
        [_exploreTableView setFrame:frame];
        
    }
    return _exploreTableView;
}

- (UIView *)exploreMapView
{
    if (!_exploreMapView) {
        _exploreMapView = self.exploreMapViewController.view;
        
        CGRect superviewFrame = self.view.frame;
        
        CGRect frame = _exploreMapView.frame;
        frame.size.width = superviewFrame.size.width;
        frame.size.height = superviewFrame.size.width * (3.0 / 2.0);
        frame.origin.y = 0;
        frame.origin.x = 0;
        [_exploreMapView setFrame:frame];
        

    }
    return _exploreMapView;
}

#pragma mark - refresh

- (void)refresh
{
    
    if ([[coubrLocationManager defaultManager] lastLocation] && [[coubrDatabaseManager defaultManager] managedObjectContext]) {
        
        [[coubrRemoteManager defaultManager] loadExploreJSONWithinDistance:10000 completionHandler:^(NSDictionary *JSONData) {
            
            // Update Database with JSON Explore Data            
            
            [Explore deleteExploreItemsInDatabase];
            [Explore insertExploreItemsIntoDatabaseFromExploreJSON:JSONData];
            
            // Update FetchedResultsController
            
            NSError *error;
            [self.fetchedResultsController performFetch:&error];
            
            if (error) {
                NSLog(@"Could not perform fetch");
            }
            
            // Send notification
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchedResultsControllerDidUpdatedNotification object:self];
            
        } errorHandler:^(NSDictionary *error) {
            NSLog(@"Could not load data");
        }];
        
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)toggleExploreChildView:(id)sender {
    
    if ([[self.view subviews] containsObject:self.exploreTableView]) {
        // show map view
        [self showMapViewInExploreView];
        
    } else if ([[self.view subviews] containsObject:self.exploreMapView]) {
        // show table view
        [self showTableViewInExploreView];
    }
    
}

- (void)showTableViewInExploreView
{
    [self.exploreMapView removeFromSuperview];
    [self.view addSubview:self.exploreTableView];
    
    [self.leftBottomButton setImage:[UIImage imageNamed:@"Map"] forState:UIControlStateNormal];
        
    [UIView transitionWithView:self.leftBottomButton duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [self.leftBottomButton setImage:[UIImage imageNamed:@"Map"] forState:UIControlStateNormal];
    } completion:nil];
    
    [UIView transitionWithView:self.leftBottomLabelButton duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [self.leftBottomLabelButton setTitle:@"Map" forState:UIControlStateNormal];
    } completion:nil];
    
}

- (void)showMapViewInExploreView
{
    [self.exploreTableView removeFromSuperview];

    [self.view addSubview:self.exploreMapView];

    [UIView transitionWithView:self.leftBottomButton duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [self.leftBottomButton setImage:[UIImage imageNamed:@"Table"] forState:UIControlStateNormal];
    } completion:nil];
    
    [UIView transitionWithView:self.leftBottomLabelButton duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [self.leftBottomLabelButton setTitle:@"List" forState:UIControlStateNormal];
    } completion:nil];
    
}

- (IBAction)showFilterInExploreView:(id)sender {
    
    
    
    
}


@end

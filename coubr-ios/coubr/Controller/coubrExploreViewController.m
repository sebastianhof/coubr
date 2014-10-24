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
#import "coubrExploreHeaderViewController.h"
#import "coubrExploreTableViewController.h"

#import "coubrExploreFilterViewController.h"

#import "coubrLocationManager.h"

@interface coubrExploreViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *exploreScrollView;

@property (strong, nonatomic) coubrExploreMapViewController *exploreMapViewController;
@property (strong, nonatomic) coubrExploreHeaderViewController *exploreHeaderViewController;
@property (strong, nonatomic) coubrExploreTableViewController *exploreTableViewController;

@property (weak, nonatomic) UIView *exploreMapView;
@property (weak, nonatomic) UIView *exploreHeaderView;
@property (weak, nonatomic) UIView *exploreTableView;

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
    
    [[NSNotificationCenter defaultCenter] addObserverForName:LocationDidBecomeAvailableNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self updateFetchedResultsController];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[coubrLocationManager defaultManager] updateLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initScrollView];
}

#pragma mark - init controllers

#define HEADER_RATIO 2.5 //1.778 // 16:9

- (coubrExploreMapViewController *)exploreMapViewController
{
    if (!_exploreMapViewController) {
        _exploreMapViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"coubrExploreMapViewController"];
        [_exploreMapViewController setParentController:self];
    }
    return _exploreMapViewController;
}

- (coubrExploreHeaderViewController *)exploreHeaderViewController
{
    if (!_exploreHeaderViewController) {
        _exploreHeaderViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"coubrExploreHeaderViewController"];
        [_exploreHeaderViewController setParentController:self];
    }
    return _exploreHeaderViewController;
}

- (coubrExploreTableViewController *)exploreTableViewController
{
    if (!_exploreTableViewController) {
        _exploreTableViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"coubrExploreTableViewController"];
        [_exploreTableViewController setParentController:self];
    }
    return _exploreTableViewController;
}

#pragma mark - init views

- (void)initScrollView {
    [self.exploreScrollView addSubview:self.exploreHeaderView];
    [self.exploreScrollView addSubview:self.exploreTableView];

    CGRect superviewFrame = self.view.frame;
    CGSize size = CGSizeMake(superviewFrame.size.width, superviewFrame.size.height + (superviewFrame.size.height - (1 / HEADER_RATIO) * superviewFrame.size.width));
    [self.exploreScrollView setContentSize:size];
    
    // scroll to bottom
    [self scrollToBottom];
}

- (UIView *)exploreMapView
{
    if (!_exploreMapView) {
        _exploreMapView = self.exploreMapViewController.view;
        
        CGRect superviewFrame = self.view.frame;
        
        CGRect frame = _exploreMapView.frame;
        frame.size.width = superviewFrame.size.width;
        frame.size.height = superviewFrame.size.height - (1 / HEADER_RATIO) * superviewFrame.size.width;
        frame.origin.y = 0;
        frame.origin.x = 0;
        [_exploreMapView setFrame:frame];
        
    }
    return _exploreMapView;
}

- (UIView *)exploreHeaderView
{
    if (!_exploreHeaderView) {
        _exploreHeaderView = self.exploreHeaderViewController.view;
        
        CGRect superviewFrame = self.view.frame;
        
        CGRect frame = _exploreHeaderView.frame;
        frame.size.width = superviewFrame.size.width;
        frame.size.height = superviewFrame.size.width * (1 / HEADER_RATIO);
        frame.origin.y = superviewFrame.size.height - (1 / HEADER_RATIO) * superviewFrame.size.width;
        frame.origin.x = 0;
        [_exploreHeaderView setFrame:frame];
        
    }
    return _exploreHeaderView;
}

- (UIView *)exploreTableView
{
    if (!_exploreTableView) {
        _exploreTableView  = self.exploreTableViewController.view;
        
        CGRect superviewFrame = self.view.frame;

        CGRect frame = _exploreTableView.frame;
        frame.size.width = superviewFrame.size.width;
        frame.size.height = superviewFrame.size.height - (1 / HEADER_RATIO) * superviewFrame.size.width;
        frame.origin.y = superviewFrame.size.height;
        frame.origin.x = 0;
        [_exploreTableView setFrame:frame];

    }
    return _exploreTableView;
}

#pragma mark - update FetchedResultsController

- (void)updateLocationAndFetchedResultsController
{
    
    [[coubrLocationManager defaultManager] updateLocation];
    
}

- (void)updateFetchedResultsController
{
    
    // Load data from remote
    if ([[coubrLocationManager defaultManager] lastLocation] && [[coubrDatabaseManager defaultManager] managedObjectContext]) {
        
        // wipe database before loading
        [Explore deleteExploreItemsInDatabase];
        
        [[coubrRemoteManager defaultManager] loadExploreJSONWithinDistance:10000 completionHandler:^(NSDictionary *JSONData) {
            
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

#pragma mark - scrollview

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect superviewFrame = self.view.frame;
    
    if (scrollView.contentOffset.y == 0) {
        
        if (![[scrollView subviews] containsObject:_exploreMapView]) {
            [scrollView addSubview:self.exploreMapView];
        }

    } else if (scrollView.contentOffset.y > superviewFrame.size.height - (1 / HEADER_RATIO) * superviewFrame.size.width - 16) {
        
        if ([[scrollView subviews] containsObject:_exploreMapView]) {
            [self.exploreMapView removeFromSuperview];
            self.exploreMapView = nil;
            [self.exploreMapViewController removeFromParentViewController];
            self.exploreMapViewController = nil;
        }
        
    }
    
}

- (void)scrollToTop
{
    // scroll to top
    CGPoint topOffset = CGPointMake(0, 0);
    [self.exploreScrollView setContentOffset:topOffset animated:YES];
}

- (void)scrollToBottom
{
    // scroll to bottom
    CGPoint bottomOffset = CGPointMake(0, self.exploreScrollView.contentSize.height - self.exploreScrollView.bounds.size.height);
    [self.exploreScrollView setContentOffset:bottomOffset animated:YES];
}

- (void)scrollToPosition:(CGFloat)position
{
    
}

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showFilterView"]) {
        
        if ([segue.destinationViewController isKindOfClass:[coubrExploreFilterViewController class]]) {
            
            coubrExploreFilterViewController *fvc = (coubrExploreFilterViewController *)segue.destinationViewController;
            [fvc setParentController:self];
            
        }
        
    }
    
}



@end

//
//  coubrExploreTableViewController.m
//  coubr
//
//  Created by Sebastian Hof on 17/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import <CoreData/CoreData.h>

#import "coubrExploreTableViewController.h"
#import "coubrNoStoreController.h"
#import "coubrExploreTableViewCell.h"

#import "coubrLocationManager.h"
#import "coubrLocale.h"

#import "UIImage+ImageEffects.h"

#import "Explore.h"

@interface coubrExploreTableViewController ()

@property (strong, nonatomic)coubrNoStoreController *noStoreController;
@property (strong, nonatomic)UIViewController *noConnectionController;
@property (strong, nonatomic)UIViewController *noLocationController;

@property (weak, nonatomic) UIView *noStoreView;
@property (weak, nonatomic) UIView *noConnectionView;
@property (weak, nonatomic) UIView *noLocationView;

@end

@implementation coubrExploreTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UserLocationDidFailNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [self showNoLocationView];
        });
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UserLocationDidBecomeAvailableNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideNoLocationView];
        });
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ConnectionDidFailNotification object:self.parentController queue:nil usingBlock:^(NSNotification *note) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [self showNoConnectionView];
        });
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ConnectionDidBecomeAvailableNotification object:self.parentController queue:nil usingBlock:^(NSNotification *note) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideNoConnectionView];
        });
        
    }];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:FetchedResultsControllerDidUpdatedNotification object:self.parentController queue:nil usingBlock:^(NSNotification *note) {

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.storeIds removeAllObjects];
                
            for (NSManagedObject *managedObject in [self.parentController.fetchedResultsController fetchedObjects]) {
                
                if ([managedObject isKindOfClass:[Explore class]]) {
                    [self.storeIds addObject:((Explore *) managedObject).storeId];
                }
                
            }

            [self.tableView reloadData];
            
            if ([[self.parentController.fetchedResultsController fetchedObjects] count] > 0) {
                [self.refreshControl endRefreshing];
                [self hideNoStoreView];
                [self hideNoConnectionView];
                [self hideNoLocationView];
                
                // map view
                if ([self.parentController showsMapInFullscreen]) {
                    [self scrollToOffset];
                }
                
            } else {
                [self.refreshControl endRefreshing];
                [self showNoStoreView];
                [self hideNoConnectionView];
                [self hideNoLocationView];
            }
            
        });
        
    }];
    
    [self initRefreshControl];
    
}

#pragma mark - Init

- (void)initRefreshControl
{
    
    if (!self.refreshControl) {
        self.refreshControl = [[UIRefreshControl alloc] init];
    }
    
    NSMutableAttributedString *coubr = [[NSMutableAttributedString alloc] initWithString:@" coubr"
                                                                attributes:@{ NSFontAttributeName: [UIFont fontWithName:@"Courgette" size:14]}];
    NSMutableAttributedString *refreshControlTitle = [[NSMutableAttributedString alloc] initWithString:LOCALE_REFRESHING
                                                                     attributes:@{ NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]}];

    [refreshControlTitle appendAttributedString:coubr];

    [self.refreshControl setAttributedTitle:refreshControlTitle];
    self.refreshControl.tintColor = [UIColor colorWithRed:51 green:51 blue:51 alpha:1];
    
    [self.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
}

@synthesize storeIds = _storeIds;

- (NSMutableArray *)storeIds
{
    if (!_storeIds) {
        _storeIds = [[NSMutableArray alloc] init];
    }
    return _storeIds;
}

#pragma mark - Refresh

- (void)refreshTableView
{
    [self.parentController updateFetchedResultsController];
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.parentController.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.parentController.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.parentController.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"coubrExploreTableViewCell" forIndexPath:indexPath];
    
    NSManagedObject *managedObject = [self.parentController.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([managedObject isKindOfClass:[Explore class]]) {
        [(coubrExploreTableViewCell *) cell setParentController:self];
        [(coubrExploreTableViewCell *) cell initCellWithExplore:(Explore *)managedObject];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[self.parentController.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.parentController.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    } else {
        return nil;
    }
}

#pragma mark - Empty table view

- (coubrNoStoreController *)noStoreController
{
    if (!_noStoreController) {
        _noStoreController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrNoStoreController"];
        [_noStoreController setParentController:self];
    }
    return _noStoreController;
}

- (UIView *)noStoreView
{
    if (!_noStoreView) {
        _noStoreView = self.noStoreController.view;
        
        CGRect superviewFrame = self.tableView.frame;
        CGRect frame = CGRectMake(0, 0, superviewFrame.size.width, superviewFrame.size.height);
        [_noStoreView setFrame:frame];
    }
    return _noStoreView;
}

- (void)showNoStoreView
{
    if (![[self.tableView subviews] containsObject:_noStoreView]) {
        [self.tableView addSubview:self.noStoreView];
    }

}

- (void)hideNoStoreView
{
    
    if ([[self.tableView subviews] containsObject:_noStoreView]) {
        [self.noStoreView removeFromSuperview];
        _noStoreView = nil;
        _noStoreController = nil;
    }
    
}

#pragma mark - No Location view

#pragma mark - location

- (UIViewController *)noLocationController
{
    if (!_noLocationController) {
        _noLocationController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrNoLocationController"];
    }
    return _noLocationController;
}

- (UIView *)noLocationView
{
    if (!_noLocationView) {
        _noLocationView = self.noLocationController.view;
        
        CGRect superviewFrame = self.tableView.frame;
        CGRect frame = CGRectMake(0, 0, superviewFrame.size.width, superviewFrame.size.height);
        
        [_noLocationView setFrame:frame];
    }
    return _noLocationView;
}

- (void)hideNoLocationView
{
    
    if ([[self.tableView subviews] containsObject:_noLocationView]) {
        [self.noLocationView removeFromSuperview];
        _noLocationView = nil;
        _noLocationController = nil;
    }
    
}

- (void)showNoLocationView
{
    
    if (![[self.tableView subviews] containsObject:_noLocationView]) {
        [self.tableView addSubview:self.noLocationView];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateLocation) userInfo:nil repeats:NO];

}

#pragma mark - No connection view

- (UIViewController *)noConnectionController
{
    if (!_noConnectionController) {
        _noConnectionController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrNoConnectionController"];
    }
    return _noConnectionController;
}

- (UIView *)noConnectionView
{
    if (!_noConnectionView) {
        _noConnectionView = self.noConnectionController.view;
        
        CGRect superviewFrame = self.tableView.frame;
        CGRect frame = CGRectMake(0, 0, superviewFrame.size.width, superviewFrame.size.height);
        
        [_noConnectionView setFrame:frame];
    }
    return _noConnectionView;
}

- (void)hideNoConnectionView
{
 
    if ([[self.tableView subviews] containsObject:_noConnectionView]) {
        [self.noConnectionView removeFromSuperview];
        _noConnectionView = nil;
        _noConnectionController = nil;
    }
    
}

- (void)showNoConnectionView
{
    if (![[self.tableView subviews] containsObject:_noConnectionView]) {
        [self.tableView addSubview:self.noConnectionView];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reconnect) userInfo:nil repeats:NO];
}

- (void)reconnect
{
    [self.parentController updateFetchedResultsController];
}

- (void)updateLocation
{
    [[coubrLocationManager defaultManager] updateUserLocation];
}

#define TABLE_VIEW_TOP_OFFSET 56.0

- (void)scrollToTop
{
    [self.tableView setContentOffset:CGPointZero animated:NO];
}

- (void)scrollToOffset
{
    [self.tableView setContentOffset:CGPointMake(0, TABLE_VIEW_TOP_OFFSET) animated:NO];
}

@end

//
//  coubrExploreTableViewController.m
//  coubr
//
//  Created by Sebastian Hof on 17/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import <CoreData/CoreData.h>

#import "coubrLocale.h"
#import "coubrExploreTableViewController.h"
#import "coubrExploreTableViewCell.h"

#import "coubrLocationManager.h"

#import "UIImage+ImageEffects.h"

#import "Explore.h"

@interface coubrExploreTableViewController ()

@property (strong, nonatomic)UIViewController *emptyTableViewController;
@property (strong, nonatomic)UIViewController *noConnectionViewController;
@property (strong, nonatomic)UIViewController *noLocationViewController;

@property (weak, nonatomic) UIView *emptyTableView;
@property (weak, nonatomic) UIView *noConnectionView;
@property (weak, nonatomic) UIView *noLocationView;

@end

@implementation coubrExploreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self initRefreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:FetchedResultsControllerDidUpdatedNotification object:self.parentController queue:nil usingBlock:^(NSNotification *note) {

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            
            if ([[self.parentController.fetchedResultsController fetchedObjects] count] > 0) {
                
                [self.refreshControl endRefreshing];
                
                [self hideEmptyTableView];
                
            } else {
                
                [self.refreshControl endRefreshing];
                
                [self showEmptyTableView];
                
                
                
            }
            
            
        });
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UserLocationDidFailNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [self locationDidFail];
        });
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UserLocationDidBecomeAvailableNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
     
        dispatch_async(dispatch_get_main_queue(), ^{
                [self locationDidBecomeAvailable];
        });
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ConnectionDidFailNotification object:self.parentController queue:nil usingBlock:^(NSNotification *note) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [self connectionDidFail];
        });
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ConnectionDidBecomeAvailableNotification object:self.parentController queue:nil usingBlock:^(NSNotification *note) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self connectionDidBecomeAvailable];
        });    
            
    }];
    
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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.parentController.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.parentController.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

#pragma mark - Empty table view

- (UIViewController *)emptyTableViewController
{
    if (!_emptyTableViewController) {
        _emptyTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrExploreTableViewEmptyViewController"];
    }
    return _emptyTableViewController;
}

- (UIView *)emptyTableView
{
    if (!_emptyTableView) {
        _emptyTableView = self.emptyTableViewController.view;
        
        CGRect superviewFrame = self.tableView.frame;
        CGRect frame = CGRectMake(0, 0, superviewFrame.size.width, superviewFrame.size.height);
        [_emptyTableView setFrame:frame];
    }
    return _emptyTableView;
}

- (void)showEmptyTableView
{
    
    if (![[self.tableView subviews] containsObject:_emptyTableView]) {
        [self.tableView addSubview:self.emptyTableView];
    }
    
}

- (void)hideEmptyTableView
{
    
    if ([[self.tableView subviews] containsObject:_emptyTableView]) {
        [self.emptyTableView removeFromSuperview];
        _emptyTableView = nil;
        _emptyTableViewController = nil;
    }
    
}

#pragma mark - No Location view

#pragma mark - location

- (UIViewController *)noLocationViewController
{
    if (!_noLocationViewController) {
        _noLocationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrErrorNoLocationViewController"];
    }
    return _noLocationViewController;
}

- (UIView *)noLocationView
{
    if (!_noLocationView) {
        _noLocationView = self.noLocationViewController.view;
        
        CGRect superviewFrame = self.tableView.frame;
        CGRect frame = CGRectMake(0, 0, superviewFrame.size.width, superviewFrame.size.height);
        
        [_noLocationView setFrame:frame];
    }
    return _noLocationView;
}

- (void)locationDidBecomeAvailable
{
    
    if ([[self.tableView subviews] containsObject:_noLocationView]) {
        [self.noLocationView removeFromSuperview];
        _noLocationView = nil;
        _noLocationViewController = nil;
    }
    
}

- (void)locationDidFail
{
    
    if (![[self.tableView subviews] containsObject:_noLocationView]) {
        [self.tableView addSubview:self.noLocationView];
    }
    
    
}

#pragma mark - No connection view

- (UIViewController *)noConnectionViewController
{
    if (!_noConnectionViewController) {
        _noConnectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrErrorNoConnectionViewController"];
    }
    return _noConnectionViewController;
}

- (UIView *)noConnectionView
{
    if (!_noConnectionView) {
        _noConnectionView = self.noConnectionViewController.view;
        
        CGRect superviewFrame = self.tableView.frame;
        CGRect frame = CGRectMake(0, 0, superviewFrame.size.width, superviewFrame.size.height);
        
        [_noConnectionView setFrame:frame];

    }
    return _noConnectionView;
}

- (void)connectionDidBecomeAvailable
{
 
    if ([[self.tableView subviews] containsObject:_noConnectionView]) {
        [self.noConnectionView removeFromSuperview];
        _noConnectionView = nil;
        _noConnectionViewController = nil;
    }
    
}

- (void)connectionDidFail
{
    
    if (![[self.tableView subviews] containsObject:_noConnectionView]) {
        [self.tableView addSubview:self.noConnectionView];
    }
    
}

@end

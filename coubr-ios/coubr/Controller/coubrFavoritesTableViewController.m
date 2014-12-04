//
//  coubrFavoritesTableViewController.m
//  coubr
//
//  Created by Sebastian Hof on 20/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrFavoritesTableViewController.h"
#import <CoreData/CoreData.h>
#import "coubrDatabaseManager.h"
#import "coubrStoreViewController.h"
#import "coubrFavoritesTableViewCell.h"
#import "Store+CRUD.h"
#import "Store+Distance.h"

#import "coubrLocationManager.h"
#import <CoreLocation/CoreLocation.h>

#import "UIImage+ImageEffects.h"

@interface coubrFavoritesTableViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) IBOutlet UITableView *profileFavoritesTableView;
@property (weak, nonatomic) UIView* emptyTableView;

@end

@implementation coubrFavoritesTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
    [context performBlockAndWait:^{
        
        NSError* error;
        NSArray *favoriteStores = [context executeFetchRequest:[Store fetchRequestForFavoriteStores] error:&error];
        
        if (!error) {
            
            for (NSManagedObject *managedObject in favoriteStores) {
                
                if ([managedObject isKindOfClass:[Store class]]) {
                    
                    Store *store = (Store *)managedObject;
                    
                    CLLocationDegrees latitude = [store.latitude doubleValue] ;
                    CLLocationDegrees longitude = [store.longitude doubleValue];
                    CLLocation *storeLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                    store.distance = [NSNumber numberWithDouble:[storeLocation distanceFromLocation:[[coubrLocationManager defaultManager] userLocation]]];
                    
                }
                
            }
            
        } else {
            NSLog(@"Could not set distance of favorites: %@", [error localizedDescription]);
        }
        
    }];
    
    NSError* error;
    [self.fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"Could not fetch favorites: %@", [error localizedDescription]);
    } else {
        
        [self.storeIds removeAllObjects];
        
        for (NSManagedObject *managedObject in [self.fetchedResultsController fetchedObjects]) {
            
            if ([managedObject isKindOfClass:[Store class]]) {
                [self.storeIds addObject:((Store *) managedObject).storeId];
            }
            
        }
        
        [self.profileFavoritesTableView reloadData];
        
        if ([[self.fetchedResultsController fetchedObjects] count] > 0) {
            [self hideEmptyTableView];
        } else {
            [self showEmptyTableView];
        }
        
    }

}

@synthesize storeIds = _storeIds;

- (NSMutableArray *)storeIds
{
    if (!_storeIds) {
        _storeIds = [[NSMutableArray alloc] init];
    }
    return _storeIds;
}

- (NSFetchedResultsController *)favoritesFetchedResultsController
{
    if (!_fetchedResultsController) {
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Store fetchRequestForFavoriteStores] managedObjectContext:[[coubrDatabaseManager defaultManager] managedObjectContext] sectionNameKeyPath:@"distanceSection" cacheName:nil];
    }
    return _fetchedResultsController;
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.favoritesFetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.favoritesFetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.favoritesFetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"coubrFavoritesTableViewCell" forIndexPath:indexPath];
    
    NSManagedObject *managedObject = [self.favoritesFetchedResultsController objectAtIndexPath:indexPath];
    
    if ([managedObject isKindOfClass:[Store class]]) {
        coubrFavoritesTableViewCell *favoritesCell = (coubrFavoritesTableViewCell *) cell;
        [favoritesCell setParentController:self];
        [favoritesCell initCellWithStore:(Store *)managedObject];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if ([[self.favoritesFetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.favoritesFetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    } else {
        return nil;
    }
    
}

#pragma mark - Empty table view

- (UIView *)emptyTableView
{
    if (!_emptyTableView) {
        _emptyTableView = ((UIViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"coubrFavoritesTableViewEmptyViewController"]).view;
        
        CGRect superviewFrame = self.view.frame;
        CGRect frame = CGRectMake(0, 0, superviewFrame.size.width, superviewFrame.size.height);
        [_emptyTableView setFrame:frame];
        
        [self.view addSubview:_emptyTableView];
    }
    return _emptyTableView;
}

- (void)showEmptyTableView
{
    
    if (![[self.view subviews] containsObject:_emptyTableView]) {
        [self.view addSubview:self.emptyTableView];
    }
    
}

- (void)hideEmptyTableView
{
    
    if ([[self.view subviews] containsObject:_emptyTableView]) {
        [self.emptyTableView removeFromSuperview];
    }
    
}

@end

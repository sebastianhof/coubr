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
#import "UIImage+ImageEffects.h"

@interface coubrFavoritesTableViewController ()

@property (strong, nonatomic) NSFetchedResultsController *favoritesFetchedResultsController;
@property (strong, nonatomic) IBOutlet UITableView *profileFavoritesTableView;
@property (weak, nonatomic) UIView* emptyTableView;

@end

@implementation coubrFavoritesTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSError* error;
    [self.favoritesFetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"Could not fetch favorites: %@", [error localizedDescription]);
    } else {
        
        if ([[self.favoritesFetchedResultsController fetchedObjects] count] > 0) {
            [self.profileFavoritesTableView reloadData];
            
            [self hideEmptyTableView];
            
        } else {
        
            [self showEmptyTableView];

        }
        
    }

}

- (NSFetchedResultsController *)favoritesFetchedResultsController
{
    if (!_favoritesFetchedResultsController) {
        _favoritesFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Store fetchRequestForFavoriteStores] managedObjectContext:[[coubrDatabaseManager defaultManager] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    }
    return _favoritesFetchedResultsController;
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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.favoritesFetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.favoritesFetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
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

//
//  coubrStoreMenuTableViewController.m
//  coubr
//
//  Created by Sebastian Hof on 22/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreMenuTableViewController.h"
#import "coubrStoreMenuTableViewCell.h"
#import "coubrStoreViewController.h"

#import "StoreMenuItem+CRUD.h"


#import "coubrDatabaseManager.h"

#import <CoreData/CoreData.h>

@interface coubrStoreMenuTableViewController ()

@property (strong, nonatomic) NSFetchedResultsController *menuFetchedResultsController;
@property (weak, nonatomic) UIView* emptyTableView;
@property (weak, nonatomic) NSString *storeId;

@end

@implementation coubrStoreMenuTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:StoreDidBecomeAvailableNotification object:self.parentViewController.parentViewController queue:nil usingBlock:^ (NSNotification *note) {
        
        self.storeId = note.userInfo[STORE_ID];
        [self refreshMenuFetchedResultsController];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.storeId) {
        [self refreshMenuFetchedResultsController];
    }
}

#pragma mark - NSFetchedResults

- (void)refreshMenuFetchedResultsController
{
    
    self.menuFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[StoreMenuItem fetchRequestForMeunItemsOfStoreWithId:self.storeId] managedObjectContext:[[coubrDatabaseManager defaultManager] managedObjectContext] sectionNameKeyPath:@"category" cacheName:nil];
    
    NSError *error;
    [self.menuFetchedResultsController performFetch:&error];
    if (!error) {
        
        if ([[self.menuFetchedResultsController fetchedObjects] count] > 0) {
            [self.tableView reloadData];
            [self hideEmptyTableView];
        } else {
            [self showEmptyTableView];
        }
        
    }
    
}

#pragma mark - UI Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.menuFetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.menuFetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.menuFetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.menuFetchedResultsController objectAtIndexPath:indexPath];
    
    if ([managedObject isKindOfClass:[StoreMenuItem class]]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"coubrStoreMenuTableViewCell" forIndexPath:indexPath];
        if ([cell isKindOfClass:[coubrStoreMenuTableViewCell class]]) {
            coubrStoreMenuTableViewCell *menuCell = (coubrStoreMenuTableViewCell *) cell;
            [menuCell initCellWithStoreMenuItem:(StoreMenuItem *)managedObject];
            return menuCell;
        }
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[self.menuFetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.menuFetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    } else {
        return nil;
    }
}

#pragma mark - Empty table view

- (UIView *)emptyTableView
{
    if (!_emptyTableView) {
        _emptyTableView = ((UIViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreMenuTableViewEmptyViewController"]).view;
        
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

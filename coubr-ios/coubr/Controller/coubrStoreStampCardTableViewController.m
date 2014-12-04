//
//  coubrStoreStampCardTableViewController.m
//  coubr
//
//  Created by Sebastian Hof on 14/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreStampCardTableViewController.h"
#import "coubrStoreViewController.h"

#import "coubrDatabaseManager.h"
#import "coubrLocale.h"
#import "coubrCategoryToText.h"

#import "StampCard+CRUD.h"

#import "coubrStampCardTableViewCell.h"

@interface coubrStoreStampCardTableViewController ()

@property (strong, nonatomic) NSFetchedResultsController *stampCardFetchedResultsController;

@property (weak, nonatomic) NSString *storeId;

@property (weak, nonatomic) UIView* emptyTableView;

@end

@implementation coubrStoreStampCardTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:StoreDidBecomeAvailableNotification object:self.parentViewController.parentViewController queue:nil usingBlock:^ (NSNotification *note) {
        
        self.storeId = note.userInfo[STORE_ID];
        [self refreshStampCardFetchedResultsController];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.storeId) {
        [self refreshStampCardFetchedResultsController];
    }
}

#pragma mark - NSFetchedResults

- (void)refreshStampCardFetchedResultsController
{
    
    self.stampCardFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[StampCard fetchRequestForStampCardsOfStoreWithId:self.storeId] managedObjectContext:[[coubrDatabaseManager defaultManager] managedObjectContext] sectionNameKeyPath:@"category" cacheName:nil];
    
    NSError *error;
    [self.stampCardFetchedResultsController performFetch:&error];
    if (!error) {
        
        if ([[self.stampCardFetchedResultsController fetchedObjects] count] > 0) {
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
    return [[self.stampCardFetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.stampCardFetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.stampCardFetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.stampCardFetchedResultsController objectAtIndexPath:indexPath];
    
    if ([managedObject isKindOfClass:[StampCard class]]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"coubrStampCardTableViewCell" forIndexPath:indexPath];
        if ([cell isKindOfClass:[coubrStampCardTableViewCell class]]) {
            coubrStampCardTableViewCell *stampCardCell = (coubrStampCardTableViewCell *) cell;
            [stampCardCell initCellWithStampCard:(StampCard *)managedObject];
            [stampCardCell setParentController:self];
            return stampCardCell;
        }
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[[self stampCardFetchedResultsController] sections] objectAtIndex:section];
    return [coubrCategoryToText textFromStampCardCategory:[sectionInfo name]];
}

#pragma mark - Empty table view

- (UIView *)emptyTableView
{
    if (!_emptyTableView) {
        _emptyTableView = ((UIViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreStampCardTableViewEmptyViewController"]).view;
        
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

//
//  coubrStoreSpecialOfferTableViewController.m
//  coubr
//
//  Created by Sebastian Hof on 14/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreSpecialOfferTableViewController.h"
#import "coubrStoreViewController.h"

#import "coubrDatabaseManager.h"
#import "coubrLocale.h"

#import "Store+CRUD.h"

#import "coubrSpecialOfferTableViewCell.h"

@interface coubrStoreSpecialOfferTableViewController ()

@property (strong, nonatomic) NSFetchedResultsController *specialOfferFetchedResultsController;

@property (weak, nonatomic) UIView* emptyTableView;

@property (weak, nonatomic) NSString *storeId;

@end

@implementation coubrStoreSpecialOfferTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:StoreDidBecomeAvailableNotification object:self.parentViewController.parentViewController queue:nil usingBlock:^ (NSNotification *note) {
        
        self.storeId = note.userInfo[STORE_ID];
        [self refreshSpecialOfferFetchedResultsController];
    }];
}

#pragma mark - NSFetchedResults

- (void)refreshSpecialOfferFetchedResultsController
{
    
    self.specialOfferFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Store fetchRequestForSpecialOffersOfStoreWithId:self.storeId] managedObjectContext:[[coubrDatabaseManager defaultManager] managedObjectContext] sectionNameKeyPath:@"category" cacheName:nil];
    
    NSError *error;
    [self.specialOfferFetchedResultsController performFetch:&error];
    if (!error) {
        
        if ([[self.specialOfferFetchedResultsController fetchedObjects] count] > 0) {
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
    return [[self.specialOfferFetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.specialOfferFetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.specialOfferFetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.specialOfferFetchedResultsController objectAtIndexPath:indexPath];
    
    if ([managedObject isKindOfClass:[SpecialOffer class]]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"coubrSpecialOfferTableViewCell" forIndexPath:indexPath];
        if ([cell isKindOfClass:[coubrSpecialOfferTableViewCell class]]) {
            coubrSpecialOfferTableViewCell *specialOfferCell = (coubrSpecialOfferTableViewCell *) cell;
            [specialOfferCell initCellWithSpecialOffer:(SpecialOffer *)managedObject];
            [specialOfferCell setParentController:self];
            return specialOfferCell;
        }
    }
        
    return nil;
}

#pragma mark - Empty table view

- (UIView *)emptyTableView
{
    if (!_emptyTableView) {
        _emptyTableView = ((UIViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreSpecialOfferTableViewEmptyViewController"]).view;
        
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

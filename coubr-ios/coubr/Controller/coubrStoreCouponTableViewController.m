//
//  coubrStoreCouponTableViewController.m
//  coubr
//
//  Created by Sebastian Hof on 14/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreCouponTableViewController.h"
#import "coubrStoreViewController.h"

#import "coubrDatabaseManager.h"
#import "coubrLocale.h"
#import "coubrCategoryToText.h"

#import "Coupon+CRUD.h"

#import "coubrCouponTableViewCell.h"

@interface coubrStoreCouponTableViewController ()

@property (strong, nonatomic) NSFetchedResultsController *couponFetchedResultsController;

@property (weak, nonatomic) NSString *storeId;

@property (weak, nonatomic) UIView* emptyTableView;

@end

@implementation coubrStoreCouponTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:StoreDidBecomeAvailableNotification object:self.parentViewController.parentViewController queue:nil usingBlock:^ (NSNotification *note) {

        self.storeId = note.userInfo[STORE_ID];
        [self refreshCouponFetchedResultsController];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.storeId) {
        [self refreshCouponFetchedResultsController];
    }
}

#pragma mark - NSFetchedResults

- (void)refreshCouponFetchedResultsController
{
    
    self.couponFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Coupon fetchRequestForCouponsOfStoreWithId:self.storeId] managedObjectContext:[[coubrDatabaseManager defaultManager] managedObjectContext] sectionNameKeyPath:@"category" cacheName:nil];
    
    NSError *error;
    [self.couponFetchedResultsController performFetch:&error];
    if (!error) {
        
        if ([[self.couponFetchedResultsController fetchedObjects] count] > 0) {
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
    return [[self.couponFetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.couponFetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.couponFetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.couponFetchedResultsController objectAtIndexPath:indexPath];
    
    if ([managedObject isKindOfClass:[Coupon class]]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"coubrCouponTableViewCell" forIndexPath:indexPath];
        if ([cell isKindOfClass:[coubrCouponTableViewCell class]]) {
            coubrCouponTableViewCell *couponCell = (coubrCouponTableViewCell *) cell;
            [couponCell initCellWithCoupon:(Coupon *)managedObject];
            [couponCell setParentController:self];
            return couponCell;
        }
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[[self couponFetchedResultsController] sections] objectAtIndex:section];
    return [coubrCategoryToText textFromCouponCategory:[sectionInfo name]];
}

#pragma mark - Empty table view

- (UIView *)emptyTableView
{
    if (!_emptyTableView) {
        _emptyTableView = ((UIViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreCouponTableViewEmptyViewController"]).view;
        
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

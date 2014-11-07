//
//  coubrStoreOfferTableViewController.m
//  coubr
//
//  Created by Sebastian Hof on 20/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreOfferTableViewController.h"
#import "coubrCouponTableViewCell.h"
#import "coubrCouponOverviewController.h"

#import "UIImage+ImageEffects.h"

@interface coubrStoreOfferTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *couponTableView;

@property (weak, nonatomic) UIView* emptyTableView;

@end

@implementation coubrStoreOfferTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserverForName:CouponFetchedResultsControllerDidUpdatedNotification object:self.parentController.parentController queue:nil usingBlock:^ (NSNotification *note) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if ([[self.parentController.parentController.couponFetchedResultsController fetchedObjects] count] > 0) {
                [self.couponTableView reloadData];
                [self hideEmptyTableView];
                [self blurTableViewBackground];
            } else {
                [self showEmptyTableView];
            }
            
        });
        
    }];
    
    
}

#pragma mark - UI Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.parentController.parentController.couponFetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.parentController.parentController.couponFetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.parentController.parentController.couponFetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"coubrCouponTableViewCell" forIndexPath:indexPath];
    
    NSManagedObject *managedObject = [self.parentController.parentController.couponFetchedResultsController objectAtIndexPath:indexPath];
    
    if ([managedObject isKindOfClass:[Coupon class]]) {
        [(coubrCouponTableViewCell *) cell initCellWithCoupon:(Coupon *)managedObject];
        [(coubrCouponTableViewCell *) cell setParentController:self];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if ([[self.parentController.parentController.couponFetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.parentController.parentController.couponFetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    } else {
        return nil;
    }
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.parentController.parentController.couponFetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.parentController.parentController.couponFetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
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

- (void)blurTableViewBackground
{    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.view.layer renderInContext:c];
    
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage = [viewImage applyLightEffect];
    
    UIGraphicsEndImageContext();
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:viewImage];
}


@end

//
//  coubrStoreViewController.m
//  coubr
//
//  Created by Sebastian Hof on 20/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreViewController.h"

#import "coubrLocationManager.h"

#import "coubrStoreMapViewController.h"
#import "coubrStoreHeaderViewController.h"
#import "coubrStorePageViewController.h"


#import "coubrRemoteManager+Store.h"
#import "Store+CRUD.h"
#import "Coupon+CRUD.h"
#import "coubrDatabaseManager.h"

#import "coubrTypesToImage.h"

@interface coubrStoreViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *storeScrollView;

@property (strong, nonatomic) coubrStoreMapViewController *storeMapViewController;
@property (strong, nonatomic) coubrStoreHeaderViewController *storeHeaderViewController;
@property (strong, nonatomic) coubrStorePageViewController *storePageViewController;

@property (weak, nonatomic) UIView *storeMapView;
@property (weak, nonatomic) UIView *storeHeaderView;
@property (weak, nonatomic) UIView *storePageView;

@end

@implementation coubrStoreViewController

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self.navigationController.navigationBar setTranslucent:NO];
    
    
    [self loadStoreItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self initScrollView];
}

#pragma mark - init controllers

#define HEADER_RATIO 2.5 //1.778 // 16:9

- (coubrStoreMapViewController *)storeMapViewController
{
    if (!_storeMapViewController) {
        _storeMapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreMapViewController"];
        [_storeMapViewController setParentController:self];
    }
    return _storeMapViewController;
}

- (coubrStoreHeaderViewController *)storeHeaderViewController
{
    if (!_storeHeaderViewController) {
        _storeHeaderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreHeaderViewController"];
        [_storeHeaderViewController setParentController:self];
    }
    return _storeHeaderViewController;
}

- (coubrStorePageViewController *)storePageViewController
{
    if (!_storePageViewController) {
        _storePageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStorePageViewController"];
        [_storePageViewController setParentController:self];
    }
    return _storePageViewController;
}

#pragma mark - init views

- (void)initScrollView {
    [self.storeScrollView addSubview:self.storeHeaderView];
    [self.storeScrollView addSubview:self.storePageView];
    
    CGRect superviewFrame = self.view.frame;
    CGSize size = CGSizeMake(superviewFrame.size.width, superviewFrame.size.height + (superviewFrame.size.height - (1 / HEADER_RATIO) * superviewFrame.size.width));
    [self.storeScrollView setContentSize:size];
    
    // scroll to bottom
    [self scrollToBottom];
}

- (UIView *)storeMapView
{
    if (!_storeMapView) {
        _storeMapView = self.storeMapViewController.view;
        
        CGRect superviewFrame = self.view.frame;
        
        CGRect frame = _storeMapView.frame;
        frame.size.width = superviewFrame.size.width;
        frame.size.height = superviewFrame.size.height - (1 / HEADER_RATIO) * superviewFrame.size.width;
        frame.origin.y = 0;
        frame.origin.x = 0;
        [_storeMapView setFrame:frame];
    }
    return _storeMapView;
}

- (UIView *)storeHeaderView
{
    if (!_storeHeaderView) {
        _storeHeaderView = self.storeHeaderViewController.view;
        
        CGRect superviewFrame = self.view.frame;
        
        CGRect frame = _storeHeaderView.frame;
        frame.size.width = superviewFrame.size.width;
        frame.size.height = superviewFrame.size.width * (1 / HEADER_RATIO);
        frame.origin.y = superviewFrame.size.height - (1 / HEADER_RATIO) * superviewFrame.size.width;
        frame.origin.x = 0;
        [_storeHeaderView setFrame:frame];
    }
    return _storeHeaderView;
}

- (UIView *)storePageView
{
    if (!_storePageView) {
        _storePageView  = self.storePageViewController.view;
        
        CGRect superviewFrame = self.view.frame;
        
        CGRect frame = _storePageView.frame;
        frame.size.width = superviewFrame.size.width;
        frame.size.height = superviewFrame.size.height - (1 / HEADER_RATIO) * superviewFrame.size.width;
        frame.origin.y = superviewFrame.size.height;
        frame.origin.x = 0;
        [_storePageView setFrame:frame];
    }
    return _storePageView;
}

#pragma mark - initial load

@synthesize couponFetchedResultsController = _couponFetchedResultsController;

- (NSFetchedResultsController *)couponFetchedResultsController
{
    if (!_couponFetchedResultsController) {
        _couponFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Store fetchRequestForCouponsOfStoreWithId:self.storeId]managedObjectContext:[[coubrDatabaseManager defaultManager] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    }
    return _couponFetchedResultsController;
}

- (void)loadStoreItem
{
    
    [[coubrRemoteManager defaultManager] loadStoreJSONWithStoreId:self.storeId completionHandler:^(NSDictionary *storeJSON) {
        
        if ([Store insertStoreIntoDatabaseFromStoreJSON:storeJSON]) {
   
            [self refreshCouponFetchedResultsController];
            
            NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
            [context performBlockAndWait:^{
                
                NSError *error;
                NSArray *results = [context executeFetchRequest:[Store fetchRequestForStoreWithId:self.storeId] error:&error];
                
                if (results > 0) {
                    _store = (Store *) [results firstObject];
                    [[NSNotificationCenter defaultCenter] postNotificationName:StoreDidBecomeAvailableNotification object:self];
                }
                
            }];

        
        } else {
            
            NSLog(@"Could not insert store into database");
            
        }
        
        
    } errorHandler:^(NSInteger errorCode) {
        NSLog(@"Could not load store from remote: %li", errorCode);
    }];

}

- (void)refreshCouponFetchedResultsController
{
 
    NSError *error;
    [self.couponFetchedResultsController performFetch:&error];
    if (!error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CouponFetchedResultsControllerDidUpdatedNotification object:self];
    }
    
}

#pragma mark - scroll view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect superviewFrame = self.view.frame;
    
    if (scrollView.contentOffset.y == 0) {
        
        if (![[scrollView subviews] containsObject:_storeMapView]) {
            [scrollView addSubview:self.storeMapView];
        }
        
    } else if (scrollView.contentOffset.y > superviewFrame.size.height - (1 / HEADER_RATIO) * superviewFrame.size.width - 16) {
        
        if ([[scrollView subviews] containsObject:_storeMapView]) {
            [self.storeMapView removeFromSuperview];
            self.storeMapView = nil;
            [self.storeMapViewController removeFromParentViewController];
            self.storeMapViewController = nil;
        }
        
    }
    
}

- (void)scrollToTop
{
    // scroll to top
    CGPoint topOffset = CGPointMake(0, 0);
    [self.storeScrollView setContentOffset:topOffset animated:YES];
}

- (void)scrollToBottom
{
    // scroll to bottom
    CGPoint bottomOffset = CGPointMake(0, self.storeScrollView.contentSize.height - self.storeScrollView.bounds.size.height);
    [self.storeScrollView setContentOffset:bottomOffset animated:YES];
}







@end

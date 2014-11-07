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

@property (strong, nonatomic) coubrStoreMapViewController *storeMapViewController;
@property (strong, nonatomic) coubrStoreHeaderViewController *storeHeaderViewController;
@property (strong, nonatomic) coubrStorePageViewController *storePageViewController;

@property (weak, nonatomic) UIView *storeMapView;
@property (weak, nonatomic) UIView *storeHeaderView;
@property (weak, nonatomic) UIView *storePageView;

@property (strong, nonatomic) UIPanGestureRecognizer *headerPanGestureRecognizer;

@property (nonatomic) BOOL notInit;

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

    if (!self.notInit) {
        [self initView];
    }
}

#pragma mark - init controllers

#define HEADER_HEIGHT 99

- (coubrStoreMapViewController *)storeMapViewController
{
    if (!_storeMapViewController) {
        _storeMapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreMapViewController"];
        [self addChildViewController:_storeMapViewController];
        [_storeMapViewController setParentController:self];
    }
    return _storeMapViewController;
}

- (coubrStoreHeaderViewController *)storeHeaderViewController
{
    if (!_storeHeaderViewController) {
        _storeHeaderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreHeaderViewController"];
        [self addChildViewController:_storeHeaderViewController];
        [_storeHeaderViewController setParentController:self];
    }
    return _storeHeaderViewController;
}

- (coubrStorePageViewController *)storePageViewController
{
    if (!_storePageViewController) {
        _storePageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStorePageViewController"];
        [self addChildViewController:_storePageViewController];
        [_storePageViewController setParentController:self];
    }
    return _storePageViewController;
}

#pragma mark - init views

- (void)initView
{
    [self.view addSubview:self.storePageView];
    [self.view addSubview:self.storeHeaderView];
    
    self.notInit = YES;
}

- (UIView *)storeMapView
{
    if (!_storeMapView) {
        _storeMapView = self.storeMapViewController.view;
        
        CGRect superviewFrame = self.view.frame;
        
        CGRect frame = _storeMapView.frame;
        frame.size.width = superviewFrame.size.width;
        frame.size.height = 0;
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
        frame.size.height = HEADER_HEIGHT;
        frame.origin.y = 0;
        frame.origin.x = 0;
        [_storeHeaderView setFrame:frame];
        [_storeHeaderView addGestureRecognizer:self.headerPanGestureRecognizer];
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
        frame.size.height = superviewFrame.size.height - HEADER_HEIGHT;
        frame.origin.y = HEADER_HEIGHT;
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

#pragma mark - Panning

- (UIPanGestureRecognizer *)headerPanGestureRecognizer
{
    if (!_headerPanGestureRecognizer) {
        _headerPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHeader:)];
    }
    return _headerPanGestureRecognizer;
}

- (void)panHeader:(UIPanGestureRecognizer *)gesture
{
    static CGPoint originalPoint;
    
    CGPoint translatedPoint = [gesture translationInView:self.view];
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        originalPoint = gesture.view.center;
        [self userDidStartPanningAtLocation:originalPoint];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint currentPoint = CGPointMake(originalPoint.x + translatedPoint.x, originalPoint.y + translatedPoint.y);
        [self userIsPanningFromLocation:originalPoint toLocation:currentPoint withTranslation:translatedPoint];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled)
    {
        CGPoint destination = CGPointMake(originalPoint.x + translatedPoint.x, originalPoint.y + translatedPoint.y);
        [self userDidFinishPanningFromLocation:originalPoint toLocation:destination];
    }
}

- (void)userDidStartPanningAtLocation:(CGPoint)location
{
    CGRect superviewFrame = self.view.frame;
    
    if (location.y < superviewFrame.size.height * 0.5) {
        // init map view
        [self.view addSubview:self.storeMapView];
    }
    
}

- (void)userIsPanningFromLocation:(CGPoint)origin toLocation:(CGPoint)destination withTranslation:(CGPoint)translation
{
    CGRect superviewFrame = self.view.frame;
    
    if (translation.y > 0) {
        // move down
        
        if (origin.y < superviewFrame.size.height * 0.5 && destination.y < (superviewFrame.size.height - HEADER_HEIGHT)) {
            // shows map view
            [self.storeMapView setFrame:CGRectMake(0, 0, superviewFrame.size.width, translation.y)];
            [self.storeHeaderView setFrame:CGRectMake(0, translation.y, superviewFrame.size.width, HEADER_HEIGHT)];
            [self.storePageView setFrame:CGRectMake(0, HEADER_HEIGHT + translation.y, superviewFrame.size.width, superviewFrame.size.height - HEADER_HEIGHT)];
            
            if (destination.y > HEADER_HEIGHT && destination.y < (superviewFrame.size.height - HEADER_HEIGHT)) {
                [self.storeMapViewController.locationButton setAlpha:destination.y / (superviewFrame.size.height - HEADER_HEIGHT)];
            } else if (destination.y > (superviewFrame.size.height - HEADER_HEIGHT)) {
                [self.storeMapViewController.locationButton setAlpha:1];
            }
            
        }
        
    } else {
        // move up
        
        if (origin.y >= superviewFrame.size.height * 0.5 && destination.y > HEADER_HEIGHT) {
            // shows table view
            [self.storeMapView setFrame:CGRectMake(0, 0, superviewFrame.size.width, superviewFrame.size.height - HEADER_HEIGHT + translation.y)];
            [self.storeHeaderView setFrame:CGRectMake(0, superviewFrame.size.height - HEADER_HEIGHT + translation.y, superviewFrame.size.width, HEADER_HEIGHT)];
            [self.storePageView setFrame:CGRectMake(0, superviewFrame.size.height + translation.y, superviewFrame.size.width, HEADER_HEIGHT - translation.y)];
            
            if (destination.y > HEADER_HEIGHT && destination.y < (superviewFrame.size.height - HEADER_HEIGHT)) {
                [self.storeMapViewController.locationButton setAlpha:destination.y / (superviewFrame.size.height - HEADER_HEIGHT)];
            } else if (destination.y < HEADER_HEIGHT) {
                [self.storeMapViewController.locationButton setAlpha:0];
            }
            

            
        }
        
    }
    
}

- (void)userDidFinishPanningFromLocation:(CGPoint)origin toLocation:(CGPoint)destination
{
    CGRect superviewFrame = self.view.frame;
    if (destination.y < superviewFrame.size.height * 0.5) {
        // shows table view
        
        // moved from bottom to top
        // moved from top to top
        [self.storeMapView setFrame:CGRectMake(0, 0, superviewFrame.size.width, 0)];
        [self.storeHeaderView setFrame:CGRectMake(0, 0, superviewFrame.size.width, HEADER_HEIGHT)];
        [self.storePageView setFrame:CGRectMake(0, HEADER_HEIGHT, superviewFrame.size.width, superviewFrame.size.height - HEADER_HEIGHT) ];

        [self.storeMapViewController.locationButton setAlpha:0];
        
    } else {
        // shows map view
        
        // moved from top to bottom
        // moved from bottom to bottom
        [self.storeMapView setFrame:CGRectMake(0, 0, superviewFrame.size.width, superviewFrame.size.height - HEADER_HEIGHT)];
        [self.storeHeaderView setFrame:CGRectMake(0, superviewFrame.size.height - HEADER_HEIGHT, superviewFrame.size.width, HEADER_HEIGHT)];
        [self.storePageView setFrame:CGRectMake(0, superviewFrame.size.height, superviewFrame.size.width, superviewFrame.size.height - HEADER_HEIGHT)];
        
        [self.storeMapViewController.locationButton setAlpha:1];
        
    }
    
}

@end

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

@interface coubrStoreViewController ()

@property (strong, nonatomic) coubrStoreMapViewController *storeMapViewController;
@property (strong, nonatomic) UIPageViewController *pageViewController;


@property (strong, nonatomic) coubrStoreHeaderViewController *storeHeaderViewController;
@property (strong, nonatomic) coubrStorePageViewController *storePageViewController;

@property (weak, nonatomic) UIView *storeMapView;
@property (weak, nonatomic) UIView *storeHeaderView;
@property (weak, nonatomic) UIView *storePageView;

@property (weak, nonatomic) Store *store;

@property (strong, nonatomic) UIBarButtonItem *favoritesBarButtonItem;

@property (strong, nonatomic) UIPanGestureRecognizer *headerPanGestureRecognizer;

@property (nonatomic) BOOL notInit;

@end

@implementation coubrStoreViewController

#pragma mark - view lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.storeMapViewController;
    self.storeHeaderViewController;
    self.storePageViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
#define TOPBAR_HEIGHT 64

- (coubrStoreMapViewController *)storeMapViewController
{
    if (!_storeMapViewController) {
        _storeMapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreMapViewController"];
        [self addChildViewController:_storeMapViewController];
    }
    return _storeMapViewController;
}

- (UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] init];
        [_pageViewController setDataSource:self];
        [_pageViewController setDelegate:self];
    }
    return _pageViewController;
}



- (coubrStoreHeaderViewController *)storeHeaderViewController
{
    if (!_storeHeaderViewController) {
        _storeHeaderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreHeaderViewController"];
//        [self addChildViewController:_storeHeaderViewController];
    }
    return _storeHeaderViewController;
}

- (coubrStorePageViewController *)storePageViewController
{
    if (!_storePageViewController) {
        _storePageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStorePageViewController"];
//        [self addChildViewController:_storePageViewController];
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
        
        CGRect frame = CGRectMake(0, 0, superviewFrame.size.width, TOPBAR_HEIGHT);
        [_storeMapView setFrame:frame];
    }
    return _storeMapView;
}

- (UIView *)storeHeaderView
{
    if (!_storeHeaderView) {
        _storeHeaderView = self.storeHeaderViewController.view;
        
        CGRect superviewFrame = self.view.frame;
        
        CGRect frame = CGRectMake(0, 0, superviewFrame.size.width, HEADER_HEIGHT + TOPBAR_HEIGHT);
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
        
        CGRect frame = CGRectMake(0, HEADER_HEIGHT + TOPBAR_HEIGHT, superviewFrame.size.width, superviewFrame.size.height - HEADER_HEIGHT);
        [_storePageView setFrame:frame];
    }
    return _storePageView;
}

#pragma mark - initial load

- (void)loadStoreItem
{
    
    [[coubrRemoteManager defaultManager] loadStoreJSONWithStoreId:self.storeId completionHandler:^(NSDictionary *storeJSON) {
        
        if ([Store insertStoreIntoDatabaseFromStoreJSON:storeJSON]) {
   
            NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
            [context performBlockAndWait:^{
                
                NSError *error;
                NSArray *results = [context executeFetchRequest:[Store fetchRequestForStoreWithId:self.storeId] error:&error];
                
                if (results > 0) {
                    Store *store = (Store *) [results firstObject];
                    NSDictionary *userInfo = @{ STORE: store, STORE_ID: store.storeId };
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:StoreDidBecomeAvailableNotification object:self userInfo:userInfo];
                    
                    [self.navigationItem setTitle:store.name];
                    [self setFavoritesBarButtonItemSelected:store.isFavorite];
                    self.store  = store;
                    
                }
                
            }];

        
        } else {
            
            NSLog(@"Could not insert store into database");
            
        }
        
        
    } errorHandler:^(NSInteger errorCode) {
        NSLog(@"Could not load store from remote: %li", errorCode);
    }];

}

#pragma mark - Page View Controller



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
    
    if (location.y < (superviewFrame.size.height * 0.5 + HEADER_HEIGHT)) {
        // init map view
        [self.view addSubview:self.storeMapView];
    }
    
}

- (void)userIsPanningFromLocation:(CGPoint)origin toLocation:(CGPoint)destination withTranslation:(CGPoint)translation
{
    CGRect superviewFrame = self.view.frame;
    
    if (translation.y > 0) {
        // move down
        
        if (origin.y < (superviewFrame.size.height * 0.5 + TOPBAR_HEIGHT) && destination.y < (superviewFrame.size.height - HEADER_HEIGHT)) {
            // shows map view
            [self.storeMapView setFrame:CGRectMake(0, 0, superviewFrame.size.width, TOPBAR_HEIGHT + translation.y)];
            [self.storeHeaderView setFrame:CGRectMake(0, TOPBAR_HEIGHT + translation.y, superviewFrame.size.width, HEADER_HEIGHT)];
            [self.storePageView setFrame:CGRectMake(0, HEADER_HEIGHT + TOPBAR_HEIGHT + translation.y, self.storePageView.bounds.size.width, self.storePageView.bounds.size.height)];
        }
        
    } else {
        // move up
        
        if (origin.y >= (superviewFrame.size.height * 0.5 + TOPBAR_HEIGHT) && destination.y > (HEADER_HEIGHT + TOPBAR_HEIGHT)) {
            // shows table view
            [self.storeMapView setFrame:CGRectMake(0, 0, superviewFrame.size.width, superviewFrame.size.height - HEADER_HEIGHT + translation.y)];
            [self.storeHeaderView setFrame:CGRectMake(0, superviewFrame.size.height - HEADER_HEIGHT + translation.y, superviewFrame.size.width, HEADER_HEIGHT)];
            [self.storePageView setFrame:CGRectMake(0, superviewFrame.size.height + translation.y, self.storePageView.bounds.size.width, self.storePageView.bounds.size.height)];
        }
        
    }
    
    if (destination.y < (HEADER_HEIGHT + TOPBAR_HEIGHT)) {
        [self.storeMapViewController.locationButton setAlpha:0];
    } else if (destination.y > (superviewFrame.size.height - HEADER_HEIGHT)) {
        [self.storeMapViewController.locationButton setAlpha:1];
    } else {
        [self.storeMapViewController.locationButton setAlpha:destination.y / (superviewFrame.size.height - HEADER_HEIGHT - TOPBAR_HEIGHT)];
    }
    
}

- (void)userDidFinishPanningFromLocation:(CGPoint)origin toLocation:(CGPoint)destination
{
    CGRect superviewFrame = self.view.frame;
    if (destination.y < (superviewFrame.size.height * 0.5 + TOPBAR_HEIGHT)) {
        // shows table view
        
        // moved from bottom to top
        // moved from top to top
        [self.storeMapView setFrame:CGRectMake(0, 0, superviewFrame.size.width, TOPBAR_HEIGHT)];
        [self.storeHeaderView setFrame:CGRectMake(0, 0, superviewFrame.size.width, HEADER_HEIGHT + TOPBAR_HEIGHT)];
        [self.storePageView setFrame:CGRectMake(0, HEADER_HEIGHT + TOPBAR_HEIGHT, self.storePageView.bounds.size.width, self.storePageView.bounds.size.height) ];

        [self.storeMapViewController.locationButton setAlpha:0];
        
    } else {
        // shows map view
        
        // moved from top to bottom
        // moved from bottom to bottom
        [self.storeMapView setFrame:CGRectMake(0, 0, superviewFrame.size.width, superviewFrame.size.height - HEADER_HEIGHT)];
        [self.storeHeaderView setFrame:CGRectMake(0, superviewFrame.size.height - HEADER_HEIGHT, superviewFrame.size.width, HEADER_HEIGHT)];
        [self.storePageView setFrame:CGRectMake(0, superviewFrame.size.height, self.storePageView.bounds.size.width, self.storePageView.bounds.size.height)];
        
        [self.storeMapViewController.locationButton setAlpha:1];
        
    }
    
}

#pragma mark - Favorites

- (void)setFavoritesBarButtonItemSelected:(BOOL)selected
{
    if (selected) {
        [self.favoritesBarButtonItem setImage:[[UIImage imageNamed:@"Nav_Bar_Favorites"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    } else {
        [self.favoritesBarButtonItem setImage:[[UIImage imageNamed:@"Nav_Bar_Favorites_None"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }
}


- (UIBarButtonItem *)favoritesBarButtonItem
{
    if (!_favoritesBarButtonItem) {
        _favoritesBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Nav_Bar_Favorites_None"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(toggleFavorite:)];
        [self.navigationItem setRightBarButtonItems:@[_favoritesBarButtonItem]];
    }
    return _favoritesBarButtonItem;
}

- (IBAction)toggleFavorite:(id)sender {
    
    [[[coubrDatabaseManager defaultManager] managedObjectContext ] performBlockAndWait:^{

        if ([self.store.isFavorite boolValue] == YES) {
            [self.store setIsFavorite:[NSNumber numberWithBool:NO]];
            [self setFavoritesBarButtonItemSelected:NO];
        } else {
            [self.store setIsFavorite:[NSNumber numberWithBool:YES]];
            [self setFavoritesBarButtonItemSelected:YES];
        }
        
    }];
    
}

@end

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
@property (weak, nonatomic) UIView *storeMapView;

@property (strong, nonatomic) coubrStoreHeaderViewController *storeHeaderViewController;
@property (strong, nonatomic) coubrStorePageViewController *storePageViewController;
@property (weak, nonatomic) UIView *storeHeaderView;
@property (weak, nonatomic) UIView *storePageView;

@property (weak, nonatomic) Store *store;

@property (strong, nonatomic) UIBarButtonItem *favoritesBarButtonItem;

@property (nonatomic) BOOL notInit;

@end

@implementation coubrStoreViewController

#pragma mark - view lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.storeMapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreMapViewController"];
    [self addChildViewController:_storeMapViewController];
    
    self.storeHeaderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreHeaderViewController"];
    [self addChildViewController:_storeHeaderViewController];
    
    self.storePageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStorePageViewController"];
    [self addChildViewController:_storePageViewController];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadStoreItem];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.notInit) {
        [self initView];
    }
}

#define HEADER_HEIGHT 99
#define TOPBAR_HEIGHT 64

#pragma mark - init views

- (void)initView
{
    [self.view addSubview:self.storeHeaderView];
    [self.view addSubview:self.storePageView];
    
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
        [_storeHeaderView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHeader:)]];
    }
    return _storeHeaderView;
}

- (UIView *)storePageView
{
    if (!_storePageView) {
        _storePageView  = self.storePageViewController.view;
        
        CGRect superviewFrame = self.view.frame;
        CGRect frame = CGRectMake(0, HEADER_HEIGHT + TOPBAR_HEIGHT, superviewFrame.size.width, superviewFrame.size.height - HEADER_HEIGHT - TOPBAR_HEIGHT);
        [_storePageView setFrame:frame];
    }
    return _storePageView;
}

#pragma mark - initial load

- (void)loadStoreItem
{
    NSString *storeId = [self.delegate.storeIds objectAtIndex:self.currentIndex];
    
    [[coubrRemoteManager defaultManager] loadStoreJSONWithStoreId:storeId completionHandler:^(NSDictionary *storeJSON) {
        
        if ([Store insertStoreIntoDatabaseFromStoreJSON:storeJSON]) {
   
            NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
            [context performBlockAndWait:^{
                
                NSError *error;
                NSArray *results = [context executeFetchRequest:[Store fetchRequestForStoreWithId:storeId] error:&error];
                
                if (results > 0) {
                    Store *store = (Store *) [results firstObject];
                    NSDictionary *userInfo = @{ STORE: store, STORE_ID: store.storeId };
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:StoreDidBecomeAvailableNotification object:self userInfo:userInfo];
                    
                    [self.navigationItem setTitle:store.name];
                    [self setFavoritesBarButtonItemSelected:[store.isFavorite boolValue]];
                    self.store  = store;
                    
                }
                
            }];

        
        } else {
            
            NSLog(@"Could not insert store into database");
            
        }
        
        
    } errorHandler:^(NSInteger errorCode) {
        NSLog(@"Could not load store from remote: %lu", errorCode);
    }];

}



#pragma mark - Panning

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
        
        if (origin.y < (superviewFrame.size.height * 0.5 + TOPBAR_HEIGHT)
            && destination.y > (TOPBAR_HEIGHT + HEADER_HEIGHT)
            && destination.y < (superviewFrame.size.height - HEADER_HEIGHT)) {
            // shows map view
            [self.storeMapView setFrame:CGRectMake(0, 0, superviewFrame.size.width, TOPBAR_HEIGHT + translation.y)];
            [self.storeHeaderView setFrame:CGRectMake(0, TOPBAR_HEIGHT + translation.y, superviewFrame.size.width, HEADER_HEIGHT)];
            [self.storePageView setFrame:CGRectMake(0, HEADER_HEIGHT + TOPBAR_HEIGHT + translation.y, self.storePageView.bounds.size.width, self.storePageView.bounds.size.height)];
        }
        
    } else {
        // move up
        
        if (origin.y >= (superviewFrame.size.height * 0.5 + TOPBAR_HEIGHT)
            && destination.y > (HEADER_HEIGHT + TOPBAR_HEIGHT)
            && destination.y < (superviewFrame.size.height - HEADER_HEIGHT)) {
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
    
    if (destination.x < origin.x) {
        // swipe left
        if (destination.y < (TOPBAR_HEIGHT + HEADER_HEIGHT) || destination.y > (superviewFrame.size.height - HEADER_HEIGHT)) {
            
            if (destination.x < (superviewFrame.size.width * 0.4) && (origin.x - destination.x) > (superviewFrame.size.width * 0.5)) {
                [self loadNextPage];
            }

        }
        
    }
    
    if (destination.x > origin.x) {
        // swipe right
        if (destination.y < (TOPBAR_HEIGHT + HEADER_HEIGHT) || destination.y > (superviewFrame.size.height - HEADER_HEIGHT)) {
            
            if (destination.x > (superviewFrame.size.width * 0.6) && (destination.x - origin.x) > (superviewFrame.size.width * 0.5)) {
                [self loadPreviousPage];
            }
            
        }
        
    }

    
    if (destination.y < (superviewFrame.size.height * 0.5 + TOPBAR_HEIGHT)) {
        // shows table view
        
        // moved from bottom to top
        // moved from top to top
        [self.storeMapView setFrame:CGRectMake(0, 0, superviewFrame.size.width, TOPBAR_HEIGHT)];
        [self.storeHeaderView setFrame:CGRectMake(0, 0, superviewFrame.size.width, HEADER_HEIGHT + TOPBAR_HEIGHT)];
        [self.storePageView setFrame:CGRectMake(0, HEADER_HEIGHT + TOPBAR_HEIGHT, self.storePageView.bounds.size.width, self.storePageView.bounds.size.height) ];

        [self.storeMapViewController showMapViewInFullscreen:NO];
        
    } else {
        // shows map view
        
        // moved from top to bottom
        // moved from bottom to bottom
        [self.storeMapView setFrame:CGRectMake(0, 0, superviewFrame.size.width, superviewFrame.size.height - HEADER_HEIGHT)];
        [self.storeHeaderView setFrame:CGRectMake(0, superviewFrame.size.height - HEADER_HEIGHT, superviewFrame.size.width, HEADER_HEIGHT)];
        [self.storePageView setFrame:CGRectMake(0, superviewFrame.size.height, self.storePageView.bounds.size.width, self.storePageView.bounds.size.height)];
        
        [self.storeMapViewController showMapViewInFullscreen:YES];
        
    }
    
}

#pragma mark - Swipe

- (void)loadPreviousPage
{
    
    if (self.currentIndex == 0) {
        [self.storeMapView setFrame:CGRectMake(32, self.storeMapView.bounds.origin.y, self.storeMapView.bounds.size.width, self.storeMapView.bounds.size.height)];
        [self.storeHeaderView setFrame:CGRectMake(32, self.storeHeaderView.bounds.origin.y, self.storeHeaderView.bounds.size.width, self.storeHeaderView.bounds.size.height)];
        [self.storePageView setFrame:CGRectMake(32, self.storePageView.bounds.origin.y, self.storePageView.bounds.size.width, self.storePageView.bounds.size.height)];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.storeMapView setFrame:CGRectMake(0, self.storeMapView.bounds.origin.y, self.storeMapView.bounds.size.width, self.storeMapView.bounds.size.height)];
            [self.storeHeaderView setFrame:CGRectMake(0, self.storeHeaderView.bounds.origin.y, self.storeHeaderView.bounds.size.width, self.storeHeaderView.bounds.size.height)];
            [self.storePageView setFrame:CGRectMake(0, self.storePageView.bounds.origin.y, self.storePageView.bounds.size.width, self.storePageView.bounds.size.height)];
        } completion:nil];
        
    }
    
    if ((self.currentIndex - 1) >= 0) {
        self.currentIndex = self.currentIndex - 1;
        [self loadStoreItem];
    }
    
}


- (void)loadNextPage
{
    
    if (self.currentIndex == (self.delegate.storeIds.count - 1)) {
        [self.storeMapView setFrame:CGRectMake(-32, self.storeMapView.bounds.origin.y, self.storeMapView.bounds.size.width, self.storeMapView.bounds.size.height)];
        [self.storeHeaderView setFrame:CGRectMake(-32, self.storeHeaderView.bounds.origin.y, self.storeHeaderView.bounds.size.width, self.storeHeaderView.bounds.size.height)];
        [self.storePageView setFrame:CGRectMake(-32, self.storePageView.bounds.origin.y, self.storePageView.bounds.size.width, self.storePageView.bounds.size.height)];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.storeMapView setFrame:CGRectMake(0, self.storeMapView.bounds.origin.y, self.storeMapView.bounds.size.width, self.storeMapView.bounds.size.height)];
            [self.storeHeaderView setFrame:CGRectMake(0, self.storeHeaderView.bounds.origin.y, self.storeHeaderView.bounds.size.width, self.storeHeaderView.bounds.size.height)];
            [self.storePageView setFrame:CGRectMake(0, self.storePageView.bounds.origin.y, self.storePageView.bounds.size.width, self.storePageView.bounds.size.height)];
        } completion:nil];
        
    }
    
    if ((self.currentIndex + 1) < self.delegate.storeIds.count) {
        self.currentIndex = self.currentIndex + 1;
        [self loadStoreItem];
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

#pragma mark - Shake Gesture

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        if (self.delegate.storeIds.count > 1) {
            NSInteger newIndex = self.currentIndex;
            
            while (newIndex == self.currentIndex){
                newIndex = arc4random() % self.delegate.storeIds.count;
            }
            self.currentIndex = newIndex;
            [self loadStoreItem];
        }
    }
}

@end

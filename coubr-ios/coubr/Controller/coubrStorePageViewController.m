//
//  coubrStorePageViewController.m
//  coubr
//
//  Created by Sebastian Hof on 22/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStorePageViewController.h"
#import "coubrStoreOverviewController.h"
#import "coubrStoreCouponTableViewController.h"
#import "coubrLocale.h"

@interface coubrStorePageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *leftPageLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentPageLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightPageLabel;


@property (strong, nonatomic) coubrStoreOverviewController *storeOverviewController;
@property (strong, nonatomic) coubrStoreCouponTableViewController *storeCouponTableViewController;

@end

@implementation coubrStorePageViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.leftPageLabel setText:@""];
    [self.currentPageLabel setText:LOCALE_STORE_NAV_COUPONS];
    [self.rightPageLabel setText:LOCALE_STORE_NAV_OVERVIEW];
}

- (coubrStoreOverviewController *)storeOverviewController
{
    if (!_storeOverviewController) {
        _storeOverviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreOverviewController"];
        [_storeOverviewController setParentController:self];
    }
    return _storeOverviewController;
}

- (coubrStoreCouponTableViewController *)storeCouponTableViewController
{
    if (!_storeCouponTableViewController) {
        _storeCouponTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreCouponTableViewController"];
        [_storeCouponTableViewController setParentController:self];
    }
    return _storeCouponTableViewController;
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedStorePageView"]) {
        
        if ([segue.destinationViewController isKindOfClass:[UIPageViewController class]]) {
            
            UIPageViewController *pvc = (UIPageViewController *)segue.destinationViewController;
            [pvc setDelegate:self];
            [pvc setDataSource:self];
            
            [pvc setViewControllers:@[ self.storeCouponTableViewController ] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }
        
    }
    
}

#pragma mark - Page View Controller Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if ([previousViewControllers containsObject:self.storeOverviewController] && completed) {

        [self.leftPageLabel setText:@""];
        [self.currentPageLabel setText:LOCALE_STORE_NAV_COUPONS];
        [self.rightPageLabel setText:LOCALE_STORE_NAV_OVERVIEW];
        
    } else if ([previousViewControllers containsObject:self.storeCouponTableViewController] && completed) {
        
        [self.leftPageLabel setText:LOCALE_STORE_NAV_COUPONS];
        [self.currentPageLabel setText:LOCALE_STORE_NAV_OVERVIEW];
        [self.rightPageLabel setText:@""];
   
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
 
    // TODO
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[coubrStoreOverviewController class]]) {
        return self.storeCouponTableViewController;
    } else if ([viewController isKindOfClass:[coubrStoreCouponTableViewController class]]) {
        return nil;
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[coubrStoreOverviewController class]]) {
        return nil;
    } else if ([viewController isKindOfClass:[coubrStoreCouponTableViewController class]]) {
        return self.storeOverviewController;
    }
    
    return nil;
}

@end

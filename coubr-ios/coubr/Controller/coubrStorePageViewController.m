//
//  coubrStorePageViewController.m
//  coubr
//
//  Created by Sebastian Hof on 19/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStorePageViewController.h"
#import "coubrStoreOverviewController.h"

@interface coubrStorePageViewController ()

@property (strong, nonatomic) coubrStoreOverviewController *storeOverviewController;

@end

@implementation coubrStorePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setDelegate:self];
    [self setDataSource:self];
    
    [self setViewControllers:@[ self.storeOverviewController ] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}


#pragma mark - Init

- (coubrStoreOverviewController *)storeOverviewController
{
    if (!_storeOverviewController) {
       _storeOverviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreOverviewController"];
    }
    return _storeOverviewController;
}

#pragma mark - Page View Controller Delegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[coubrStoreOverviewController class]]) {
        return nil;
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    if ([viewController isKindOfClass:[coubrStoreOverviewController class]]) {
        return nil;
    }
    
    return nil;
}



@end

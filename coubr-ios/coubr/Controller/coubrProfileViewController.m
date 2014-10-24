//
//  coubrProfileViewController.m
//  coubr
//
//  Created by Sebastian Hof on 20/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrProfileViewController.h"
#import "coubrFavoritesTableViewController.h"
#import "coubrHistoryTableViewController.h"
#import "coubrLocale.h"
#import "UIImage+ImageEffects.h"

@interface coubrProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *previousPageLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPageLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextPageLabel;


@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;

@property (strong, nonatomic) coubrFavoritesTableViewController *profileFavoritesTableViewController;
@property (strong, nonatomic) coubrHistoryTableViewController *profileHistoryTableViewController;

@end

@implementation coubrProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.previousPageLabel setText:@""];
    [self.currentPageLabel setText:LOCALE_PROFILE_NAV_FAVORITES];
    [self.nextPageLabel setText:LOCALE_PROFILE_NAV_VISITS];
    [self blurBackgroundImage];
}

#pragma mark - Init controllers

- (coubrFavoritesTableViewController *)profileFavoritesTableViewController
{
    if (!_profileFavoritesTableViewController) {
        _profileFavoritesTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrFavoritesTableViewController"];
        [_profileFavoritesTableViewController setParentController:self];
    }
    return _profileFavoritesTableViewController;
}

- (coubrHistoryTableViewController *)profileHistoryTableViewController
{
    if (!_profileHistoryTableViewController) {
        _profileHistoryTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrHistoryTableViewController"];
        [_profileHistoryTableViewController setParentController:self];
    }
    return _profileHistoryTableViewController;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedProfilePageView"]) {
        
        if ([segue.destinationViewController isKindOfClass:[UIPageViewController class]]) {
            
            UIPageViewController *pvc = (UIPageViewController *)segue.destinationViewController;
            
            [pvc setDelegate:self];
            [pvc setDataSource:self];
            [pvc setViewControllers:@[ self.profileFavoritesTableViewController ] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
        }
        
    }
    
}

#pragma mark - Page view controller delegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    if ([viewController isKindOfClass:[coubrHistoryTableViewController class]]) {
        return self.profileFavoritesTableViewController;
    } else if ([viewController isKindOfClass:[coubrFavoritesTableViewController class]]) {
        return nil;
    } else {
        return nil;
    }
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    if ([viewController isKindOfClass:[coubrHistoryTableViewController class]]) {
        return nil;
    } else if ([viewController isKindOfClass:[coubrFavoritesTableViewController class]]) {
        return self.profileHistoryTableViewController;
    } else {
        return nil;
    }
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
    if ([previousViewControllers containsObject:self.profileHistoryTableViewController] && completed) {
        
        [self.previousPageLabel setText:@""];
        [self.currentPageLabel setText:LOCALE_PROFILE_NAV_FAVORITES];
        [self.nextPageLabel setText:LOCALE_PROFILE_NAV_VISITS];
        
    } else if ([previousViewControllers containsObject:self.profileFavoritesTableViewController] && completed) {
        
        [self.previousPageLabel setText:LOCALE_PROFILE_NAV_FAVORITES];
        [self.currentPageLabel setText:LOCALE_PROFILE_NAV_VISITS];
        [self.nextPageLabel setText:@""];
        
    }

    
}

- (void)blurBackgroundImage
{
    UIGraphicsBeginImageContext(self.backgroundImageView.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.backgroundImageView.layer renderInContext:c];
    
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage = [viewImage applyLightEffect];
    
    UIGraphicsEndImageContext();
    
    [self.foregroundImageView setImage:viewImage];
}

@end

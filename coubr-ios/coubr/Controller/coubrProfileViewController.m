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

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;

@property (weak, nonatomic)UIPageViewController *pageViewController;

@property (weak, nonatomic) IBOutlet UIImageView *navigationImageView;

@property (strong, nonatomic) coubrFavoritesTableViewController *profileFavoritesTableViewController;
@property (strong, nonatomic) coubrHistoryTableViewController *profileHistoryTableViewController;

@end

@implementation coubrProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self blurBackgroundImage];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self blurNavigationImage];
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
            self.pageViewController = pvc;
            
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

- (void)blurNavigationImage
{
    UIGraphicsBeginImageContext(self.navigationImageView.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.view.layer renderInContext:c];
    
    UIImage* blurimage = UIGraphicsGetImageFromCurrentImageContext();
    
    blurimage = [blurimage applyExtraLightEffect];
    
    UIGraphicsEndImageContext();
    
    [self.navigationImageView setImage:blurimage];
    [self.navigationImageView.layer setShadowOffset:CGSizeMake(-2.0, 2.0)];
    [self.navigationImageView.layer setShadowRadius:3.0];
    [self.navigationImageView.layer setShadowOpacity:0.05];
}


- (void)blurBackgroundImage
{
    UIGraphicsBeginImageContext(self.backgroundImageView.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.backgroundImageView.layer renderInContext:c];
    
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage = [viewImage applyExtraLightEffect];
    
    UIGraphicsEndImageContext();
    
    [self.foregroundImageView setImage:viewImage];
    [self.foregroundImageView.layer setShadowOffset:CGSizeMake(-2.0, 2.0)];
    [self.foregroundImageView.layer setShadowRadius:3.0];
    [self.foregroundImageView.layer setShadowOpacity:0.05];
}

- (IBAction)showFavorites:(id)sender {

    if (![[self.pageViewController viewControllers] containsObject:self.profileFavoritesTableViewController]) {
        
        [self.pageViewController setViewControllers:@[ self.profileFavoritesTableViewController ] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        
    }

}


- (IBAction)showVisits:(id)sender {
    
    if (![[self.pageViewController viewControllers] containsObject:self.profileHistoryTableViewController]) {
        
        [self.pageViewController setViewControllers:@[ self.profileHistoryTableViewController ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
    }
    
}


@end

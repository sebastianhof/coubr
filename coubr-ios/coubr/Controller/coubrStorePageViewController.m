//
//  coubrStorePageViewController.m
//  coubr
//
//  Created by Sebastian Hof on 22/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreInformationTableViewController.h"
#import "coubrStoreOfferTableViewController.h"
#import "coubrLocale.h"

#import "UIImage+ImageEffects.h"

@interface coubrStorePageViewController ()

@property (weak, nonatomic) IBOutlet UIButton *ratingsButton;
@property (weak, nonatomic) IBOutlet UIButton *offersButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIImageView *navigationImageView;

@property (weak, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) coubrStoreInformationTableViewController *storeInformationTableViewController;
@property (strong, nonatomic) coubrStoreOfferTableViewController *storeOfferTableViewController;

@end

@implementation coubrStorePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self blurNavigationView];
}

- (coubrStoreInformationTableViewController *)storeInformationTableViewController
{
    if (!_storeInformationTableViewController) {
        _storeInformationTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreInformationTableViewController"];
        [_storeInformationTableViewController setParentController:self];
    }
    return _storeInformationTableViewController;
}

- (coubrStoreOfferTableViewController *)storeOfferTableViewController
{
    if (!_storeOfferTableViewController) {
        _storeOfferTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreOfferTableViewController"];
        [_storeOfferTableViewController setParentController:self];
    }
    return _storeOfferTableViewController;
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedStorePageView"]) {
        
        if ([segue.destinationViewController isKindOfClass:[UIPageViewController class]]) {
            
            UIPageViewController *pvc = (UIPageViewController *)segue.destinationViewController;
            [pvc setDelegate:self];
            [pvc setDataSource:self];
            
            [pvc setViewControllers:@[ self.storeOfferTableViewController ] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
            self.pageViewController = pvc;
        }
        
    }
    
}

#pragma mark - Page View Controller Delegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[coubrStoreInformationTableViewController class]]) {
        return nil;
    } else if ([viewController isKindOfClass:[coubrStoreOfferTableViewController class]]) {
        return self.storeInformationTableViewController;
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{

    if ([viewController isKindOfClass:[coubrStoreInformationTableViewController class]]) {
        return self.storeOfferTableViewController;
    } else if ([viewController isKindOfClass:[coubrStoreOfferTableViewController class]]) {
        return nil;
    }
    
    return nil;
}


- (IBAction)showRatings:(id)sender {
    [self resetHighlighted];
    [self.ratingsButton setHighlighted:YES];
}

- (IBAction)showInfos:(id)sender {
    [self resetHighlighted];
    [self.infoButton setHighlighted:YES];
    
    if (![[self.pageViewController viewControllers] containsObject:self.storeInformationTableViewController]) {
        
        [self.pageViewController setViewControllers:@[ self.storeInformationTableViewController ] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        
    }

}

- (IBAction)showOffers:(id)sender {
    [self resetHighlighted];
    [self.offersButton setHighlighted:YES];

    if (![[self.pageViewController viewControllers] containsObject:self.storeOfferTableViewController]) {
    
        [self.pageViewController setViewControllers:@[ self.storeOfferTableViewController ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
    }

    
}

- (void)resetHighlighted
{
    [self.ratingsButton setHighlighted:NO];
    [self.offersButton setHighlighted:NO];
    [self.infoButton setHighlighted:NO];
}

- (void)blurNavigationView {
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


@end

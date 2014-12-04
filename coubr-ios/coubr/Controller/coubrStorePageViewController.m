//
//  coubrStorePageViewController.m
//  coubr
//
//  Created by Sebastian Hof on 22/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStorePageViewController.h"
#import "coubrStoreViewController.h"

#import "coubrStoreInformationTableViewController.h"
#import "coubrStoreCouponTableViewController.h"
#import "coubrStoreStampCardTableViewController.h"
#import "coubrStoreSpecialOfferTableViewController.h"
#import "coubrStoreMenuTableViewController.h"

#import "coubrLocale.h"

#import "UIImage+ImageEffects.h"

@interface coubrStorePageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *navigationImageView;

@property (weak, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) coubrStoreInformationTableViewController *storeInformationTableViewController;
@property (strong, nonatomic) coubrStoreCouponTableViewController *storeCouponTableViewController;
@property (strong, nonatomic) coubrStoreStampCardTableViewController *storeStampCardTableViewController;
@property (strong, nonatomic) coubrStoreSpecialOfferTableViewController *storeSpecialOfferTableViewController;
@property (strong, nonatomic) coubrStoreMenuTableViewController *storeMenuTableViewController;

@property (weak, nonatomic) Store *store;
@property (weak, nonatomic) NSString *storeId;

@property (weak, nonatomic) IBOutlet UIButton *informationButton;
@property (weak, nonatomic) IBOutlet UIButton *specialOfferButton;
@property (weak, nonatomic) IBOutlet UIButton *stampCardButton;
@property (weak, nonatomic) IBOutlet UIButton *couponButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@end

@implementation coubrStorePageViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.storeInformationTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreInformationTableViewController"];
    self.storeCouponTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreCouponTableViewController"];
    self.storeStampCardTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreStampCardTableViewController"];
    self.storeSpecialOfferTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreSpecialOfferTableViewController"];
    self.storeMenuTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrStoreMenuTableViewController"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavigationView];
    [self initButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.pageViewController loadView];
}

#pragma mark - Init

- (void)initNavigationView
{
    [self.navigationImageView.layer setShadowOffset:CGSizeMake(-2.0, 2.0)];
    [self.navigationImageView.layer setShadowRadius:3.0];
    [self.navigationImageView.layer setShadowOpacity:0.05];
}

- (void)initButtons
{
    [self.informationButton setImage:[[UIImage imageNamed:@"Store_Info"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.informationButton setImage:[[UIImage imageNamed:@"Store_Info"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [self.specialOfferButton setImage:[[UIImage imageNamed:@"Store_SpecialOffer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.specialOfferButton setImage:[[UIImage imageNamed:@"Store_SpecialOffer"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [self.stampCardButton setImage:[[UIImage imageNamed:@"Store_StampCard"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.stampCardButton setImage:[[UIImage imageNamed:@"Store_StampCard"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [self.couponButton setImage:[[UIImage imageNamed:@"Store_Coupon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.couponButton setImage:[[UIImage imageNamed:@"Store_Coupon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [self.menuButton setImage:[[UIImage imageNamed:@"Store_Menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.menuButton setImage:[[UIImage imageNamed:@"Store_Menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"embedStorePageView"]) {
        
        if ([segue.destinationViewController isKindOfClass:[UIPageViewController class]]) {
            
            UIPageViewController *pvc = (UIPageViewController *)segue.destinationViewController;
            self.pageViewController = pvc;
            
            [pvc setDelegate:self];
            [pvc setDataSource:self];
            [pvc setViewControllers:@[ self.storeInformationTableViewController ] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
            [self.informationButton setSelected:YES];
        }
        
    }
    
}

#pragma mark - Page View Controller Delegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    if ([viewController isKindOfClass:[coubrStoreInformationTableViewController class]]) {
        return self.storeMenuTableViewController;
    } else if ([viewController isKindOfClass:[coubrStoreSpecialOfferTableViewController class]]) {
        return self.storeInformationTableViewController;
    } else if ([viewController isKindOfClass:[coubrStoreStampCardTableViewController class]]) {
            return self.storeSpecialOfferTableViewController;
    } else if ([viewController isKindOfClass:[coubrStoreCouponTableViewController class]]) {
        return self.storeStampCardTableViewController;
    } else if ([viewController isKindOfClass:[coubrStoreMenuTableViewController class]]) {
        return self.storeCouponTableViewController;
    }
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{

    if ([viewController isKindOfClass:[coubrStoreInformationTableViewController class]]) {
        return self.storeSpecialOfferTableViewController;
    } else if ([viewController isKindOfClass:[coubrStoreSpecialOfferTableViewController class]]) {
        return self.storeStampCardTableViewController;
    } else if ([viewController isKindOfClass:[coubrStoreStampCardTableViewController class]]) {
        return self.storeCouponTableViewController;
    } else if ([viewController isKindOfClass:[coubrStoreCouponTableViewController class]]) {
        return self.storeMenuTableViewController;
    } else if ([viewController isKindOfClass:[coubrStoreMenuTableViewController class]]) {
        return self.storeInformationTableViewController;
    }
    
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        [self resetButtons];
        
        if ([[self.pageViewController viewControllers] containsObject:self.storeInformationTableViewController]) {
            [self.informationButton setSelected:YES];
        } else if ([[self.pageViewController viewControllers] containsObject:self.storeSpecialOfferTableViewController]) {
            [self.specialOfferButton setSelected:YES];
        } else if ([[self.pageViewController viewControllers] containsObject:self.storeStampCardTableViewController]) {
            [self.stampCardButton setSelected:YES];
        } else if ([[self.pageViewController viewControllers] containsObject:self.storeCouponTableViewController]) {
            [self.couponButton setSelected:YES];
        } else if ([[self.pageViewController viewControllers] containsObject:self.storeMenuTableViewController]) {
            [self.menuButton setSelected:YES];
        }
    }
    
}


#pragma mark - IBAction

- (IBAction)showInformation:(id)sender {
    [self resetButtons];
    [self.informationButton setSelected:YES];
    
    if (![[self.pageViewController viewControllers] containsObject:self.storeInformationTableViewController]) {
        
        [self.pageViewController setViewControllers:@[ self.storeInformationTableViewController ] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        
    }
    
}

- (IBAction)showSpecialOffers:(id)sender {
    [self resetButtons];
    [self.specialOfferButton setSelected:YES];
    
    if (![[self.pageViewController viewControllers] containsObject:self.storeSpecialOfferTableViewController]) {
        
        if ([[self.pageViewController viewControllers] containsObject:self.storeInformationTableViewController]) {
            [self.pageViewController setViewControllers:@[ self.storeSpecialOfferTableViewController ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        } else {
            [self.pageViewController setViewControllers:@[ self.storeSpecialOfferTableViewController ] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        }

    }
}

- (IBAction)showStampCards:(id)sender {
    [self resetButtons];
    [self.stampCardButton setSelected:YES];
    
    if (![[self.pageViewController viewControllers] containsObject:self.storeStampCardTableViewController]) {
        
        if ([[self.pageViewController viewControllers] containsObject:self.storeInformationTableViewController] ||
            [[self.pageViewController viewControllers] containsObject:self.storeSpecialOfferTableViewController]) {
            [self.pageViewController setViewControllers:@[ self.storeStampCardTableViewController ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        } else {
            [self.pageViewController setViewControllers:@[ self.storeStampCardTableViewController ] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        }
 
    }
}

- (IBAction)showCoupons:(id)sender {
    [self resetButtons];
    [self.couponButton setSelected:YES];
    
    if (![[self.pageViewController viewControllers] containsObject:self.storeCouponTableViewController]) {

        if ([[self.pageViewController viewControllers] containsObject:self.storeInformationTableViewController] ||
            [[self.pageViewController viewControllers] containsObject:self.storeSpecialOfferTableViewController] ||
            [[self.pageViewController viewControllers] containsObject:self.storeStampCardTableViewController]) {
            [self.pageViewController setViewControllers:@[ self.storeCouponTableViewController ]
                                              direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        } else {
            [self.pageViewController setViewControllers:@[ self.storeCouponTableViewController ]
                                              direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        }
    
    }
}

- (IBAction)showMenu:(id)sender {
    [self resetButtons];
    [self.menuButton setSelected:YES];
    
    if (![[self.pageViewController viewControllers] containsObject:self.storeMenuTableViewController]) {
    
        [self.pageViewController setViewControllers:@[ self.storeMenuTableViewController ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
    }
    
}

- (void)resetButtons
{
    [self.informationButton setSelected:NO];
    [self.specialOfferButton setSelected:NO];
    [self.stampCardButton setSelected:NO];
    [self.couponButton setSelected:NO];
    [self.menuButton setSelected:NO];
}

@end

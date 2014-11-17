//
//  coubrMainViewController.m
//  coubr
//
//  Created by Sebastian Hof on 15.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import "coubrMainViewController.h"
#import "coubrNavigationTableViewController.h"

#import "UIImage+ImageEffects.h"

#import "coubrExploreViewController.h"

@interface coubrMainViewController()

@property (strong, nonatomic) coubrNavigationTableViewController *navigationViewController;
@property (weak, nonatomic) UIView *navigationView;
@property (strong, nonatomic) UIView *navigationBackgroundView;

@end

@implementation coubrMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self initTabBar];
}

# pragma mark - Navigation

- (coubrNavigationTableViewController *)navigationViewController
{
    if (!_navigationViewController) {
        _navigationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrNavigationTableViewController"];
        [self addChildViewController:_navigationViewController];
        [_navigationViewController setMainViewController:self];
    }
    return _navigationViewController;
}

- (UIView *)navigationView
{
    if (!_navigationView) {
        _navigationView = self.navigationViewController.view;
        CGRect superviewFrame = self.view.frame;

        CGRect frame = CGRectMake(0, 0, superviewFrame.size.width * 0.70, superviewFrame.size.height);
        [_navigationView setFrame:frame];
    }
    return _navigationView;
}

- (UIView *)navigationBackgroundView
{
    if (!_navigationBackgroundView) {
        CGRect superFrame = self.view.frame;
        CGRect frame = CGRectMake(0, 0, superFrame.size.width, superFrame.size.height);

        _navigationBackgroundView = [[UIView alloc] initWithFrame:frame];
        [_navigationBackgroundView setBackgroundColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:0.1]];
        [_navigationBackgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeNavigationViewInMainView)]];
    }
    return _navigationBackgroundView;
}

- (IBAction)toggleNavigationViewInMainView:(id)sender
{
    
    if ([self.view.subviews containsObject:_navigationView]) {
        // hide
        [self removeNavigationViewInMainView];
    } else {
        // show
        [self showNavigationViewInMainView];
    }
}

- (void)showNavigationViewInMainView
{
    if (![self.view.subviews containsObject:_navigationView]) {
        [self.view addSubview:self.navigationBackgroundView];
        [self.view addSubview:self.navigationView];
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:242.0/255.0 green:120.0/255.0 blue:75.0/255.0 alpha:1]];
    }
}

- (void)removeNavigationViewInMainView {
    if ([self.view.subviews containsObject:_navigationView]) {
        // hide
        [self.navigationBackgroundView removeFromSuperview];
        [self.navigationView removeFromSuperview];
        [self.navigationController removeFromParentViewController];
        _navigationBackgroundView = nil;
        _navigationView = nil;
        _navigationViewController = nil;
        
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]];
    }
}

# pragma mark - Navigation Bar

- (void)initNavigationBar
{
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton addTarget:self action:@selector(toggleNavigationViewInMainView:) forControlEvents:UIControlEventTouchUpInside];

    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"coubr" attributes:@{
                NSFontAttributeName: [UIFont fontWithName:@"Courgette" size:24],
                NSForegroundColorAttributeName: [UIColor colorWithRed:242.0/255.0 green:120.0/255.0 blue:75.0/255.0 alpha:1]}];
    [titleButton setAttributedTitle:title forState:UIControlStateNormal];
    
    self.navigationItem.titleView = titleButton;
    
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]];
}

- (void)initTabBar
{
    if ([self.tabBar.items objectAtIndex:0]) {
        UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
        [item setImage:[[UIImage imageNamed:@"Tab_Bar_Explore"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    
    if ([self.tabBar.items objectAtIndex:1]) {
         UITabBarItem *item = [self.tabBar.items objectAtIndex:1];
        [item setImage:[[UIImage imageNamed:@"Tab_Bar_Profile"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }

}

@end

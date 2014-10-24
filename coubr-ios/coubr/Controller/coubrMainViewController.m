//
//  coubrMainViewController.m
//  coubr
//
//  Created by Sebastian Hof on 15.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrMainViewController.h"
#import "coubrNavigationViewController.h"
#import "coubrSettingsTableViewController.h"
#import "coubrProfileViewController.h"

#import "UIImage+ImageEffects.h"

#import "coubrExploreViewController.h"

@interface coubrMainViewController()

@property (strong, nonatomic) coubrNavigationViewController *navigationViewController;
@property (weak, nonatomic) UIView *navigationView;

@property (strong, nonatomic) coubrExploreViewController *exploreViewController;
@property (weak, nonatomic) UIView *exploreView;

@property (strong, nonatomic) coubrSettingsTableViewController *settingsViewController;
@property (weak, nonatomic) UIView *settingsView;

@property (strong, nonatomic) coubrProfileViewController *profileViewController;
@property (weak, nonatomic) UIView *profileView;

@end

@implementation coubrMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self showExploreViewInMainView];
}

- (coubrNavigationViewController *)navigationViewController
{
    if (!_navigationViewController) {
        _navigationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrNavigationViewController"];
        [self addChildViewController:_navigationViewController];
    }
    return _navigationViewController;
}

- (UIView *)navigationView
{
    if (!_navigationView) {
        
        _navigationView = self.navigationViewController.view;
  
        CGRect frame = self.view.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.height = 100;
        [_navigationView setFrame:frame];
        
    }
    return _navigationView;
}

- (coubrExploreViewController *)exploreViewController
{
    if (!_exploreViewController) {
        _exploreViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrExploreViewController"];
        [self addChildViewController:_exploreViewController];
    }
    return _exploreViewController;
}

- (UIView *)exploreView
{
    if (!_exploreView) {
        
        _exploreView  = self.exploreViewController.view;
        
        CGRect superviewFrame = self.view.frame;
        
        CGRect frame = _exploreView.frame;
        frame.size.width = superviewFrame.size.width;
        frame.size.height = superviewFrame.size.height;
        frame.origin.y = 0;
        frame.origin.x = 0;
        [_exploreView setFrame:frame];
    }
    return _exploreView;
}

- (coubrSettingsTableViewController *)settingsViewController
{
    if (!_settingsViewController) {
        _settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrSettingsTableViewController"];
        [self addChildViewController:_settingsViewController];
    }
    return _settingsViewController;
}

- (UIView *)settingsView
{
    if (!_settingsView) {
        _settingsView = self.settingsViewController.view;
        
        CGRect superviewFrame = self.view.frame;
        
        CGRect frame = _settingsView.frame;
        frame.size.width = superviewFrame.size.width;
        frame.size.height = superviewFrame.size.height;
        frame.origin.y = 0;
        frame.origin.x = 0;
        [_settingsView setFrame:frame];
    }
    return _settingsView;
}

- (coubrProfileViewController *)profileViewController
{
    if (!_profileViewController) {
        _profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrProfileViewController"];
        [self addChildViewController:_profileViewController];
    }
    return _profileViewController;
}

- (UIView *)profileView
{
    if (!_profileView) {
        _profileView = self.profileViewController.view;
        
        CGRect superviewFrame = self.view.frame;
        
        CGRect frame = _profileView.frame;
        frame.size.width = superviewFrame.size.width;
        frame.size.height = superviewFrame.size.height;
        frame.origin.y = 0;
        frame.origin.x = 0;
        [_profileView setFrame:frame];
    }
    return _profileView;
}


#pragma mark - coubrNavigationView Delegate

- (void)hideNavigationViewInMainView
{
    if ([self.view.subviews containsObject:_navigationView]) {

        [self.navigationView removeFromSuperview];

    }
}

- (void)showNavigationViewInMainView
{
    if (![self.view.subviews containsObject:_navigationView]) {

        [self.view addSubview:self.navigationView];
        
    }
}

- (void)showViewInMainViewWithIdentifier:(UIView *)view
{
    [self hideNavigationViewInMainView];

    if ([[self.view subviews] containsObject:view]) {
        // currently shown
        return;
    }
    
    if ([[self.view subviews] containsObject:_settingsView]) {
        // remove settings view
        [self.settingsView removeFromSuperview];
        
        // set settings view + controller to nil as they are not often used
        self.settingsView = nil;
        self.settingsViewController = nil;
        
    } else if ([[self.view subviews] containsObject:_exploreView]) {
        // remove explore view
        [self.exploreView removeFromSuperview];
    } else if ([[self.view subviews] containsObject:_profileView]) {
        [self.profileView removeFromSuperview];
    }
        
    // add to view
    [self.view addSubview:view];
}

- (void)showSettingsViewInMainView
{
    [self showViewInMainViewWithIdentifier:self.settingsView];
}

- (void)showProfileViewInMainView
{
    [self showViewInMainViewWithIdentifier:self.profileView];
}

- (void)showExploreViewInMainView
{
    [self showViewInMainViewWithIdentifier:self.exploreView];
}

- (IBAction)toggleNavigationViewInMainView:(id)sender {
    
    if ([self.view.subviews containsObject:_navigationView]) {
        // hide
        [self hideNavigationViewInMainView];
    } else {
        // show
        [self showNavigationViewInMainView];
    }
    
}

# pragma mark - Navigation Bar

- (void)initNavigationBar
{
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton addTarget:self action:@selector(toggleNavigationViewInMainView:) forControlEvents:UIControlEventTouchUpInside];

    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"coubr" attributes:@{
                NSFontAttributeName: [UIFont fontWithName:@"Courgette" size:24]}];
    
    [titleButton setAttributedTitle:title forState:UIControlStateNormal];
    self.navigationItem.titleView = titleButton;
}

@end

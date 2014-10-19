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
#import "coubrHistoryViewController.h"

#import "UIImage+ImageEffects.h"

#import "coubrExploreViewController.h"

@interface coubrMainViewController()

@property (strong, nonatomic) coubrNavigationViewController *navigationViewController;
@property (weak, nonatomic) UIView *navigationView;

@property (strong, nonatomic) coubrExploreViewController *exploreViewController;
@property (weak, nonatomic) UIView *exploreView;

@property (strong, nonatomic) coubrSettingsTableViewController *settingsViewController;
@property (weak, nonatomic) UIView *settingsView;

@property (strong, nonatomic) coubrHistoryViewController *historyViewController;
@property (weak, nonatomic) UIView *historyView;

@end

@implementation coubrMainViewController

- (void)viewDidLoad {
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

- (coubrHistoryViewController *)historyViewController
{
    if (!_historyViewController) {
        _historyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"coubrHistoryViewController"];
        [self addChildViewController:_historyViewController];
    }
    return _historyViewController;
}

- (UIView *)historyView
{
    if (!_historyView) {
        _historyView = self.historyViewController.view;
        
        CGRect superviewFrame = self.view.frame;
        
        CGRect frame = _historyView.frame;
        frame.size.width = superviewFrame.size.width;
        frame.size.height = superviewFrame.size.height;
        frame.origin.y = 0;
        frame.origin.x = 0;
        [_historyView setFrame:frame];
    }
    return _historyView;
}


#pragma mark - coubrNavigationView Delegate

- (void)hideNavigationViewInMainView
{
    if ([self.view.subviews containsObject:self.navigationView]) {
        
        // TODO animations
        [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionTransitionNone animations:^{
            [self.navigationView removeFromSuperview];
        } completion:nil];
    }
}

- (void)showNavigationViewInMainView
{
    if (![self.view.subviews containsObject:self.navigationView]) {
        
        // TODO animations
        [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionTransitionNone animations:^{
            [self.view addSubview:self.navigationView];
        } completion:nil];
        
    }
}

- (void)showViewInMainViewWithIdentifier:(UIView *)view
{
    [self hideNavigationViewInMainView];

    if ([[self.view subviews] containsObject:view]) {
        // currently shown
        return;
    }
    
    if ([[self.view subviews] containsObject:self.settingsView]) {
        // remove settings view
        [self.settingsView removeFromSuperview];
        
        // set settings view + controller to nil as they are not often used
        self.settingsView = nil;
        self.settingsViewController = nil;
        
    } else if ([[self.view subviews] containsObject:self.exploreView]) {
        // remove explore view
        [self.exploreView removeFromSuperview];
    } else if ([[self.view subviews] containsObject:self.historyView]) {
        [self.historyView removeFromSuperview];
    }
        
    // add to view
    [self.view addSubview:view];
}

- (void)showSettingsViewInMainView
{
    [self showViewInMainViewWithIdentifier:self.settingsView];
}

- (void)showHistoryViewInMainView
{
    [self showViewInMainViewWithIdentifier:self.historyView];
}

- (void)showExploreViewInMainView
{
    [self showViewInMainViewWithIdentifier:self.exploreView];
}

- (IBAction)toggleNavigationViewInMainView:(id)sender {
    
    if ([self.view.subviews containsObject:self.navigationView]) {
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
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:242 green:120 blue:75 alpha:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:51 green:51 blue:51 alpha:1]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton addTarget:self action:@selector(toggleNavigationViewInMainView:) forControlEvents:UIControlEventTouchUpInside];

    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"coubr" attributes:@{
                NSFontAttributeName: [UIFont fontWithName:@"Courgette" size:24]}];
    
    [titleButton setAttributedTitle:title forState:UIControlStateNormal];
    self.navigationItem.titleView = titleButton;
}

@end

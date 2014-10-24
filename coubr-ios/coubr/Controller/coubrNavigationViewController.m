//
//  coubrNavigationViewController.m
//  coubr
//
//  Created by Sebastian Hof on 17/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrNavigationViewDelegate.h"
#import "coubrNavigationViewController.h"

@interface coubrNavigationViewController ()

@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation coubrNavigationViewController

- (IBAction)showProfileViewInMainView:(id)sender {
    if ([self.parentViewController conformsToProtocol:@protocol(coubrNavigationViewDelegate)]) {
        [self.parentViewController performSelector:@selector(showProfileViewInMainView)];
    }
}

- (IBAction)showExploreViewInMainView:(id)sender {
    if ([self.parentViewController conformsToProtocol:@protocol(coubrNavigationViewDelegate)]) {
        [self.parentViewController performSelector:@selector(showExploreViewInMainView)];
    }
}

- (IBAction)showSettingsViewInMainView:(id)sender {
    if ([self.parentViewController conformsToProtocol:@protocol(coubrNavigationViewDelegate)]) {
        [self.parentViewController performSelector:@selector(showSettingsViewInMainView)];
    }
}

- (IBAction)hideNavigationViewInMainView:(id)sender {
    if ([self.parentViewController conformsToProtocol:@protocol(coubrNavigationViewDelegate)]) {
        [self.parentViewController performSelector:@selector(hideNavigationViewInMainView)];
    }
}

@end

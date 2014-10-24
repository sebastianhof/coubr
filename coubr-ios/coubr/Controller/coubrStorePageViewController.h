//
//  coubrStorePageViewController.h
//  coubr
//
//  Created by Sebastian Hof on 22/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coubrStoreViewController.h"

@interface coubrStorePageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (weak, nonatomic) coubrStoreViewController *parentController;

@end

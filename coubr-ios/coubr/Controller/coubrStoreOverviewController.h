//
//  coubrStoreOverviewController.h
//  coubr
//
//  Created by Sebastian Hof on 19/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "coubrStorePageViewController.h"
#import "Store.h"

@interface coubrStoreOverviewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) coubrStorePageViewController *parentController;

@end

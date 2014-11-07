//
//  coubrNavigationTableViewController.h
//  coubr
//
//  Created by Sebastian Hof on 18/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "coubrMainViewController.h"

@interface coubrNavigationTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) coubrMainViewController *parentController;

@end

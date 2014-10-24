//
//  coubrFavoritesTableViewController.h
//  coubr
//
//  Created by Sebastian Hof on 20/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coubrProfileViewController.h"

@interface coubrFavoritesTableViewController : UITableViewController

@property (weak, nonatomic) coubrProfileViewController *parentController;

@end

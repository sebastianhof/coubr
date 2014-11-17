//
//  coubrFavoritesTableViewCell.h
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"
#import "coubrFavoritesTableViewController.h"

@interface coubrFavoritesTableViewCell : UITableViewCell

- (void)initCellWithStore:(Store *)store;

@property (weak, nonatomic) coubrFavoritesTableViewController *parentController;

@end

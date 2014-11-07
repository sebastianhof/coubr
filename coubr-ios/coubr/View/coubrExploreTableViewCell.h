//
//  coubrExploreTableViewCell.h
//  coubr
//
//  Created by Sebastian Hof on 16.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "Explore.h"
#import <UIKit/UIKit.h>
#import "coubrExploreTableViewController.h"

@interface coubrExploreTableViewCell : UITableViewCell

- (void)initCellWithExplore:(Explore *)explore;

@property (weak, nonatomic) coubrExploreTableViewController *parentController;

@end

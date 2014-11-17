//
//  coubrStampCardTableViewCell.h
//  coubr
//
//  Created by Sebastian Hof on 08/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coubrStoreStampCardTableViewController.h"
#import "StampCard.h"

@interface coubrStampCardTableViewCell : UITableViewCell

@property (weak, nonatomic) coubrStoreStampCardTableViewController *parentController;

- (void)initCellWithStampCard:(StampCard *)stampCard;

@end

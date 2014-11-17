//
//  coubrSpecialOfferTableViewCell.h
//  coubr
//
//  Created by Sebastian Hof on 08/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coubrStoreSpecialOfferTableViewController.h"
#import "SpecialOffer.h"

@interface coubrSpecialOfferTableViewCell : UITableViewCell

@property (weak, nonatomic) coubrStoreSpecialOfferTableViewController *parentController;

- (void)initCellWithSpecialOffer:(SpecialOffer *)specialOffer;

@end

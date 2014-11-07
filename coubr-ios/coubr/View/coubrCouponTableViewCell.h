//
//  coubrCouponTableViewCell.h
//  coubr
//
//  Created by Sebastian Hof on 07/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"
#import "coubrStoreOfferTableViewController.h"

@interface coubrCouponTableViewCell : UITableViewCell

@property (weak, nonatomic) coubrStoreOfferTableViewController *parentController;

- (void)initCellWithCoupon:(Coupon *)coupon;


@end

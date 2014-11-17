//
//  coubrCouponTableViewCell.h
//  coubr
//
//  Created by Sebastian Hof on 07/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"
#import "coubrStoreCouponTableViewController.h"

@interface coubrCouponTableViewCell : UITableViewCell

@property (weak, nonatomic) coubrStoreCouponTableViewController *parentController;

- (void)initCellWithCoupon:(Coupon *)coupon;

@end

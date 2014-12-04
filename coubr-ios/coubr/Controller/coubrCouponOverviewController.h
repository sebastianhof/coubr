//
//  coubrCouponOverviewController.h
//  coubr
//
//  Created by Sebastian Hof on 19/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"
#import "coubrQRScanDelegate.h"

@interface coubrCouponOverviewController : UITableViewController <UIAlertViewDelegate, coubrQRScanDelegate>

@property (nonatomic, weak) Coupon *coupon;

@end

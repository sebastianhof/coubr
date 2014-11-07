//
//  coubrCouponOverviewController.h
//  coubr
//
//  Created by Sebastian Hof on 19/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"

#define ModalViewDidDismissedNotification @"ModalViewDidDismissedNotification"

@interface coubrCouponOverviewController : UIViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) Coupon *coupon;

- (void)willRedeemWithCode:(NSString *)code;

- (void)didFailToRedeem;

@end

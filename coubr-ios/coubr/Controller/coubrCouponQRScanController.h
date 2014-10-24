//
//  coubrCouponQRScanController.h
//  coubr
//
//  Created by Sebastian Hof on 20/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "coubrCouponOverviewController.h"

@interface coubrCouponQRScanController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) coubrCouponOverviewController *parentController;

@end

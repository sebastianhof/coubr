//
//  coubrQRScanController.h
//  coubr
//
//  Created by Sebastian Hof on 20/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "coubrCouponOverviewController.h"
#import "coubrQRScanDelegate.h"

@interface coubrQRScanController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, weak) id <coubrQRScanDelegate> delegate;

@end

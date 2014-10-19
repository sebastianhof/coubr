//
//  coubrLocationManager.h
//  coubr
//
//  Created by Sebastian Hof on 16.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

#define Location @"Location"
#define LocationDidBecomeAvailableNotification @"LocationDidBecomeAvailable"
#define LocationDidFailNotification @"LocationDidFailNotification"

@interface coubrLocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, atomic, readonly) CLLocation *lastLocation;

+ (instancetype)defaultManager;

- (void)updateLocation;

@end

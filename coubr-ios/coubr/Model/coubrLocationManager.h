//
//  coubrLocationManager.h
//  coubr
//
//  Created by Sebastian Hof on 16.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

#define UserLocation @"Location"
#define UserLocationDidBecomeAvailableNotification @"LocationDidBecomeAvailable"
#define UserLocationDidFailNotification @"LocationDidFailNotification"

@interface coubrLocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, atomic, readonly) CLLocation *userLocation;

+ (instancetype)defaultManager;

- (void)updateUserLocation;

- (void)requestAuthorization;

@end

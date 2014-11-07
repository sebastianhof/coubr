//
//  coubrLocationManager.m
//  coubr
//
//  Created by Sebastian Hof on 16.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrLocationManager.h"
#import <UIKit/UIKit.h>

@interface coubrLocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation coubrLocationManager

static coubrLocationManager *locationManagerInstance = nil;

+ (instancetype)defaultManager
{
    if (!locationManagerInstance)
    {
        locationManagerInstance = [[self alloc] init];
    }
    return locationManagerInstance;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [_locationManager setDelegate:self];
    }
    return _locationManager;
}

- (void)setUserLocation:(CLLocation *)userLocation
{
    _userLocation = userLocation;
}

- (void)updateUserLocation
{
    [self requestAuthorization];
    [self.locationManager startUpdatingLocation];
    [self setUserLocation:self.locationManager.location];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    
    // error handling
    NSLog(@"Location Manager did fail with error: %@", [error localizedDescription]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UserLocationDidFailNotification object:self];
    
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    
    // error handling
    NSLog(@"Location Manager did fail with error: %@", [error localizedDescription]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UserLocationDidFailNotification object:self];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    
    self.userLocation = [locations lastObject];

    NSDictionary *userInfo =  @{ UserLocation: self.userLocation };
    [[NSNotificationCenter defaultCenter] postNotificationName:UserLocationDidBecomeAvailableNotification object:self userInfo:userInfo];
    
}

- (void)requestAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusDenied) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location services denied"
                                                            message:@"Coubr requires location services to determine the current location"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
        
    } else if (status ==  kCLAuthorizationStatusRestricted) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location services restricted"
                                                            message:@"Coubr requires location services to determine the current location"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];

    } else if (status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
    }

}


@end

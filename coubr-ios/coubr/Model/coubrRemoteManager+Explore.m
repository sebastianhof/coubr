//
//  coubrRemoteManager+Explore.m
//  coubr
//
//  Created by Sebastian Hof on 18/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrRemoteManager+Explore.h"
#import <CoreLocation/CoreLocation.h>

#import "coubrLocationManager.h"
#import "coubrConstants.h"

@implementation coubrRemoteManager (Explore)

- (void)loadExploreJSONWithinDistance:(double)distance
                    completionHandler:(void (^)(NSDictionary *))onCompletion
                         errorHandler:(void(^)())onError
{
    
    // Prepare JSON Data
    
    // Assert location did become available
    CLLocationCoordinate2D coordinate = [[coubrLocationManager defaultManager] lastLocation].coordinate;
    
    NSString *lt = [NSString stringWithFormat:@"%f",coordinate.latitude];
    NSString *lg = [NSString stringWithFormat:@"%f",coordinate.longitude];
    NSString *d = [NSString stringWithFormat:@"%f",distance];
    
    NSDictionary *requestData = @{ @"lt": lt , @"lg": lg, @"d": d };
    NSError *error;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:&error];
    if (error) {
        NSLog(@"Could not create request data for remote: %@", error.localizedDescription);
        onError(nil);
        return;
    }
    
    [self loadJSONFromRemoteWithRequestJSONData:JSONData andURLString:EXPLORE_URL completionHandler:onCompletion errorHandler:onError];
    
}

@end

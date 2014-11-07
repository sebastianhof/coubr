//
//  coubrRemoteManager+Explore.m
//  coubr
//
//  Created by Sebastian Hof on 18/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrRemoteManager+Explore.h"
#import "coubrLocationManager.h"
#import "coubrConstants.h"

@implementation coubrRemoteManager (Explore)

- (void)loadExploreJSONAtLatitude:(double)latitude longitude:(double)longitude distance:(double)distance
completionHandler:(void (^)(NSDictionary *))onCompletion
errorHandler:(void(^)(NSInteger))onError;
{

    // Prepare JSON Data
    NSString *lt = [NSString stringWithFormat:@"%f",latitude];
    NSString *lg = [NSString stringWithFormat:@"%f",longitude];
    NSString *d = [NSString stringWithFormat:@"%f",distance];
    
    NSDictionary *requestData = @{ @"lt": lt , @"lg": lg, @"d": d };
    NSError *error;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:&error];
    if (error) {
        onError(JSON_ERROR);
        return;
    }
    
    [self loadJSONFromRemoteWithRequestJSONData:JSONData andURL:[NSURL URLWithString:EXPLORE_URL] completionHandler:onCompletion errorHandler:onError];
    
}

@end

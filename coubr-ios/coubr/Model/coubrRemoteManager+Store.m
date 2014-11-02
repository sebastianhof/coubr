//
//  coubrRemoteManager+Store.m
//  coubr
//
//  Created by Sebastian Hof on 19/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrRemoteManager+Store.h"
#import "coubrConstants.h"
#import <UIKit/UIDevice.h>

@implementation coubrRemoteManager (Store)

- (void)loadStoreJSONWithStoreId:(NSString *)storeId
               completionHandler:(void (^)(NSDictionary *))onCompletion
                    errorHandler:(void(^)(NSInteger))onError {
    
    // Prepare JSON Data
    NSString *id = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSDictionary *requestData = @{ @"id": id };
    NSError *error;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:&error];
    if (error) {
        onError(JSON_ERROR);
        return;
    }
    
    NSURL *url = [NSURL URLWithString:STORE_BASE_URL];
    url = [url URLByAppendingPathComponent:storeId];
    
    [self loadJSONFromRemoteWithRequestJSONData:JSONData andURL:url completionHandler:onCompletion errorHandler:onError];
    
}

@end

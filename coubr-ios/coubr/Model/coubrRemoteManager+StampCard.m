//
//  coubrRemoteManager+StampCard.m
//  coubr
//
//  Created by Sebastian Hof on 22/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrRemoteManager+StampCard.h"
#import "coubrConstants.h"
#import <UIKit/UIDevice.h>

@implementation coubrRemoteManager (StampCard)

- (void)stampStampCardWithStampCardId:(NSString *)stampCardId storeId:(NSString *)storeId andStoreCode:(NSString *)storeCode completionHandler:(void (^)())onCompletion errorHandler:(void (^)(NSInteger))onError
{
 
    // Prepare JSON Data
    
    // Assert location did become available
    NSString *si = storeId;
    NSString *sc = storeCode;
    NSString *id = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSDictionary *requestData = @{ @"si": si , @"sc": sc, @"id": id };
    NSError *error;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:&error];
    if (error) {
        onError(JSON_ERROR);
        return;
    }
    
    NSURL *url = [NSURL URLWithString:STAMP_CARD_BASE_URL];
    url = [url URLByAppendingPathComponent:stampCardId];
    url = [url URLByAppendingPathComponent:STAMP_CARD_STAMP_URL];
    
    [self loadJSONFromRemoteWithRequestJSONData:JSONData andURL:url completionHandler:onCompletion errorHandler:onError];
    
}

@end

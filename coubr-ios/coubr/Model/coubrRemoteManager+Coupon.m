//
//  coubrRemoteManager+Coupon.m
//  coubr
//
//  Created by Sebastian Hof on 22/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrRemoteManager+Coupon.h"
#import "coubrConstants.h"

@implementation coubrRemoteManager (Coupon)

- (void)redeemCouponWithCouponId:(NSString *)couponId storeId:(NSString *)storeId andStoreCode:(NSString *)storeCode completionHandler:(void (^)())onCompletion errorHandler:(void (^)(NSInteger))onError {
    
    // Prepare JSON Data
    
    // Assert location did become available
    NSString *si = storeId;
    NSString *sc = storeCode;
    
    NSDictionary *requestData = @{ @"si": si , @"sc": sc };
    NSError *error;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:&error];
    if (error) {
        onError(JSON_ERROR);
        return;
    }
    
    NSURL *url = [NSURL URLWithString:COUPON_BASE_URL];
    url = [url URLByAppendingPathComponent:couponId];
    url = [url URLByAppendingPathComponent:COUPON_REDEEM_URL];
    
    [self loadJSONFromRemoteWithRequestJSONData:JSONData andURL:url completionHandler:onCompletion errorHandler:onError];
    
}

@end

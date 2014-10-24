//
//  coubrRemoteManager+Coupon.h
//  coubr
//
//  Created by Sebastian Hof on 22/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrRemoteManager.h"

@interface coubrRemoteManager (Coupon)

- (void)redeemCouponWithCouponId:(NSString *)couponId   storeId:(NSString *)storeId  andStoreCode:(NSString *)storeCode
              completionHandler:(void (^)())onCompletion
                   errorHandler:(void (^)(NSInteger))onError;

@end

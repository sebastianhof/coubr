//
//  coubrRemoteManager+StampCard.h
//  coubr
//
//  Created by Sebastian Hof on 22/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrRemoteManager.h"

@interface coubrRemoteManager (StampCard)

- (void)stampStampCardWithStampCardId:(NSString *)stampCardId storeId:(NSString *)storeId  andStoreCode:(NSString *)storeCode
               completionHandler:(void (^)())onCompletion
                    errorHandler:(void (^)(NSInteger))onError;

@end

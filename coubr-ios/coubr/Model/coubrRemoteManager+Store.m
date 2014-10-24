//
//  coubrRemoteManager+Store.m
//  coubr
//
//  Created by Sebastian Hof on 19/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrRemoteManager+Store.h"
#import "coubrConstants.h"

@implementation coubrRemoteManager (Store)

- (void)loadStoreJSONWithStoreId:(NSString *)storeId
               completionHandler:(void (^)(NSDictionary *))onCompletion
                    errorHandler:(void(^)(NSInteger))onError {
    
    NSURL *url = [NSURL URLWithString:STORE_BASE_URL];
    url = [url URLByAppendingPathComponent:storeId];
    
    [self loadJSONFromRemoteWithURL:url completionHandler:onCompletion errorHandler:onError];
    
}

@end

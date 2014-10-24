//
//  coubrRemoteManager+Store.h
//  coubr
//
//  Created by Sebastian Hof on 19/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrRemoteManager.h"

@interface coubrRemoteManager (Store)

- (void)loadStoreJSONWithStoreId:(NSString *)storeId
                    completionHandler:(void (^)(NSDictionary *))onCompletion
                         errorHandler:(void(^)(NSInteger))onError;

@end

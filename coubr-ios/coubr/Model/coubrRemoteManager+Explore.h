//
//  coubrRemoteManager+Explore.h
//  coubr
//
//  Created by Sebastian Hof on 18/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrRemoteManager.h"

@interface coubrRemoteManager (Explore)

- (void)loadExploreJSONWithinDistance:(double)distance
                    completionHandler:(void (^)(NSDictionary *))onCompletion
                         errorHandler:(void(^)(NSInteger))onError;

@end

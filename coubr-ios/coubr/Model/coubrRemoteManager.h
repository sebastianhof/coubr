//
//  coubrRemoteManager.h
//  coubr
//
//  Created by Sebastian Hof on 18/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface coubrRemoteManager : NSObject <NSURLSessionDelegate>

+ (instancetype)defaultManager;

- (void)loadJSONFromRemoteWithRequestJSONData:(NSData *)JSONData
                                 andURL:(NSURL *)url
                            completionHandler:(void (^)(NSDictionary *))onCompletion
                                 errorHandler:(void(^)(NSInteger))onError;

- (void)loadJSONFromRemoteWithURL:(NSURL *)url
                            completionHandler:(void (^)(NSDictionary *))onCompletion
                                 errorHandler:(void(^)(NSInteger))onError;

@end

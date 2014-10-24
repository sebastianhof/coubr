//
//  coubrRemoteManager.m
//  coubr
//
//  Created by Sebastian Hof on 18/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "coubrRemoteManager.h"
#import "coubrConstants.h"
#import "coubrUtil.h"

@implementation coubrRemoteManager


static coubrRemoteManager *remoteManagerInstance = nil;

+ (instancetype)defaultManager
{
    if (!remoteManagerInstance)
    {
        remoteManagerInstance = [[self alloc] init];
    }
    return remoteManagerInstance;
}

- (void)loadJSONFromRemoteWithRequestJSONData:(NSData *)JSONData
                                       andURL:(NSURL *)url
                            completionHandler:(void (^)(NSDictionary *))onCompletion
                                 errorHandler:(void(^)(NSInteger))onError
{
    
    // Prepare HTTP Request
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:[NSString stringWithFormat:@"%lu", [JSONData length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:JSONData];
    
    [self loadJSONFromRemoteWithURLRequest:request completionHandler:onCompletion errorHandler:onError];
    
}

- (void)loadJSONFromRemoteWithURL:(NSURL *)url
            completionHandler:(void (^)(NSDictionary *))onCompletion
                 errorHandler:(void(^)(NSInteger))onError
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self loadJSONFromRemoteWithURLRequest:request completionHandler:onCompletion errorHandler:onError];
    
}

- (void)loadJSONFromRemoteWithURLRequest:(NSURLRequest *)request
                       completionHandler:(void (^)(NSDictionary *))onCompletion
                            errorHandler:(void(^)(NSInteger))onError
{
    
    // Prepare Session

    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    sessionConfiguration.allowsCellularAccess = YES;
    sessionConfiguration.timeoutIntervalForRequest = TIMEOUT_INTERVAL_FOR_REQUEST;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    
    // Prepare Download Task
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        
        NSDictionary *jsonDictionary;
        NSError *jsonError;
        if (data) {
            jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        }
        
        NSInteger status = 0;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            status = ((NSHTTPURLResponse *) response).statusCode;
        }
        
        if (error || jsonError || status >= 400) {
            NSLog(@"Could not load data from remote: %@", error.localizedDescription);

            
            if (jsonDictionary) {
                
                NSString *code = isValidJSONValue(jsonDictionary[COUBR_ERROR_CODE]) ? jsonDictionary[COUBR_ERROR_CODE] : nil;
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setNumberStyle:NSNumberFormatterNoStyle];
                
                if (onError) {
                    onError([[formatter numberFromString:code] integerValue]);
                }
                
            } else {
                
                if (onError) {
                    onError(UNKNOWN_ERROR);
                }
                
            }

        } else {
            
            if (onCompletion) {
                onCompletion(jsonDictionary);
            }
            
        }
 
        
    }];

    // Download
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [dataTask resume];
    
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    
    NSLog(@"Ignore untrusted sources. Only during beta");
    
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}


@end

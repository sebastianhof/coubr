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
                                 andURLString:(NSString *)urlString
                            completionHandler:(void (^)(NSDictionary *))onCompletion
                                 errorHandler:(void(^)())onError
{
    
    // Prepare HTTP Request
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:EXPLORE_URL]];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:[NSString stringWithFormat:@"%lu", [JSONData length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:JSONData];
    
    // Prepare Session
    
    // currently there is a bug in iOS 8
    
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
        if (error || jsonError) {
            NSLog(@"Could not load data from remote: %@", error.localizedDescription);
            
            NSMutableDictionary *errorDictionary = [[NSMutableDictionary alloc] init];
            
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                [errorDictionary setValue:[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]] forKey:@"status"];
            }
            
            if (jsonDictionary) {
                [errorDictionary setValue:[jsonDictionary valueForKey:COUBR_ERROR_CODE] forKey:@"code"];
            }
            
            if (onError) {
                onError(errorDictionary);
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

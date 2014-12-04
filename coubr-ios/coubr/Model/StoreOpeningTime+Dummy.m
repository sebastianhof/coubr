//
//  StoreOpeningTime+Dummy.m
//  coubr
//
//  Created by Sebastian Hof on 22/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "StoreOpeningTime+Dummy.h"
#import "coubrConstants.h"

@implementation StoreOpeningTime (Dummy)

+ (NSArray *)openingTimes
{
    
    NSMutableArray *openingTimes = [[NSMutableArray alloc] init];
    
    NSDictionary *tuesday = @{
                             
                             STORE_RESPONSE_OPENING_TIME_WEEKDAY: [NSNumber numberWithInt:3],
                             STORE_RESPONSE_OPENING_TIME_BEGIN_HOUR: [NSNumber numberWithInt:10],
                             STORE_RESPONSE_OPENING_TIME_BEGIN_MINUTE: [NSNumber numberWithInt:0],
                             STORE_RESPONSE_OPENING_TIME_END_HOUR: [NSNumber numberWithInt:20],
                             STORE_RESPONSE_OPENING_TIME_END_MINUTE: [NSNumber numberWithInt:0],
                             
                             };
    
    NSDictionary *wednesday = @{
                             
                             STORE_RESPONSE_OPENING_TIME_WEEKDAY: [NSNumber numberWithInt:4],
                             STORE_RESPONSE_OPENING_TIME_BEGIN_HOUR: [NSNumber numberWithInt:11],
                             STORE_RESPONSE_OPENING_TIME_BEGIN_MINUTE: [NSNumber numberWithInt:0],
                             STORE_RESPONSE_OPENING_TIME_END_HOUR: [NSNumber numberWithInt:20],
                             STORE_RESPONSE_OPENING_TIME_END_MINUTE: [NSNumber numberWithInt:0],
                             
                             };
    
    NSDictionary *thursday = @{
                             
                             STORE_RESPONSE_OPENING_TIME_WEEKDAY: [NSNumber numberWithInt:5],
                             STORE_RESPONSE_OPENING_TIME_BEGIN_HOUR: [NSNumber numberWithInt:12],
                             STORE_RESPONSE_OPENING_TIME_BEGIN_MINUTE: [NSNumber numberWithInt:0],
                             STORE_RESPONSE_OPENING_TIME_END_HOUR: [NSNumber numberWithInt:20],
                             STORE_RESPONSE_OPENING_TIME_END_MINUTE: [NSNumber numberWithInt:0],
                             
                             };
    
    NSDictionary *friday = @{
                             
                             STORE_RESPONSE_OPENING_TIME_WEEKDAY: [NSNumber numberWithInt:6],
                             STORE_RESPONSE_OPENING_TIME_BEGIN_HOUR: [NSNumber numberWithInt:13],
                             STORE_RESPONSE_OPENING_TIME_BEGIN_MINUTE: [NSNumber numberWithInt:0],
                             STORE_RESPONSE_OPENING_TIME_END_HOUR: [NSNumber numberWithInt:20],
                             STORE_RESPONSE_OPENING_TIME_END_MINUTE: [NSNumber numberWithInt:0],
                             
                             };

    NSDictionary *saturday = @{
                             
                             STORE_RESPONSE_OPENING_TIME_WEEKDAY: [NSNumber numberWithInt:7],
                             STORE_RESPONSE_OPENING_TIME_BEGIN_HOUR: [NSNumber numberWithInt:14],
                             STORE_RESPONSE_OPENING_TIME_BEGIN_MINUTE: [NSNumber numberWithInt:30],
                             STORE_RESPONSE_OPENING_TIME_END_HOUR: [NSNumber numberWithInt:20],
                             STORE_RESPONSE_OPENING_TIME_END_MINUTE: [NSNumber numberWithInt:0],
                             
                             };
    
    NSDictionary *sunday = @{
                             
                             STORE_RESPONSE_OPENING_TIME_WEEKDAY: [NSNumber numberWithInt:1],
                             STORE_RESPONSE_OPENING_TIME_BEGIN_HOUR: [NSNumber numberWithInt:9],
                             STORE_RESPONSE_OPENING_TIME_BEGIN_MINUTE: [NSNumber numberWithInt:0],
                             STORE_RESPONSE_OPENING_TIME_END_HOUR: [NSNumber numberWithInt:15],
                             STORE_RESPONSE_OPENING_TIME_END_MINUTE: [NSNumber numberWithInt:0],
                             
                             };
    
    [openingTimes addObject:tuesday];
    [openingTimes addObject:wednesday];
    [openingTimes addObject:thursday];
    [openingTimes addObject:friday];
    [openingTimes addObject:saturday];
    [openingTimes addObject:sunday];
    
    return openingTimes;
}

@end
